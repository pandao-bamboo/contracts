// SPDX-License-Identifier: GPLv3
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

// Gelato Dependencies
import {Task} from "@gelatonetwork/core/contracts/gelato_core/interfaces/IGelatoCore.sol";
import {
  GelatoProviderModuleStandard
} from "@gelatonetwork/core/contracts/provider_modules/GelatoProviderModuleStandard.sol";

import "../EternalStorage.sol";
import "../lib/StorageHelper.sol";
import "@nomiclabs/buidler/console.sol";

/// @title PanDaoProviderModule
/// @author Hilmar X
/// @notice Used to a) make sure only InsurancePools can execute Tx's and have PanDAOs GelatoManager pay for it
/// b) Channels the encoded Payload from each Insurance Pool contract to GelatoCore
contract PanDaoProviderModule is GelatoProviderModuleStandard {
  address internal eternalStorageAddress;
  EternalStorage internal eternalStorage;

  constructor(address _eternalStorageAddress) public {
    eternalStorageAddress = _eternalStorageAddress;
    eternalStorage = EternalStorage(eternalStorageAddress);
  }

  // Verify that the address requesting execution is a PanDAO Insurance Pool
  function isProvided(
    address _addressRequestingExecution,
    address,
    Task calldata
  ) external override view returns (string memory isOk) {
    address storedInsurancePool = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.address", _addressRequestingExecution)
    );
    isOk = _addressRequestingExecution == storedInsurancePool
      ? "OK"
      : "InsurancePoolModule: Address is not InsurancePool";
  }

  // Function called by gelato core before scheduleFutureFeePayment
  function execPayload(
    uint256,
    address,
    address,
    Task calldata _task,
    uint256
  ) external virtual override view returns (bytes memory, bool) {
    return (_task.actions[0].data, false);
  }
}
