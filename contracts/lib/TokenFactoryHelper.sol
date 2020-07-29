// SPDX-License-Identifier: GPLv3

pragma solidity ^0.6.10;

import "../factories/TokenFactory.sol";
import "../EternalStorage.sol";

library TokenFactoryHelper {
  function createTokens(
    address _insurancePoolAddress,
    string memory _insuredAssetSymbol,
    uint256 _coverageStartBlock,
    EternalStorage _eternalStorage
  ) external returns (address[2] memory tokens) {
    TokenFactory tokenFactory = TokenFactory(
      _eternalStorage.getAddress(StorageHelper.formatString("contract.name", "TokenFactory"))
    );

    return
      tokenFactory.createTokens(_insurancePoolAddress, _coverageStartBlock, _insuredAssetSymbol);
  }
}
