pragma solidity 0.6.10;

import "@nomiclabs/buidler/console.sol";
import "@pie-dao/proxy/contracts/PProxyPausable.sol";

// Imports
import "./EternalStorage.sol";
import "./lib/StorageHelper.sol";
import "./lib/StringHelper.sol";
import "./InsurancePool.sol";

/// @author PanDAO - https://pandao.org
/// @title PanDAO Contract Network Manager
/// @notice This contract can be used by PanDAO to manage `InsurancePools` and resolve claims
/// @dev All functionality controlled by Aragon AGENT
contract Manager {
  /// @dev Gives access to PanDAO Eternal Storage
  address internal eternalStorageAddress;
  EternalStorage internal eternalStorage;

  //////////////////////////////
  /// @notice Modifiers
  /////////////////////////////

  /// @dev Ensures only Aragon Agent can call functions
  modifier onlyAgent() {
    require(
      eternalStorage.getAddress(StorageHelper.formatGet("dao.agent")) == msg.sender,
      "PanDAO: UnAuthorized - Agent only"
    );
    _;
  }

  /// @dev Ensures only the owning contract can call functions
  modifier onlyOwner(address _owner, address _contractAddress) {
    require(
      eternalStorage.getAddress(StorageHelper.formatAddress("contract.owner", _contractAddress)) ==
        _owner,
      "PanDAO: UnAuthorized - Contract owner only"
    );
    _;
  }

  //////////////////////////////
  /// @notice Events
  /////////////////////////////

  event InsurancePoolCreated(address indexed insurancePoolAddress, string symbol);

  event InsurancePoolPaused(address indexed insurancePoolAddress, string symbol);

  constructor(address _eternalStorageAddress) public {
    eternalStorageAddress = _eternalStorageAddress;
    eternalStorage = EternalStorage(eternalStorageAddress);
  }

  //////////////////////////////
  /// @notice Public Functions
  /////////////////////////////

  /// @notice Create a new PanDAO Insurance Pool
  /// @dev This function can only be called by the Aragon Agent
  /// @param _insuredAssetAddress address of the digital asset we want to insure
  /// @param _insuredAssetSymbol string token symbol
  /// @param _insureeFeeRate uint256 fee the insuree pays
  /// @param _serviceFeeRate uint256 DAO fee
  /// @param _premiumPeriod uint256 how often premium is pulled from the wallet insuree's wallet
  function createInsurancePool(
    address _insuredAssetAddress,
    string memory _insuredAssetSymbol,
    uint256 _insureeFeeRate,
    uint256 _serviceFeeRate,
    uint256 _premiumPeriod
  ) public onlyAgent() {
    require(
      eternalStorage.getAddress(
        StorageHelper.formatAddress("contract.address", _insuredAssetAddress)
      ) == address(0),
      "PanDAO: Insurance Pool already exists"
    );

    InsurancePool insurancePool = new InsurancePool(
      _insuredAssetAddress,
      _insuredAssetSymbol,
      _insureeFeeRate,
      _serviceFeeRate,
      _premiumPeriod,
      eternalStorageAddress
    );

    PProxyPausable proxy = new PProxyPausable();
    proxy.setImplementation(address(insurancePool));
    proxy.setPauzer(address(this));
    proxy.setProxyOwner(address(this));

    emit InsurancePoolCreated(address(insurancePool), _insuredAssetSymbol);
  }

  function pauseNetwork() public onlyAgent() {}

  function approveInsuranceClaim() public onlyAgent() {}

  function denyInsuranceClaim() public onlyAgent() {}

  function updateContractImplementation() public onlyAgent() {}
}
