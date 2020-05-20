pragma solidity 0.6.6;

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

        /// @dev Create collateral and claims tokens for pool
        TokenFactory tokenFactory = TokenFactory(
            eternalStorage.getAddress(
                StorageHelper.formatString("contract.name", "TokenFactory")
            )
        );
        console.log("### PanDAO: TEST ###");
        console.logBytes32(
            StorageHelper.formatString("contract.name", "TokenFactory")
        );
        address[] memory tokens = tokenFactory.createTokens(
            _insurableTokenSymbol
        );

        /// @dev Saves IPool to EternalStorage
        eternalStorage.setAddress(
            StorageHelper.formatAddress(
                "insurance.pool.collateralToken",
                address(this)
            ),
            tokens[0]
        );
        eternalStorage.setAddress(
            StorageHelper.formatAddress(
                "insurance.pool.claimsToken",
                address(this)
            ),
            tokens[1]
        );
        eternalStorage.setAddress(
            StorageHelper.formatAddress(
                "insurance.pool.insuredToken",
                address(this)
            ),
            _insurableTokenAddress
        );
        eternalStorage.setString(
            StorageHelper.formatAddress(
                "insurance.pool.insuredTokenSymbol",
                address(this)
            ),
            _insurableTokenSymbol
        );
        eternalStorage.setUint(
            StorageHelper.formatAddress(
                "insurance.pool.insureeFeeRate",
                address(this)
            ),
            _insureeFeeRate
        );
        eternalStorage.setUint(
            StorageHelper.formatAddress(
                "insurance.pool.serviceFeeRate",
                address(this)
            ),
            _serviceFeeRate
        );
        eternalStorage.setUint(
            StorageHelper.formatAddress(
                "insurance.pool.premiumPeriod",
                address(this)
            ),
            _premiumPeriod
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
}
