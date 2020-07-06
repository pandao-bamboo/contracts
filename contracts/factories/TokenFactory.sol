pragma solidity 0.6.10;

import "../lib/StorageHelper.sol";
import "../lib/PoolsHelper.sol";

contract TokenFactory {
  address internal eternalStorageAddress;

  constructor(address _eternalStorageAddress) public {
    eternalStorageAddress = _eternalStorageAddress;
  }

  function createTokens(string memory _insurableAssetSymbol, address _insurancePoolAddress)
    external
    returns (address[2] memory tokens)
  {
    tokens = [
      address(
        PoolsHelper.createLiquidityToken(
          _insurableAssetSymbol,
          _insurancePoolAddress,
          eternalStorageAddress
        )
      ),
      address(
        PoolsHelper.createClaimsToken(
          _insurableAssetSymbol,
          _insurancePoolAddress,
          eternalStorageAddress
        )
      )
    ];

    return tokens;
  }
}
