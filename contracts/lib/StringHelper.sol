// SPDX-License-Identifier: GPLv3

pragma solidity 0.6.10;

library StringHelper {
  function concat(string memory a, string memory b) external pure returns (string memory) {
    return string(abi.encodePacked(a, b));
  }

  /// @notice convert address to string
  function toString(address account) external pure returns (string memory) {
    return string(abi.encodePacked(account));
  }
}
