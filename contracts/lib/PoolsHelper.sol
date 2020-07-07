// SPDX-License-Identifier: GPLv3

pragma solidity 0.6.10;

import "../tokens/InsuranceToken.sol";
import "./StringHelper.sol";

library PoolsHelper {
  event TokenCreated(string _tokenName, string _tokenSymbol, address indexed _tokenAddress);

  /// @notice Create a claim token(CPAN)
  /// @param _insurableAssetSymbol string Insured token symbol
  /// @return claimsToken InsuranceToken New Claims Token
  function createClaimsToken(
    string memory _insurableAssetSymbol,
    address _insurancePoolAddress,
    address _eternalStorageAddress
  ) external returns (InsuranceToken claimsToken) {
    string memory claimsTokenName = StringHelper.concat(
      "PanDAO Claims Token - ",
      _insurableAssetSymbol
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
  /// @param _insurableAssetSymbol string Insured token symbol
  /// @return liquidityToken InsuranceToken New Liquidity Token
  function createLiquidityToken(
    string memory _insurableAssetSymbol,
    address _insurancePoolAddress,
    address _eternalStorageAddress
  ) external returns (InsuranceToken liquidityToken) {
    string memory liquidityTokenName = StringHelper.concat(
      "PanDAO Liquidity Token - ",
      _insurableAssetSymbol
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
