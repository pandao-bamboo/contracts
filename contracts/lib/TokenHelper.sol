// SPDX-License-Identifier: GPLv3

pragma solidity ^0.6.10;

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
      "CLAIMS",
      _insurancePoolAddress,
      _eternalStorageAddress
    );

    emit TokenCreated(claimsToken.name(), claimsToken.symbol(), address(claimsToken));

    return claimsToken;
  }

  /// @notice Create a Collateral Token(RPAN)
  function createCollateralToken(
    address _eternalStorageAddress,
    address _insurancePoolAddress,
    uint256 _coverageStartBlock,
    string memory _insuredAssetSymbol
  ) external returns (InsuranceToken collateralToken) {
    string memory collateralTokenPartOne = StringHelper.concat(
      "PanDAO Collateral Token - ",
      _insuredAssetSymbol
    );
    string memory collateralTokenPartTwo = StringHelper.concat(collateralTokenPartOne, " - ");
    string memory collateralTokenName = StringHelper.concat(
      collateralTokenPartTwo,
      StringHelper.toStringUint(_coverageStartBlock)
    );

    collateralToken = new InsuranceToken(
      collateralTokenName,
      "RPAN",
      "COLLATERAL",
      _insurancePoolAddress,
      _eternalStorageAddress
    );

    emit TokenCreated(collateralToken.name(), collateralToken.symbol(), address(collateralToken));

    return collateralToken;
  }

  /// @notice Create a Liquidity Token(LPAN)
  function createLiquidityToken(
    address _insuredAssetAddress,
    address _liquidityPoolAddress,
    string memory _insuredAssetSymbol,
    address _eternalStorageAddress
  ) external returns (InsuranceToken liquidityToken) {
    string memory liquidityTokenName = StringHelper.concat(
      "PanDAO Liquidity Token - ",
      _insuredAssetSymbol
    );

    ERC20 insuredAsset = ERC20(_insuredAssetAddress);

    liquidityToken = new LiquidityToken(
      liquidityTokenName,
      "LPAN",
      insuredAsset.decimals(),
      _liquidityPoolAddress,
      _eternalStorageAddress
    );

    emit TokenCreated(liquidityToken.name(), liquidityToken.symbol(), address(liquidityToken));

    return liquidityToken;
  }
}
