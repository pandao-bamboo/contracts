pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

import "./EternalStorage.sol";
import "./lib/StorageHelper.sol";
import "./lib/StringHelper.sol";
import "./factories/TokenFactory.sol";
import "./tokens/InsuranceToken.sol";

/// @author PanDAO - https://pandao.org
/// @title PanDAO Insurance Pool
/// @notice PanDAO Insurance Pool is the implementation contract which allows a user to add/remove liquidity, claim rewards, and create claims
contract InsurancePool {
  /// @dev Gives access to PanDAO Eternal Storage
  EternalStorage internal eternalStorage;

  event InsurancePoolCreated(
    address insurancePoolAddress,
    address insuredAssetAddress,
    string insuredAssetSymbol,
    uint256 insureeFeeRate,
    uint256 premiumPeriod,
    uint256 serviceFeeRate
  );

  event liquidityAddedToPool(
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
  /// @param _premiumPeriod number of blocks between premium payments
  /// @param _eternalStorageAddress address contract address of eternalStorage
  /// @dev _insureeFeeRate - _serviceFeeRate = insurerFee
  constructor(
    address _insurableAssetAddress,
    string memory _insurableAssetSymbol,
    uint256 _insureeFeeRate,
    uint256 _serviceFeeRate,
    uint256 _premiumPeriod,
    address _eternalStorageAddress
  ) public {
    eternalStorage = EternalStorage(_eternalStorageAddress);

    address insurableToken = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.insuredAsset", _insurableAssetAddress)
    );

    /// @dev Require insurable token to be unique
    require(insurableToken == address(0), "PanDAO: Insurance Pool already exists for that asset");

    bool poolInitialized = StorageHelper.initializeInsurancePool(
      eternalStorage,
      address(this),
      eternalStorage.getAddress(StorageHelper.formatString("contract.name", "Manager")),
      _insurableAssetSymbol,
      _insurableAssetAddress
    );

    require(poolInitialized == true, "PanDAO: Failed to initialized Insurance Pool");

    /// @dev Create liquidity and claims tokens for pool
    TokenFactory tokenFactory = TokenFactory(
      eternalStorage.getAddress(StorageHelper.formatString("contract.name", "TokenFactory"))
    );

    address[] memory tokens = tokenFactory.createTokens(
      _insurableAssetSymbol,
      _insurableAssetAddress,
      address(this)
    );

    StorageHelper.saveInsurancePool(
      eternalStorage,
      address(this),
      tokens[0],
      tokens[1],
      _insurableAssetAddress,
      _insurableAssetSymbol,
      _insureeFeeRate,
      _serviceFeeRate,
      _premiumPeriod
    );

    emit InsurancePoolCreated(
      address(this),
      _insurableAssetAddress,
      _insurableAssetSymbol,
      _insureeFeeRate,
      _premiumPeriod,
      _serviceFeeRate
    );
  }

  //////////////////////////////
  /// @notice Public
  /////////////////////////////

  /// @notice Adds liquidity for matching to the Insurance Pool
  /// @param _liquidityProviderAddress Address for the liquidity provider
  /// @param _amount Amount of liquidity to be added to the queue
  function addLiquidity(
    address _insuredAssetAddress,
    address _liquidityProviderAddress,
    uint256 _amount
  ) public payable {
    address liquidityTokenAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.liquidityToken", _insuredAssetAddress)
    );

    InsuranceToken liquidityToken = InsuranceToken(liquidityTokenAddress);

    ERC20 insuredAsset = ERC20(_insuredAssetAddress);

    insuredAsset.transferFrom(_liquidityProviderAddress, address(this), _amount);

    /// @dev Mint 1:1 representation of liquidity stored in contract
    liquidityToken.mint(_liquidityProviderAddress, _amount);

    /// @dev Approve the insurance pool to transfer the liquidity representation tokens back
    liquidityToken.approve(_liquidityProviderAddress, address(this), _amount);

    StorageHelper.updateLiquidity(
      eternalStorage,
      _insuredAssetAddress,
      _liquidityProviderAddress,
      _amount
    );

    emit liquidityAddedToPool(
      address(this),
      _insuredAssetAddress,
      _liquidityProviderAddress,
      _amount
    );
  }

  function buyInsurance() public {}

  function claimRewards() public {}

  function createInsuranceClaim() public {}

  function getClaimsBalance() public {}

  function getLiquidityBalance() public {}

  function removeLiquidity() public {}

  //////////////////////////////
  /// @notice Private
  /////////////////////////////
}
