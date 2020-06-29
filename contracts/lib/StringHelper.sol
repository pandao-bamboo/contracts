pragma solidity 0.6.6;

library StringHelper {
  function concat(string memory a, string memory b) internal pure returns (string memory) {
    return string(abi.encodePacked(a, b));
  }

  /// @notice convert address to string
  function toString(address account) internal pure returns (string memory) {
    return string(abi.encodePacked(account));
  }
}
