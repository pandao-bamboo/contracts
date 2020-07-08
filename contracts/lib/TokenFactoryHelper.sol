// SPDX-License-Identifier: GPLv3

pragma solidity 0.6.10;

import "../factories/TokenFactory.sol";
import "../EternalStorage.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

library TokenFactoryHelper {
  function createTokens(
    address _insurancePoolAddress,
    uint256 _coverageStartBlock,
    EternalStorage _eternalStorage
  ) external returns (address[2] memory tokens) {
    address insuredAssetAddress = _eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.insuredAsset", _insurancePoolAddress)
    );
    ERC20 insuredAsset = ERC20(insuredAssetAddress);

    TokenFactory tokenFactory = TokenFactory(
      _eternalStorage.getAddress(StorageHelper.formatString("contract.name", "TokenFactory"))
    );

    return tokenFactory.createTokens(_insurancePoolAddress, _coverageStartBlock, "BTC++");
  }
}
