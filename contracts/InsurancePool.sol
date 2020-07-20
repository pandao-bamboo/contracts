// SPDX-License-Identifier: GPLv3
pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

import "./EternalStorage.sol";
import "./lib/StorageHelper.sol";
import "./lib/StringHelper.sol";
import "./tokens/InsuranceToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@nomiclabs/buidler/console.sol";

// Gelato Dependencies
import { IGelatoCondition } from "@gelatonetwork/core/contracts/conditions/IGelatoCondition.sol";
import { IGelatoCore, DataFlow, Task, Condition, Action, Operation, DataFlow, Provider } from "@gelatonetwork/core/contracts/gelato_core/interfaces/IGelatoCore.sol";
import { IGelatoProviderModule } from "@gelatonetwork/core/contracts/provider_modules/IGelatoProviderModule.sol";

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
  /// @param _coverageStartBlock Current Block Number
  /// @param _coverageDuration 172800 blocks within a month
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

    (uint256 totalPremiumAmount, uint256 daoFee) = calculateFeeAmounts(_amount);

    // Charge User fee
    chargeUser(msg.sender, totalPremiumAmount, daoFee, insuredAssetAddress);

    // Issue Claim Tokens
    address claimsTokenAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.claimsToken", address(this))
    );

    InsuranceToken claimsToken = InsuranceToken(claimsTokenAddress);
    claimsToken.mint(_insureeAddress, _amount);
    claimsToken.approve(_insureeAddress, address(this), _amount);

    uint256 coverageDuration = eternalStorage.getUint(
      StorageHelper.formatAddress("insurance.pool.coverageDuration", address(this))
    );

    // Submit Task to Gelato for schedule monthly fee payments
    scheduleFutureFeePayment(
      _amount,
      totalPremiumAmount,
      daoFee,
      msg.sender,
      block.number + coverageDuration,
      _termLengthInMonths - 1
    );

  }
  function chargeUser(
    address _feePayer,
    uint256 _totalPremiumAmount,
    uint256 _daoFee,
    address _insuredAssetAddress
  )
    private
  {
    address daoFinance = eternalStorage.getAddress(StorageHelper.formatGet("dao.finance"));

    ERC20 insuredAsset = ERC20(_insuredAssetAddress);
    insuredAsset.transferFrom(_feePayer, address(this), _totalPremiumAmount);
    insuredAsset.transfer(daoFinance, _daoFee);
  }

  function calculateFeeAmounts(uint256 _amount)
    public
    view
    returns(uint256 totalPremiumAmount, uint256 daoFee)
  {
    uint256 insureeFeeNum =  eternalStorage.getUint(
      StorageHelper.formatAddress("insurance.pool.insureeFeeRate", address(this))
    );

    uint256 serviceFeeNum = eternalStorage.getUint(
      StorageHelper.formatAddress("insurance.pool.serviceFeeRate", address(this))
    );

    totalPremiumAmount = SafeMath.div( SafeMath.mul(_amount, insureeFeeNum), 100);
    daoFee = SafeMath.div( SafeMath.mul(totalPremiumAmount, serviceFeeNum), 100);
  }

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



  // === Gelato Specific Functions === //

  // === Gelato Action === //

  // Action that will be executed by Gelato
  /// @dev function called by gelatoCore
  function payPremium(
    uint256 _amount,
    uint256 _totalPremiumAmount,
    uint256 _daoFee,
    address _feePayer,
    uint256 _coverageRenewalBlock,
    uint8 _termLengthInMonths
  )
    external
  {
    address gelatoCore = eternalStorage.getAddress(StorageHelper.formatGet("gelato.core"));
    require(msg.sender == gelatoCore);

    address insuredAssetAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.insuredAsset", address(this))
    );

    // If user has suffcient Approval and Balance && we are not after the final period, charge the user.
    //  Else Burn Claim Tokens
    if (
      hasSufficientApprovalAndBalance(_feePayer, insuredAssetAddress, _totalPremiumAmount) &&
      _termLengthInMonths > 0
    ) {
      // Charge User
      chargeUser(_feePayer, _totalPremiumAmount, _daoFee, insuredAssetAddress);

      // Fetch coverageDuration
      uint256 coverageDuration = eternalStorage.getUint(
      StorageHelper.formatAddress("insurance.pool.coverageDuration", address(this)));

      // Submit Task to Gelato for schedule monthly fee payments
      scheduleFutureFeePayment(
        _amount,
        _totalPremiumAmount,
        _daoFee,
        _feePayer,
        _coverageRenewalBlock + coverageDuration,
        _termLengthInMonths - 1
      );
    } else {
      burnClaimTokens(_feePayer, _amount);
    }

  }

  function burnClaimTokens(address _tokenOwner, uint256 _amount) private {
    // Burn Claim Tokens
    address claimsTokenAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.claimsToken", address(this))
    );
    InsuranceToken claimsToken = InsuranceToken(claimsTokenAddress);
    claimsToken.burnFrom(_tokenOwner, _amount);
  }

  function hasSufficientApprovalAndBalance(
    address _feePayer,
    address _insuredAssetAddress,
    uint256 _totalPremiumAmount
  )
    public
    view
    returns(bool isSufficient)
  {
    ERC20 insuredAsset = ERC20(_insuredAssetAddress);
    uint256 balance = insuredAsset.balanceOf(_feePayer);
    uint256 allowance = insuredAsset.allowance(_feePayer, address(this));
    if (balance >= _totalPremiumAmount && allowance >= _totalPremiumAmount) isSufficient = true;
  }


  // === Submitting Task to Gelato === //

  /// @dev  Submit as Task to Gelato
  function scheduleFutureFeePayment(
    uint256 _amount,
    uint256 _totalPremiumAmount,
    uint256 _daoFee,
    address _feePayer,
    uint256 _coverageRenewalBlock,
    uint8 _termLengthInMonths // e.g. == 11 from buyInsurance if default termLength == 12
  )
    private
  {
    // As these contracts are immutable, they can also be stored as constants / immutables in the contracts bytecode
    // to avoid state reads
    IGelatoCore gelatoCore = IGelatoCore(eternalStorage.getAddress(StorageHelper.formatGet("gelato.core")));
    address providerModuleAddress = eternalStorage.getAddress(StorageHelper.formatGet("gelato.providermodule"));
    address gelatoManager = eternalStorage.getAddress(StorageHelper.formatGet("gelato.manager"));
    address conditionAddress = eternalStorage.getAddress(StorageHelper.formatGet("gelato.condition"));


    // Create a Task Object, which defined what condition Gelato should monitor and what action Gelato should execute
    Condition memory condition = Condition({
      inst: IGelatoCondition(conditionAddress),
      data: abi.encode(_coverageRenewalBlock)
    });

    bytes memory payPremiumData = abi.encodeWithSignature(
      "payPremium(uint256,uint256,uint256,address,uint256,uint8)",
      _amount,
      _totalPremiumAmount,
      _daoFee,
      _feePayer,
      _coverageRenewalBlock,
      _termLengthInMonths // e.g. == 11 from buyInsurance if default termLength == 12
    );

    Action memory action = Action({
        addr: address(0),
        data: payPremiumData,
        operation: Operation.Call,
        dataFlow: DataFlow.None,
        value: 0,
        termsOkCheck: false
    });

    Condition[] memory singleCondition = new Condition[](1);
    singleCondition[0] = condition;
    Action[] memory singleAction = new Action[](1);
    singleAction[0] = action;

    Task memory task = Task({
      conditions: singleCondition,
      actions: singleAction,
      selfProviderGasLimit: 0,
      selfProviderGasPriceCeil: 0
    });

    Provider memory provider = Provider({
      addr: gelatoManager,
      module: IGelatoProviderModule(providerModuleAddress)
    });

    // Submit the Task to Gelato
    gelatoCore.submitTask(provider, task, 0);
  }

}
