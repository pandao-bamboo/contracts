// SPDX-License-Identifier: GPLv3

pragma solidity 0.6.10;

import "../tokens/InsuranceToken.sol";
import "./StringHelper.sol";

library TokenHelper {
  event TokenCreated(string _tokenName, string _tokenSymbol, address indexed _tokenAddress);

  /// @notice Create a claim token(CPAN)
  function createClaimsToken(
    address _eternalStorageAddress,
    address _insurancePoolAddress,
    uint256 _coverageStartBlock,
    string memory _insuredAssetSymbol
  ) external returns (InsuranceToken claimsToken) {
    string memory claimsTokenPartOne = StringHelper.concat(
      "PanDAO Claims Token - ",
      _insuredAssetSymbol
    );
    string memory claimsTokenPartTwo = StringHelper.concat(claimsTokenPartOne, " - ");
    string memory claimsTokenName = StringHelper.concat(
      claimsTokenPartTwo,
      StringHelper.toStringUint(_coverageStartBlock)
    );

    claimsToken = new InsuranceToken(
      claimsTokenName,
      "CPAN",
      _eternalStorageAddress,
      _insurancePoolAddress
    );

    emit TokenCreated(claimsToken.name(), claimsToken.symbol(), address(claimsToken));

    return claimsToken;
  }

  /// @notice Create a Liquidity Token(LPAN)
  function createLiquidityToken(
    address _eternalStorageAddress,
    address _insurancePoolAddress,
    uint256 _coverageStartBlock,
    string memory _insuredAssetSymbol
  ) external returns (InsuranceToken liquidityToken) {
    string memory liquidityTokenPartOne = StringHelper.concat(
      "PanDAO Liquidity Token - ",
      _insuredAssetSymbol
    );
    string memory liquidityTokenPartTwo = StringHelper.concat(liquidityTokenPartOne, " - ");
    string memory liquidityTokenName = StringHelper.concat(
      liquidityTokenPartTwo,
      StringHelper.toStringUint(_coverageStartBlock)
    );

    liquidityToken = new InsuranceToken(
      liquidityTokenName,
      "LPAN",
      _eternalStorageAddress,
      _insurancePoolAddress
    );

    emit TokenCreated(liquidityToken.name(), liquidityToken.symbol(), address(liquidityToken));

    return liquidityToken;
  }
}
