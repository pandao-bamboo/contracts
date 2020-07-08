// SPDX-License-Identifier: GPLv3

pragma solidity 0.6.10;

import "../lib/StorageHelper.sol";
import "../lib/TokenHelper.sol";
import "@nomiclabs/buidler/console.sol";

contract TokenFactory {
  address internal eternalStorageAddress;

  constructor(address _eternalStorageAddress) public {
    eternalStorageAddress = _eternalStorageAddress;
  }

  function createTokens(
    address _insurancePoolAddress,
    uint256 _coverageStartBlock,
    string memory _insuredAssetSymbol
  ) external returns (address[2] memory tokens) {
    tokens = [
      address(
        TokenHelper.createLiquidityToken(
          eternalStorageAddress,
          _insurancePoolAddress,
          _coverageStartBlock,
          _insuredAssetSymbol
        )
      ),
      address(
        TokenHelper.createClaimsToken(
          eternalStorageAddress,
          _insurancePoolAddress,
          _coverageStartBlock,
          _insuredAssetSymbol
        )
      )
    ];

    return tokens;
  }
}
