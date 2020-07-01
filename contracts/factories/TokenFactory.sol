pragma solidity 0.6.10;

import "../lib/StorageHelper.sol";
import "../lib/PoolsHelper.sol";

contract TokenFactory {
  address internal eternalStorageAddress;
  EternalStorage internal eternalStorage;

  event TokenCreated(string _tokenName, string _tokenSymbol, address indexed _tokenAddress);

  address[] internal tokens;

  modifier onlyPools(address sender, address _insuredAssetAddress) {
    _;

    address insurancePool = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.address", _insuredAssetAddress)
    );

    require(insurancePool == sender, "PanDAO: Only pools");
  }

  constructor(address _eternalStorageAddress) public {
    eternalStorageAddress = _eternalStorageAddress;
    eternalStorage = EternalStorage(_eternalStorageAddress);
  }

  function createTokens(
    string memory _insurableAssetSymbol,
    address _insuredAssetAddress,
    address _insurancePoolAddress
  ) external onlyPools(msg.sender, _insuredAssetAddress) returns (address[] memory) {
    InsuranceToken liquidityToken = PoolsHelper.createLiquidityToken(
      _insurableAssetSymbol,
      _insurancePoolAddress,
      eternalStorageAddress
    );
    tokens.push(address(liquidityToken));

    InsuranceToken claimsToken = PoolsHelper.createClaimsToken(
      _insurableAssetSymbol,
      _insurancePoolAddress,
      eternalStorageAddress
    );

    tokens.push(address(claimsToken));

    return tokens;
  }
}
