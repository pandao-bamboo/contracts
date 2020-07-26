pragma solidity ^0.6.10;

import "./EternalStorage.sol";
import "./lib/StorageHelper.sol";
import "./lib/TokenHelper.sol";
import "./lib/StringHelper.sol";
import "./tokens/LiquidityToken.sol";

contract LiquidityPool {
  EternalStorage internal eternalStorage;

  constructor(address _insuredAssetAddress, address _eternalStorageAddress) public {
    eternalStorage = EternalStorage(_eternalStorageAddress);

    // Initialize Contract in Storage
    address managerAddress = eternalStorage.getAddress(
      StorageHelper.formatString("contract.name", "Manager")
    );
    eternalStorage.setAddress(
      StorageHelper.formatAddress("contract.owner", address(this)),
      managerAddress
    );

    eternalStorage.setAddress(
      StorageHelper.formatAddress("liquidity.pool.insuredAsset", address(this)),
      _insuredAssetAddress
    );
    eternalStorage.setAddress(
      StorageHelper.formatAddress("liquidity.pool.address", _insuredAssetAddress),
      address(this)
    );

    // create liquidity token
    ERC20 insuredAsset = ERC20(_insuredAssetAddress);

    TokenHelper.createLiquidityToken(
      _insuredAssetAddress,
      address(this),
      insuredAsset.symbol(),
      _eternalStorageAddress
    );
  }
}
