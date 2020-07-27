pragma solidity ^0.6.10;

import "../Manager.sol";

import "../lib/StorageHelper.sol";
import "../lib/SafeMath.sol";

contract LiquidityToken is IERC20, Manager {
  event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
  event Transfer(address indexed _from, address indexed _to, uint256 _amount);

  constructor(
    string memory _name,
    string memory _symbol,
    uint8 _decimals,
    address _liquidityPoolAddress,
    address _eternalStorageAddress
  ) public ERC20(_name, _symbol) Manager(_eternalStorageAddress) {
    eternalStorage.setAddress(
      StorageHelper.formatAddress("contract.owner", address(this)),
      _liquidityPoolAddress
    );
    eternalStorage.setAddress(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", _liquidityPoolAddress),
      address(this)
    );

    TokenStorage liquidityTokenStorage = TokenStorage({
      name: _name,
      symbol: _symbol,
      decimals: _decimals,
      totalSupply: 0
    });

    eternalStorage.setToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this)),
      liquidityTokenStorage
    );
  }

  function _mint(uint256 _amount) internal {
    TokenStorage token = eternalStorage.getToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this))
    );

    token.balance[address(this)] = SafeMath.add(token.balance[address(this)], _amount);
    token.totalSupply = SafeMath.add(token.totalSupply, _amount);

    eternalStorage.setToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this)),
      token
    );

    emit Transfer(address(0), address(this), _amount);
  }

  function _burn(uint256 _amount) internal {
    TokenStorage token = eternalStorage.getToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this))
    );

    require(token.balance[address(this)] >= _amount, "ERR_INSUFFICIENT_BAL");

    token.balance[address(this)] = SafeMath.sub(token.balance[address(this)], _amount);
    token.totalSupply = SafeMath.sub(token.totalSupply, _amount);

    eternalStorage.setToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this)),
      token
    );

    emit Transfer(address(this), address(0), _amount);
  }

  function _move(
    address _from,
    address _to,
    uint256 _amount
  ) internal {
    TokenStorage token = eternalStorage.getToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this))
    );

    require(token.balance[_from] >= _amount, "PanDAO Error: Insufficient Balance");

    token.balance[_from] = SafeMath.sub(token.balance[_from], _amount);
    token.balance[_to] = SafeMath.add(token.balance[_to], _amount);

    eternalStorage.setToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this)),
      token
    );

    emit Transfer(_from, _to, _amount);
  }

  function balanceOf(address _owner) external override view returns (uint256) {
    TokenStorage token = eternalStorage.getToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this))
    );

    return token.balance[_owner];
  }

  function totalSupply() public override view returns (uint256) {
    TokenStorage token = eternalStorage.getToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this))
    );

    return token.totalSupply;
  }

  function name() external view returns (string memory) {
    TokenStorage token = eternalStorage.getToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this))
    );

    return token.name;
  }

  function symbol() external view returns (string memory) {
    TokenStorage token = eternalStorage.getToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this))
    );

    return token.symbol;
  }

  function approve(address _spender, uint256 _amount) external override returns (bool) {
    TokenStorage token = eternalStorage.getToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this))
    );

    token.allowance[msg.sender][_spender] = _amount;

    eternalStorage.setToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this)),
      token
    );

    emit Approval(msg.sender, _spender, _amount);

    return true;
  }

  function increaseApproval(address _spender, uint256 _amount) external returns (bool) {
    TokenStorage token = eternalStorage.getToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this))
    );

    token.allowance[msg.sender][_spender] = SafeMath.add(
      token.allowance[msg.sender][_spender],
      _amount
    );

    eternalStorage.setToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this)),
      token
    );

    emit Approval(msg.sender, _spender, _amount);

    return true;
  }

  function decreaseApproval(address _spender, uint256 _amount) external returns (bool) {
    TokenStorage token = eternalStorage.getToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this))
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

  function transfer(address _to, uint256 _amount) external override returns (bool) {
    _move(msg.sender, _to, _amount);

    return true;
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _amount
  ) external overrides returns (bool) {
    TokenStorage token = eternalStorage.getToken(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this))
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