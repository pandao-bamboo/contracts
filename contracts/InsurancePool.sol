pragma solidity 0.6.6;

import "@nomiclabs/buidler/console.sol";

import "./EternalStorage.sol";
import "./lib/StorageHelper.sol";
import "./factories/TokenFactory.sol";


/// @author PanDAO - https://pandao.org
/// @title PanDAO Insurance Pool
/// @notice PanDAO Insurance Pool is the implementation contract which allows a user to add/remove collateral, claim rewards, and create claims
contract InsurancePool {
    /// @dev Gives access to PanDAO Eternal Storage
    address public eternalStorageAddress;
    EternalStorage internal eternalStorage;

    event InsurancePoolCreated(
        address insurancePoolAddress,
        address insuredTokenAddress,
        string insuredTokenSymbol,
        uint256 insureeFeeRate,
        uint256 premiumPeriod,
        uint256 serviceFeeRate
    );

    /// @notice Stores IPool information on init
    /// @param _insurableTokenAddress the digital asset to be insured
    /// @param _insurableTokenSymbol the symbol for the digital asset to be insured
    /// @param _insureeFeeRate The rate the insuree pays
    /// @param _serviceFeeRate The DAO's cut from the insuree premium
    /// @param _premiumPeriod number of blocks between premium payments
    /// @param _eternalStorageAddress address contract address of eternalStorage
    /// @dev _insureeFeeRate - _serviceFeeRate = insurerFee
    constructor(
        address _insurableTokenAddress,
        string memory _insurableTokenSymbol,
        uint256 _insureeFeeRate,
        uint256 _serviceFeeRate,
        uint256 _premiumPeriod,
        address _eternalStorageAddress
    ) public {
        eternalStorageAddress = _eternalStorageAddress;
        eternalStorage = EternalStorage(eternalStorageAddress);

        address insurableToken = eternalStorage.getAddress(
            StorageHelper.formatAddress(
                "insurance.pool.insuredToken",
                _insurableTokenAddress
            )
        );

        /// @dev Require insurable token to be unique
        require(
            insurableToken == address(0),
            "PanDAO: Insurance Pool already exists for that asset"
        );

        bool poolInitialized = StorageHelper.initializeContract(
            eternalStorage,
            address(this),
            eternalStorage.getAddress(
                StorageHelper.formatString("contract.name", "Manager")
            ),
            _insurableTokenSymbol
        );

        require(
            poolInitialized == true,
            "PanDAO: Failed to initialized Insurance Pool"
        );

        /// @dev Create collateral and claims tokens for pool
        TokenFactory tokenFactory = TokenFactory(
            eternalStorage.getAddress(
                StorageHelper.formatString("contract.name", "TokenFactory")
            )
        );

        address[] memory tokens = tokenFactory.createTokens(
            _insurableTokenSymbol
        );

        StorageHelper.saveInsurancePool(
            eternalStorage,
            address(this),
            tokens[0],
            tokens[1],
            _insurableTokenAddress,
            _insurableTokenSymbol,
            _insureeFeeRate,
            _serviceFeeRate,
            _premiumPeriod
        );

        emit InsurancePoolCreated(
            address(this),
            _insurableTokenAddress,
            _insurableTokenSymbol,
            _insureeFeeRate,
            _premiumPeriod,
            _serviceFeeRate
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

    function getCollateralBalance() public {}

    function getClaimsBalance() public {}

    //////////////////////////////
    /// @notice Private
    /////////////////////////////
}
