pragma solidity ^0.6.0;
import "../EternalStorage.sol";


library StorageHelper {
  /// @notice Initialized a new contract in EternalStorage
  /// @param _eternalStorage EternalStorage storage contract instance
  /// @param _contractAddress address Contract address to be initialized
  /// @param _contractOwner address Contract/Wallet address of owner(msg.sender)
  /// @param _contractName string Usually the insurableTokenSymbol
  function initializeInsurancePool(
    EternalStorage _eternalStorage,
    address _contractAddress,
    address _contractOwner,
    string memory _contractName
  ) internal returns (bool) {
    /// @dev initialize contract in EternalStorage
    _eternalStorage.setAddress(formatAddress("contract.owner", _contractAddress), _contractOwner);
    _eternalStorage.setAddress(
      formatString("insurance.pool.name", _contractName),
      _contractAddress
    );
    _eternalStorage.setAddress(
      formatAddress("insurance.pool.address", _contractAddress),
      _contractAddress
    );

    return true;
  }

  /// @notice Saves Insurance Pool Data to EternalStorage
  /// @param _eternalStorage EternalStorage storage contract instance
  /// @param _insurancePoolAddress address Insurance pool address
  /// @param _collateralTokenAddress address Collateral token address
  /// @param _claimsTokenAddress address Claims token address
  /// @param _insuredTokenAddress address Insured token address
  /// @param _insuredTokenSymbol string Token symbol
  /// @param _insureeFeeRate uint256 Rate insurance buyer pays
  /// @param _serviceFeeRate uint256 Rate paid to the DAO
  /// @param _premiumPeriod uint256 Premium period in blocks
  /// @dev insureeFeeRate - serviceFeeRate = Liquidity Provider Earnings
  function saveInsurancePool(
    EternalStorage _eternalStorage,
    address _insurancePoolAddress,
    address _collateralTokenAddress,
    address _claimsTokenAddress,
    address _insuredTokenAddress,
    string memory _insuredTokenSymbol,
    uint256 _insureeFeeRate,
    uint256 _serviceFeeRate,
    uint256 _premiumPeriod
  ) internal {
    /// @dev Saves IPool to EternalStorage
    _eternalStorage.setAddress(
      formatAddress("insurance.pool.collateralToken", _insurancePoolAddress),
      _collateralTokenAddress
    );
    _eternalStorage.setAddress(
      formatAddress("insurance.pool.claimsToken", _insurancePoolAddress),
      _claimsTokenAddress
    );
    _eternalStorage.setAddress(
      formatAddress("insurance.pool.insuredToken", _insurancePoolAddress),
      _insuredTokenAddress
    );
    _eternalStorage.setAddress(
      formatAddress("insurance.pool.insuredToken", _insuredTokenAddress),
      _insuredTokenAddress
    );
    _eternalStorage.setString(
      formatAddress("insurance.pool.insuredTokenSymbol", _insurancePoolAddress),
      _insuredTokenSymbol
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
      formatAddress("insurance.pool.premiumPeriod", _insurancePoolAddress),
      _premiumPeriod
    );
  }

  // Setter Format
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
