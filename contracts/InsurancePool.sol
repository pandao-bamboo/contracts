// SPDX-License-Identifier: GPLv3

pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

import "./EternalStorage.sol";
import "./lib/StorageHelper.sol";
import "./lib/StringHelper.sol";
import "./factories/TokenFactory.sol";
import "./tokens/InsuranceToken.sol";

/// @author PanDAO - https://pandao.org
/// @title PanDAO Insurance Pool
contract InsurancePool {
  EternalStorage internal eternalStorage;

  event InsurancePoolCreated(
    address insurancePoolAddress,
    address insuredAssetAddress,
    string insuredAssetSymbol,
    uint256 insureeFeeRate,
    uint256 serviceFeeRate
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
  /// @param _insurableAssetAddress the digital asset to be insured
  /// @param _insurableAssetSymbol the symbol for the digital asset to be insured
  /// @param _insureeFeeRate The rate the insuree pays
  /// @param _serviceFeeRate The DAO's cut from the insuree premium
  /// @param _eternalStorageAddress address contract address of eternalStorage
  /// @dev _insureeFeeRate - _serviceFeeRate = insurerFee
  constructor(
    address _insurableAssetAddress,
    string memory _insurableAssetSymbol,
    uint256 _insureeFeeRate,
    uint256 _serviceFeeRate,
    address _eternalStorageAddress
  ) public {
    eternalStorage = EternalStorage(_eternalStorageAddress);

    address insurableToken = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.insuredAsset", _insurableAssetAddress)
    );

    require(insurableToken == address(0), "PanDAO: Insurance Pool already exists for that asset");

    bool poolInitialized = StorageHelper.initializeInsurancePool(
      eternalStorage,
      address(this),
      eternalStorage.getAddress(StorageHelper.formatString("contract.name", "Manager")),
      _insurableAssetSymbol,
      _insurableAssetAddress
    );

    require(poolInitialized == true, "PanDAO: Failed to initialized Insurance Pool");

    TokenFactory tokenFactory = TokenFactory(
      eternalStorage.getAddress(StorageHelper.formatString("contract.name", "TokenFactory"))
    );

    address[2] memory tokens = tokenFactory.createTokens(_insurableAssetSymbol, address(this));

    StorageHelper.saveInsurancePool(
      eternalStorage,
      address(this),
      tokens[0],
      tokens[1],
      _insurableAssetAddress,
      _insurableAssetSymbol,
      _insureeFeeRate,
      _serviceFeeRate
    );

    emit InsurancePoolCreated(
      address(this),
      _insurableAssetAddress,
      _insurableAssetSymbol,
      _insureeFeeRate,
      _serviceFeeRate
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
    uint256 poolShare = SafeMath.sub(totalPremiumAmount, daoFee);

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
