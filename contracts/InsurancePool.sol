pragma solidity 0.6.6;

import "./EternalStorage.sol";
import "./lib/StorageHelper.sol";
import "./factories/TokenFactory.sol";


/// @author PanDAO - https://pandao.org
/// @title PanDAO Insurance Pool
/// @notice PanDAO Insurance Pool is the implementation contract which allows a user to add/remove collateral, claim rewards, and create claims
contract InsurancePool {
    struct IPool {
        address claimsToken;
        address collateralToken;
        address insuredToken;
        string insuredTokenSymbol;
        uint256 insureeFeeRate; // the rate the buyer payers for insurance
        uint256 serviceFeeRate; // dao (Note: insureeFeeRate - serviceFeeRate = insurerReward)
        uint256 premiumPeriod; // (n) Blocks
    }

    IPool internal iPool;

    /// @dev Gives access to PanDAO Eternal Storage
    EternalStorage internal eternalStorage;

    /// @notice Stores IPool information on init
    /// @param _insuredToken the digital asset to be insured
    /// @param _insuredTokenSymbol the symbol for the digital asset to be insured
    /// @param _insureeFeeRate The rate the insuree pays
    /// @param _serviceFeeRate The DAO's cut from the insuree premium
    /// @param _premiumPeriod number of blocks between premium payments
    /// @dev _insureeFeeRate - _serviceFeeRate = insurerFee
    constructor(
        address _insuredToken,
        string memory _insuredTokenSymbol,
        uint256 _insureeFeeRate,
        uint256 _serviceFeeRate,
        uint256 _premiumPeriod
    ) public {
        /// @dev Create collateral and claims tokens for pool
        address[] memory tokens = TokenFactory.createTokens(
            _insuredTokenSymbol
        );
        address collateralToken = tokens[0];
        address claimsToken = tokens[1];

        /// @dev Saves IPool to EternalStorage
        iPool.claimsToken = claimsToken;
        iPool.collateralToken = collateralToken;
        iPool.insuredToken = _insuredToken;
        iPool.insuredTokenSymbol = _insuredTokenSymbol;
        iPool.insureeFeeRate = _insureeFeeRate;
        iPool.serviceFeeRate = _serviceFeeRate;
        iPool.premiumPeriod = _premiumPeriod;

        eternalStorage.setPool(
            StorageHelper.formatAddress("insurance.pool", address(this)),
            iPool
        );
    }

    //////////////////////////////
    /// @notice Public
    /////////////////////////////

    function addCollateralForMatching() public {}

    function buyInsurance() public {}

    function claimRewards() public {}

    function createInsuranceClaim() public {}

    function removeCollateralFromMatching() public {}
}
