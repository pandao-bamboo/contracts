pragma solidity ^0.6.0;
import "../EternalStorage.sol";
import "./StringHelper.sol";
import "@nomiclabs/buidler/console.sol";

library StorageHelper {
  /// @notice Initialized a new contract in EternalStorage
  /// @param _eternalStorage EternalStorage storage contract instance
  /// @param _contractAddress address Contract address to be initialized
  /// @param _contractOwnerAddress address Contract/Wallet address of owner(msg.sender)
  /// @param _contractName string Usually the insurableAssetSymbol
  function initializeInsurancePool(
    EternalStorage _eternalStorage,
    address _contractAddress,
    address _contractOwnerAddress,
    string memory _contractName,
    address _insuredAssetAddress
  ) internal returns (bool) {
    /// @dev initialize contract in EternalStorage
    _eternalStorage.setAddress(
      formatAddress("contract.owner", _contractAddress),
      _contractOwnerAddress
    );
    _eternalStorage.setAddress(formatString("contract.name", _contractName), _contractAddress);
    _eternalStorage.setAddress(
      formatAddress("contract.address", _contractAddress),
      _contractAddress
    );

    /// @dev Initialize insurance pool Pool in EternalStorage
    _eternalStorage.setString(
      formatAddress("insurance.pool.name", _insuredAssetAddress),
      _contractName
    );
    _eternalStorage.setAddress(
      formatAddress("insurance.pool.address", _insuredAssetAddress),
      _contractAddress
    );

    return true;
  }

  /// @notice Saves Insurance Pool Data to EternalStorage
  /// @param _eternalStorage EternalStorage storage contract instance
  /// @param _insurancePoolAddress address Insurance pool address
  /// @param _liquidityTokenAddress address Liquidity Token address
  /// @param _claimsTokenAddress address Claims token address
  /// @param _insuredAssetAddress address Insured asset address
  /// @param _insuredAssetSymbol string Token symbol
  /// @param _insureeFeeRate uint256 Rate insurance buyer pays
  /// @param _serviceFeeRate uint256 Rate paid to the DAO
  /// @param _premiumPeriod uint256 Premium period in blocks
  /// @dev insureeFeeRate - serviceFeeRate = Liquidity Provider Earnings
  function saveInsurancePool(
    EternalStorage _eternalStorage,
    address _insurancePoolAddress,
    address _liquidityTokenAddress,
    address _claimsTokenAddress,
    address _insuredAssetAddress,
    string memory _insuredAssetSymbol,
    uint256 _insureeFeeRate,
    uint256 _serviceFeeRate,
    uint256 _premiumPeriod
  ) internal {
    /// @dev Saves IPool to EternalStorage
    _eternalStorage.setAddress(
      formatAddress("insurance.pool.liquidityToken", _insuredAssetAddress),
      _liquidityTokenAddress
    );
    _eternalStorage.setAddress(
      formatAddress("insurance.pool.claimsToken", _insuredAssetAddress),
      _claimsTokenAddress
    );
    _eternalStorage.setAddress(
      formatAddress("insurance.pool.address", _insuredAssetAddress),
      _insurancePoolAddress
    );
    _eternalStorage.setAddress(
      formatAddress("insurance.pool.insuredAsset", _insuredAssetAddress),
      _insuredAssetAddress
    );
    _eternalStorage.setString(
      formatAddress("insurance.pool.insuredAssetSymbol", _insuredAssetAddress),
      _insuredAssetSymbol
    );
    _eternalStorage.setUint(
      formatAddress("insurance.pool.insureeFeeRate", _insuredAssetAddress),
      _insureeFeeRate
    );
    _eternalStorage.setUint(
      formatAddress("insurance.pool.serviceFeeRate", _insuredAssetAddress),
      _serviceFeeRate
    );
    _eternalStorage.setUint(
      formatAddress("insurance.pool.premiumPeriod", _insuredAssetAddress),
      _premiumPeriod
    );
  }

  /// @notice Update the Insurance Pool liquidity and an existing or new liquidity provider adds liquidity
  function updateLiquidity(
    EternalStorage _eternalStorage,
    address _insuredAssetAddress,
    address _liquidityProviderAddress,
    uint256 _amount
  ) internal {
    // /// @notice Get depositers liquidity providers current balance
    // /// @notice update the depositers liquidity provider balance
    // /// @notice Get current InsurancePool balance
    // /// @notice update the pool balance
    uint256 balance = _eternalStorage.getUint(
      formatAddress("insurance.pool.balance", _insuredAssetAddress)
    );

    // _eternalStorage.setUint(
    //   formatAddress("insurance.pool.balance", _insuredAssetAddress),
    //   _amount + balance
    // );
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
}
