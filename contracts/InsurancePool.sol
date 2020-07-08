// SPDX-License-Identifier: GPLv3

pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

import "./EternalStorage.sol";
import "./lib/StorageHelper.sol";
import "./lib/StringHelper.sol";
import "./tokens/InsuranceToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

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
  /// @param _liquidityProviderAddress Address for the liquidity provider
  /// @param _amount Amount of liquidity to be added to the queue
  function addLiquidity(address _liquidityProviderAddress, uint256 _amount) public payable {
    address insuredAssetAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.insuredAsset", address(this))
    );
    address liquidityTokenAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", insuredAssetAddress)
    );

    ERC20 insuredAsset = ERC20(insuredAssetAddress);
    insuredAsset.transferFrom(_liquidityProviderAddress, address(this), _amount);

    InsuranceToken liquidityToken = InsuranceToken(liquidityTokenAddress);
    liquidityToken.mint(_liquidityProviderAddress, _amount);
    liquidityToken.approve(_liquidityProviderAddress, address(this), _amount);

    StorageHelper.addLiquidity(
      eternalStorage,
      insuredAssetAddress,
      _liquidityProviderAddress,
      _amount
    );

    emit liquidityAddedToPool(
      address(this),
      insuredAssetAddress,
      _liquidityProviderAddress,
      _amount
    );
  }

  function buyInsurance(uint256 _amount, uint8 _termLengthInMonths) public {
    address insuredAssetAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.insuredAsset", address(this))
    );
    address claimsTokenAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.claimsToken", insuredAssetAddress)
    );
    address daoFinance = eternalStorage.getAddress(StorageHelper.formatGet("dao.finance"));

    uint256 insureeFee = SafeMath.div(
      eternalStorage.getUint(
        StorageHelper.formatAddress("insurance.pool.insureeFee", insuredAssetAddress)
      ),
      100
    );
    uint256 serviceFee = SafeMath.div(
      eternalStorage.getUint(
        StorageHelper.formatAddress("insurance.pool.serviceFee", insuredAssetAddress)
      ),
      100
    );
    uint256 totalPremiumAmount = SafeMath.mul(_amount, insureeFee);
    uint256 daoFee = SafeMath.mul(totalPremiumAmount, serviceFee);

    ERC20 insuredAsset = ERC20(insuredAssetAddress);
    insuredAsset.approve(address(this), totalPremiumAmount);
    insuredAsset.transferFrom(msg.sender, address(this), totalPremiumAmount);
    insuredAsset.transfer(daoFinance, daoFee);

    InsuranceToken claimsToken = InsuranceToken(claimsTokenAddress);
    claimsToken.mint(msg.sender, _amount);
    claimsToken.approve(msg.sender, address(this), _amount);
  }

  function payPremium() public {}

  function createClaim() public {}

  function removeLiquidity(address _liquidityProviderAddress, uint256 _amount) public payable {
    address insuredAssetAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.insuredAsset", address(this))
    );
    address liquidityTokenAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", insuredAssetAddress)
    );

    ERC20 insuredAsset = ERC20(insuredAssetAddress);
    insuredAsset.transfer(_liquidityProviderAddress, _amount);

    InsuranceToken liquidityToken = InsuranceToken(liquidityTokenAddress);
    liquidityToken.transferFrom(_liquidityProviderAddress, address(this), _amount);
    liquidityToken.burn(_amount);

    StorageHelper.removeLiquidity(
      eternalStorage,
      insuredAssetAddress,
      _liquidityProviderAddress,
      _amount
    );

    emit liquidityRemovedFromPool(
      address(this),
      insuredAssetAddress,
      _liquidityProviderAddress,
      _amount
    );
  }

  function settlement() public {}
}
