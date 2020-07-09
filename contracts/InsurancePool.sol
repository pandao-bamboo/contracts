// SPDX-License-Identifier: GPLv3

pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

import "./EternalStorage.sol";
import "./lib/StorageHelper.sol";
import "./lib/StringHelper.sol";
import "./tokens/InsuranceToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@nomiclabs/buidler/console.sol";

/// @author PanDAO - https://pandao.org
/// @title PanDAO Insurance Pool
contract InsurancePool {
  EternalStorage internal eternalStorage;

  event InsurancePoolCreated(
    address insurancePoolAddress,
    address insuredAssetAddress,
    string insuredAssetSymbol,
    uint256 insureeFeeRate,
    uint256 serviceFeeRate,
    uint256 coverageStartBlock,
    uint256 coverageDuration
  );

  event liquidityAddedToPool(
    address insurancePoolAddress,
    address insuredAssetAddress,
    address liquidityProvider,
    uint256 amount
  );

  event liquidityRemovedFromPool(
    address insurancePoolAddress,
    address insuredAssetAddress,
    address liquidityProvider,
    uint256 amount
  );

  /// @notice Stores IPool information on init
  /// @param _insuredAssetAddress the digital asset to be insured
  /// @param _insuredAssetSymbol the symbol for the digital asset to be insured
  /// @param _insureeFeeRate The rate the insuree pays
  /// @param _serviceFeeRate The DAO's cut from the insuree premium
  /// @param _coverageStartBlock The DAO's cut from the insuree premium
  /// @param _coverageDuration The DAO's cut from the insuree premium
  /// @param _eternalStorageAddress address contract address of eternalStorage
  /// @dev _insureeFeeRate - _serviceFeeRate = insurerFee
  constructor(
    address _insuredAssetAddress,
    string memory _insuredAssetSymbol,
    uint256 _insureeFeeRate,
    uint256 _serviceFeeRate,
    uint256 _coverageStartBlock,
    uint256 _coverageDuration,
    address _eternalStorageAddress
  ) public {
    eternalStorage = EternalStorage(_eternalStorageAddress);

    bool poolRegistered = StorageHelper.registerInsurancePool(
      address(this),
      eternalStorage.getAddress(StorageHelper.formatString("contract.name", "Manager")),
      _insuredAssetAddress,
      _insureeFeeRate,
      _serviceFeeRate,
      _coverageStartBlock,
      _coverageDuration,
      eternalStorage
    );

    require(poolRegistered == true, "PanDAO: Failed to initialized Insurance Pool");

    emit InsurancePoolCreated(
      address(this),
      _insuredAssetAddress,
      _insuredAssetSymbol,
      _insureeFeeRate,
      _serviceFeeRate,
      _coverageStartBlock,
      _coverageDuration
    );
  }

  /// @notice Adds liquidity for matching to the Insurance Pool
  /// @param _amount Amount of liquidity to be added to the queue
  function addLiquidity(uint256 _amount) public payable {
    address insuredAssetAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.insuredAsset", address(this))
    );
    address liquidityTokenAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this))
    );

    ERC20 insuredAsset = ERC20(insuredAssetAddress);
    insuredAsset.transferFrom(msg.sender, address(this), _amount);

    InsuranceToken liquidityToken = InsuranceToken(liquidityTokenAddress);
    liquidityToken.mint(msg.sender, _amount);
    liquidityToken.approve(msg.sender, address(this), _amount);

    StorageHelper.addLiquidity(eternalStorage, msg.sender, address(this), _amount);

    emit liquidityAddedToPool(address(this), insuredAssetAddress, msg.sender, _amount);
  }

  function buyInsurance(
    uint256 _amount,
    address _insureeAddress,
    uint8 _termLengthInMonths
  ) public {
    address insuredAssetAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.insuredAsset", address(this))
    );
    address claimsTokenAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.claimsToken", address(this))
    );
    address daoFinance = eternalStorage.getAddress(StorageHelper.formatGet("dao.finance"));

    uint256 insureeFee = eternalStorage.getUint(
      StorageHelper.formatAddress("insurance.pool.insureeFeeRate", address(this))
    );

    uint256 serviceFee = eternalStorage.getUint(
      StorageHelper.formatAddress("insurance.pool.serviceFeeRate", address(this))
    );

    uint256 totalPremiumAmount = SafeMath.mul(_amount, insureeFee);
    uint256 daoFee = SafeMath.mul(totalPremiumAmount, serviceFee / 100);

    ERC20 insuredAsset = ERC20(insuredAssetAddress);
    insuredAsset.transferFrom(_insureeAddress, address(this), totalPremiumAmount);
    insuredAsset.transfer(daoFinance, daoFee);

    InsuranceToken claimsToken = InsuranceToken(claimsTokenAddress);
    claimsToken.mint(_insureeAddress, _amount);
    claimsToken.approve(_insureeAddress, address(this), _amount);
  }

  function payPremium() public {}

  function createClaim() public {}

  function removeLiquidity(uint256 _amount) public payable {
    address insuredAssetAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.insuredAsset", address(this))
    );
    address liquidityTokenAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", address(this))
    );

    ERC20 insuredAsset = ERC20(insuredAssetAddress);
    insuredAsset.transfer(msg.sender, _amount);

    InsuranceToken liquidityToken = InsuranceToken(liquidityTokenAddress);
    liquidityToken.transferFrom(msg.sender, address(this), _amount);
    liquidityToken.burn(_amount);

    StorageHelper.removeLiquidity(eternalStorage, msg.sender, address(this), _amount);

    emit liquidityRemovedFromPool(address(this), insuredAssetAddress, msg.sender, _amount);
  }

  function settlement() public {}
}
