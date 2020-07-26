// SPDX-License-Identifier: GPLv3

pragma solidity ^0.6.10;

import "../EternalStorage.sol";
import "./StringHelper.sol";
import "./TokenFactoryHelper.sol";

library StorageHelper {
  /// @notice Initialized a new contract in EternalStorage
  function registerInsurancePool(
    address _insurancePoolAddress,
    address _liquidityPoolAddress,
    address _contractOwnerAddress,
    address _insuredAssetAddress,
    uint256 _insureeFeeRate,
    uint256 _serviceFeeRate,
    uint256 _coverageStartBlock,
    uint256 _coverageDuration,
    EternalStorage _eternalStorage
  ) external returns (bool) {
    // Global Contract Registration
    _eternalStorage.setAddress(
      formatAddress("contract.owner", _insurancePoolAddress),
      _contractOwnerAddress
    );
    _eternalStorage.setAddress(
      formatAddress("contract.address", _insurancePoolAddress),
      _insurancePoolAddress
    );

    // Pool Contract Registration
    uint256 insurancePoolRegistryCounter = _eternalStorage.getUint(
      formatAddress("insurance.pool.registry.counter", _insuredAssetAddress)
    );
    uint256 registryIndexCount = SafeMath.add(insurancePoolRegistryCounter, 1);

    _eternalStorage.setUint(
      formatAddress("insurance.pool.registry.counter", _insuredAssetAddress),
      registryIndexCount
    );
    bytes32 insurancePoolRegistryLocation = formatAddress(
      StringHelper.concat(
        "insurance.pool.registry.",
        StringHelper.toStringUint(registryIndexCount)
      ),
      _insuredAssetAddress
    );

    _eternalStorage.setAddress(insurancePoolRegistryLocation, _insurancePoolAddress);
    ERC20 insuredAsset = ERC20(_insuredAssetAddress);

    address[2] memory tokens = TokenFactoryHelper.createTokens(
      _insurancePoolAddress,
      insuredAsset.symbol(),
      _coverageStartBlock,
      _eternalStorage
    );

    storeInsurancePoolConfiguration(
      _insurancePoolAddress,
      _liquidityPoolAddress,
      _insuredAssetAddress,
      _insureeFeeRate,
      _serviceFeeRate,
      _coverageStartBlock,
      _coverageDuration,
      tokens,
      _eternalStorage
    );

    return true;
  }

  function storeInsurancePoolConfiguration(
    address _insurancePoolAddress,
    address _liquidityPoolAddress,
    address _insuredAssetAddress,
    uint256 _insureeFeeRate,
    uint256 _serviceFeeRate,
    uint256 _coverageStartBlock,
    uint256 _coverageDuration,
    address[2] memory _tokens,
    EternalStorage _eternalStorage
  ) internal returns (bool) {
    // Insurance Pool Configuration Data
    _eternalStorage.setAddress(
      formatAddress("insurance.pool.collateralToken", _insurancePoolAddress),
      _tokens[0]
    );
    _eternalStorage.setAddress(
      formatAddress("insurance.pool.claimsToken", _insurancePoolAddress),
      _tokens[1]
    );
    _eternalStorage.setAddress(
      formatAddress("insurance.pool.address", _insurancePoolAddress),
      _insurancePoolAddress
    );
    _eternalStorage.setAddress(
      formatAddress("insurance.pool.insuredAsset", _insurancePoolAddress),
      _insuredAssetAddress
    );
    _eternalStorage.setUint(
      formatAddress("insurance.pool.insureeFeeRate", _insurancePoolAddress),
      _insureeFeeRate
    );
    _eternalStorage.setUint(
      formatAddress("insurance.pool.serviceFeeRate", _insurancePoolAddress),
      _serviceFeeRate
    );
    _eternalStorage.setUint(
      formatAddress("insurance.pool.coverageStartBlock", _insurancePoolAddress),
      _coverageStartBlock
    );
    _eternalStorage.setUint(
      formatAddress("insurance.pool.coverageDuration", _insurancePoolAddress),
      _coverageDuration
    );
    _eternalStorage.setUint(
      formatAddress("insurance.pool.liquidityPool", _insurancePoolAddress),
      _liquidityPoolAddress
    );
  }

  /// @notice Add new collateral to Insurance Pool
  /// @param _collateralProviderAddress address
  /// @param _insurancePoolAddress address
  /// @param _amount uint256
  function addCollateral(
    EternalStorage _eternalStorage,
    address _collateralProviderAddress,
    address _insurancePoolAddress,
    uint256 _amount
  ) external {
    uint256 balance = _eternalStorage.getUint(
      formatAddress("insurance.pool.balance", _insurancePoolAddress)
    );
    uint256 updatedBalance = SafeMath.add(balance, _amount);

    _eternalStorage.setUint(
      formatAddress("insurance.pool.balance", _insurancePoolAddress),
      updatedBalance
    );

    bytes32 userBalanceLocation = formatAddress(
      StringHelper.concat(
        "insurance.pool.userBalance",
        StringHelper.toString(_collateralProviderAddress)
      ),
      _insurancePoolAddress
    );
    uint256 userBalance = _eternalStorage.getUint(userBalanceLocation);
    uint256 updatedUserBalance = SafeMath.add(userBalance, _amount);
    _eternalStorage.setUint(userBalanceLocation, updatedUserBalance);
  }

  function getInsurancePoolAddress(address _insuredAssetAddress, address _eternalStorageAddress)
    external
    view
    returns (address insurancePoolAddress)
  {
    EternalStorage eternalStorage = EternalStorage(_eternalStorageAddress);
    uint256 registryIndexPosition = eternalStorage.getUint(
      formatAddress("insurance.pool.registry.counter", _insuredAssetAddress)
    );

    insurancePoolAddress = getInsurancePoolAddressByIndex(
      _insuredAssetAddress,
      registryIndexPosition,
      eternalStorage
    );

    return insurancePoolAddress;
  }

  /// @notice removes collateral from Insurance pool
  /// @param _collateralProviderAddress address
  /// @param _insurancePoolAddress address
  /// @param _amount uint256
  function removeCollateral(
    EternalStorage _eternalStorage,
    address _collateralProviderAddress,
    address _insurancePoolAddress,
    uint256 _amount
  ) external {
    uint256 balance = _eternalStorage.getUint(
      formatAddress("insurance.pool.balance", _insurancePoolAddress)
    );
    uint256 updatedBalance = SafeMath.sub(balance, _amount);
    _eternalStorage.setUint(
      formatAddress("insurance.pool.balance", _insurancePoolAddress),
      updatedBalance
    );

    bytes32 userBalanceLocation = formatAddress(
      StringHelper.concat(
        "insurance.pool.userBalance",
        StringHelper.toString(_collateralProviderAddress)
      ),
      _insurancePoolAddress
    );
    uint256 userBalance = _eternalStorage.getUint(userBalanceLocation);
    uint256 updatedUserBalance = SafeMath.sub(userBalance, _amount);
    _eternalStorage.setUint(userBalanceLocation, updatedUserBalance);
  }

  /// @notice Format Storage Locations into bytes32
  function formatAddress(string memory _storageLocation, address _value)
    internal
    pure
    returns (bytes32)
  {
    return keccak256(abi.encode(_storageLocation, _value));
  }

  function formatBool(string memory _storageLocation, bool _value) internal pure returns (bytes32) {
    return keccak256(abi.encode(_storageLocation, _value));
  }

  function formatInt(string memory _storageLocation, int256 _value)
    internal
    pure
    returns (bytes32)
  {
    return keccak256(abi.encode(_storageLocation, _value));
  }

  function formatString(string memory _storageLocation, string memory _value)
    internal
    pure
    returns (bytes32)
  {
    return keccak256(abi.encode(_storageLocation, _value));
  }

  function formatUint(string memory _storageLocation, uint256 _value)
    internal
    pure
    returns (bytes32)
  {
    return keccak256(abi.encode(_storageLocation, _value));
  }

  // Getter Format
  function formatGet(string memory _location) internal pure returns (bytes32) {
    return keccak256(abi.encode(_location));
  }

  function getInsurancePoolAddressByIndex(
    address _insuredAssetAddress,
    uint256 _registryIndexPosition,
    EternalStorage _eternalStorage
  ) internal view returns (address insurancePoolAddress) {
    bytes32 insurancePoolRegistryLocation = formatAddress(
      StringHelper.concat(
        "insurance.pool.registry.",
        StringHelper.toStringUint(_registryIndexPosition)
      ),
      _insuredAssetAddress
    );

    insurancePoolAddress = _eternalStorage.getAddress(insurancePoolRegistryLocation);

    return insurancePoolAddress;
  }
}
