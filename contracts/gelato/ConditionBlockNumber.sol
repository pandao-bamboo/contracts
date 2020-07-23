// "SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import {
  GelatoConditionsStandard
} from "@gelatonetwork/core/contracts/conditions/GelatoConditionsStandard.sol";

/// @title ConditionBlockNumber
/// @author Hilmar X
/// @notice Checks if a blocknumber has passed or not
///@dev This is the Condition checked by Gelato in order to see if the action (buyPremium) can be executed
contract ConditionBlockNumber is GelatoConditionsStandard {
  /// @dev use this function to encode the data off-chain for the condition data field
  function getConditionData(uint256 _blockNumber) public virtual pure returns (bytes memory) {
    return abi.encode(_blockNumber);
  }

  /// @param _conditionData The encoded data from getConditionData()
  function ok(
    uint256,
    bytes calldata _conditionData,
    uint256
  ) public virtual override view returns (string memory) {
    uint256 blockNumber = abi.decode(_conditionData, (uint256));
    return blockNumberCheck(blockNumber);
  }

  // Specific implementation
  function blockNumberCheck(uint256 _blockNumber) public virtual view returns (string memory) {
    if (_blockNumber <= block.number) return OK;
    return "NotOkBlockDidNotPass";
  }
}
