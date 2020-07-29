// SPDX-License-Identifier: GPLv3
pragma solidity ^0.6.10;

import "../lib/StorageHelper.sol";
import "../lib/SafeMath.sol";

import "../interfaces/IERC20.sol";

import "../EternalStorage.sol";

contract Token is IERC20 {
  EternalStorage eternalStorage;

  event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
  event Transfer(address indexed _from, address indexed _to, uint256 _amount);

  constructor(
    string memory _name,
    string memory _symbol,
    uint8 _decimals,
    address _eternalStorageAddress
  ) public IERC20() {
    eternalStorage = EternalStorage(_eternalStorageAddress);

    eternalStorage.setAddress(
      StorageHelper.formatAddress("contract.owner", address(this)),
      msg.sender
    );

    EternalStorage.TokenStorage memory testTokenStorage = EternalStorage.TokenStorage({
      name: _name,
      symbol: _symbol,
      decimals: _decimals,
      totalSupply: 0
    });

    eternalStorage.setToken(
      StorageHelper.formatAddress("test.token", address(this)),
      testTokenStorage
    );
  }

  function _mint(uint256 _amount) internal {
    EternalStorage.TokenStorage memory token = eternalStorage.getToken(
      StorageHelper.formatAddress("test.token", address(this))
    );

    token.balance[address(this)] = SafeMath.add(token.balance[address(this)], _amount);
    token.totalSupply = SafeMath.add(token.totalSupply, _amount);

    eternalStorage.setToken(StorageHelper.formatAddress("test.token", address(this)), token);

    emit Transfer(address(0), address(this), _amount);
  }

  function _burn(uint256 _amount) internal {
    EternalStorage.TokenStorage memory token = eternalStorage.getToken(
      StorageHelper.formatAddress("test.token", address(this))
    );

    require(token.balance[address(this)] >= _amount, "ERR_INSUFFICIENT_BAL");

    token.balance[address(this)] = SafeMath.sub(token.balance[address(this)], _amount);
    token.totalSupply = SafeMath.sub(token.totalSupply, _amount);

    eternalStorage.setToken(StorageHelper.formatAddress("test.token", address(this)), token);

    emit Transfer(address(this), address(0), _amount);
  }

  function _move(
    address _from,
    address _to,
    uint256 _amount
  ) internal {
    EternalStorage.TokenStorage memory token = eternalStorage.getToken(
      StorageHelper.formatAddress("test.token", address(this))
    );

    require(token.balance[_from] >= _amount, "PanDAO Error: Insufficient Balance");

    token.balance[_from] = SafeMath.sub(token.balance[_from], _amount);
    token.balance[_to] = SafeMath.add(token.balance[_to], _amount);

    eternalStorage.setToken(StorageHelper.formatAddress("test.token", address(this)), token);

    emit Transfer(_from, _to, _amount);
  }

  function allowance(address _owner, address _spender) external override view returns (uint256) {
    EternalStorage.TokenStorage memory token = eternalStorage.getToken(
      StorageHelper.formatAddress("test.token", address(this))
    );

    return token.allowance[_owner][_spender];
  }

  function balanceOf(address _owner) external override view returns (uint256) {
    EternalStorage.TokenStorage memory token = eternalStorage.getToken(
      StorageHelper.formatAddress("test.token", address(this))
    );

    return token.balance[_owner];
  }

  function totalSupply() public override view returns (uint256) {
    EternalStorage.TokenStorage memory token = eternalStorage.getToken(
      StorageHelper.formatAddress("test.token", address(this))
    );

    return token.totalSupply;
  }

  function name() external view returns (string memory) {
    EternalStorage.TokenStorage memory token = eternalStorage.getToken(
      StorageHelper.formatAddress("test.token", address(this))
    );

    return token.name;
  }

  function symbol() external view returns (string memory) {
    EternalStorage.TokenStorage memory token = eternalStorage.getToken(
      StorageHelper.formatAddress("test.token", address(this))
    );

    return token.symbol;
  }

  function decimals() external view returns (string memory) {
    EternalStorage.TokenStorage memory token = eternalStorage.getToken(
      StorageHelper.formatAddress("test.token", address(this))
    );

    return token.decimals;
  }

  function approve(address _spender, uint256 _amount) external override view returns (bool) {
    EternalStorage.TokenStorage memory token = eternalStorage.getToken(
      StorageHelper.formatAddress("test.token", address(this))
    );

    token.allowance[msg.sender][_spender] = _amount;

    eternalStorage.setToken(StorageHelper.formatAddress("test.token", address(this)), token);

    emit Approval(msg.sender, _spender, _amount);

    return true;
  }

  function increaseApproval(address _spender, uint256 _amount) external view returns (bool) {
    EternalStorage.TokenStorage memory token = eternalStorage.getToken(
      StorageHelper.formatAddress("test.token", address(this))
    );

    token.allowance[msg.sender][_spender] = SafeMath.add(
      token.allowance[msg.sender][_spender],
      _amount
    );

    eternalStorage.setToken(StorageHelper.formatAddress("test.token", address(this)), token);

    emit Approval(msg.sender, _spender, _amount);

    return true;
  }

  function decreaseApproval(address _spender, uint256 _amount) external returns (bool) {
    EternalStorage.TokenStorage memory token = eternalStorage.getToken(
      StorageHelper.formatAddress("test.token", address(this))
    );

    uint256 currentValue = token.allowance[msg.sender][_spender];

    if (_amount > currentValue) {
      token.allowance[msg.sender][_spender] = 0;
    } else {
      token.allowance[msg.sender][_spender] = SafeMath.sub(currentValue, _amount);
    }

    emit Approval(msg.sender, _spender, _amount);

    return true;
  }

  function transfer(address _to, uint256 _amount) external override view returns (bool) {
    _move(msg.sender, _to, _amount);

    return true;
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _amount
  ) external override returns (bool) {
    EternalStorage.TokenStorage memory token = eternalStorage.getToken(
      StorageHelper.formatAddress("test.token", address(this))
    );

    require(
      msg.sender == _from || _amount <= token.allowance[_from][msg.sender],
      "PanDAO Error: Bad Caller"
    );

    _move(_from, _to, _amount);

    if (msg.sender != _from && token.allowance[_from][msg.sender] != uint256(-1)) {
      token.allowance[_from][msg.sender] = SafeMath.sub(
        token.allowance[_from][msg.sender],
        _amount
      );

      emit Approval(msg.sender, _to, token.allowance[_from][msg.sender]);
    }

    return true;
  }
}
