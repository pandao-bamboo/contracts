// SPDX-License-Identifier: GPLv3

pragma solidity 0.6.10;

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
  address internal eternalStorageAddress;
  EternalStorage internal eternalStorage;

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

  event InsurancePoolCreated(address indexed insurancePoolAddress, string symbol);
  event InsurancePoolPaused(address indexed insurancePoolAddress, string symbol);
  event InsurancePoolInsureeFeeUpdated(address insurancePoolAddress, uint256 insureeFeeRate);
  event InsurancePoolServiceFeeUpdated(address insurancePoolAddress, uint256 serviceFeeRate);

  constructor(address _eternalStorageAddress) public {
    eternalStorageAddress = _eternalStorageAddress;
    eternalStorage = EternalStorage(eternalStorageAddress);
  }

  /// @notice Create a new PanDAO Insurance Pool
  /// @dev This function can only be called by the Aragon Agent
  /// @param _insuredAssetAddress address of the digital asset we want to insure
  /// @param _insuredAssetSymbol string token symbol
  /// @param _insureeFeeRate uint256 fee the insuree pays
  /// @param _serviceFeeRate uint256 DAO fee
  function createInsurancePool(
    address _insuredAssetAddress,
    string memory _insuredAssetSymbol,
    uint256 _insureeFeeRate,
    uint256 _serviceFeeRate,
    uint256 _coverageStartBlock,
    uint256 _coverageDuration
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
      _coverageStartBlock,
      _coverageDuration,
      eternalStorageAddress
    );

    // PProxyPausable proxy = new PProxyPausable();
    // proxy.setImplementation(address(insurancePool));
    // proxy.setPauzer(address(this));
    // proxy.setProxyOwner(address(this));

    emit InsurancePoolCreated(address(insurancePool), _insuredAssetSymbol);
  }

  function approveInsuranceClaim() public onlyAgent() {}

  function denyInsuranceClaim() public onlyAgent() {}

  function createInsuranceClaim() public onlyAgent() {}

  function pauseNetwork() public onlyAgent() {}

  function pausePool() public onlyAgent() {}

  // function setInsureeFee(address _insurancePoolAddress, uint256 _insureeFee) public onlyAgent() {
  //   eternalStorage.setUint(
  //     StorageHelper.formatAddress("insurance.pool.insureeFeeRate", _insurancePoolAddress),
  //     _insureeFee
  //   );

  //   emit InsurancePoolInsureeFeeUpdated(_insurancePoolAddress, _insureeFee);
  // }

  function setServiceFee(address _insurancePoolAddress, uint256 _serviceFee) public onlyAgent() {
    eternalStorage.setUint(
      StorageHelper.formatAddress("insurance.pool.serviceFeeRate", _insurancePoolAddress),
      _serviceFee
    );

    emit InsurancePoolServiceFeeUpdated(_insurancePoolAddress, _serviceFee);
  }

  function unpauseNetwork() public onlyAgent() {}

  function unpausePool() public onlyAgent() {}

  function updateContractImplementation() public onlyAgent() {}
}
