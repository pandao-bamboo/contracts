pragma solidity 0.6.6;

/// Utilities
import "../../node_modules/@nomiclabs/buidler/console.sol";
import "../libraries/StringHelper.sol";

/// Imports
import "../../node_modules/@openzeppelin/contracts/access/AccessControl.sol";
import "../../node_modules/@openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol";


contract TokenFactory is Manager, AccessControl {
    /// Events
    event CollateralTokenCreated(
        string _tokenName,
        string _tokenSymbol,
        address indexed _tokenAddress
    );
    event ClaimsTokenCreated(
        string _tokenName,
        string _tokenSymbol,
        address indexed _tokenAddress
    );

    // Constructor

    // Public
    function createTokens(string memory _insurableTokenSymbol)
        public
        onlyOwner
    {
        /// Collateral token
        _createCollateralToken(_insurableTokenSymbol);

        /// Claims token
        _createClaimsToken(_insurableTokenSymbol);
    }

    /// Private
    function _createClaimsToken(string memory _insurableTokenSymbol) private {
        string memory claimsTokenName = StringHelper.concat(
            "PanDAO Claims Token - ",
            _insurableTokenSymbol
        );

        ERC20PresetMinterPauser claimsToken = new ERC20PresetMinterPauser(
            claimsTokenName,
            "mPAN"
        );

        emit ClaimsTokenCreated(
            claimsToken.name(),
            claimsToken.symbol(),
            address(claimsToken)
        );
        console.log("### Created Claims Token ### - ", claimsToken.name());
    }

    function _createCollateralToken(string memory _insurableTokenSymbol)
        private
    {
        string memory collateralTokenName = StringHelper.concat(
            "PanDAO Collateral Token - ",
            _insurableTokenSymbol
        );

        ERC20PresetMinterPauser collateralToken = new ERC20PresetMinterPauser(
            collateralTokenName,
            "cPAN"
        );

        emit CollateralTokenCreated(
            collateralToken.name(),
            collateralToken.symbol(),
            address(collateralToken)
        );
        console.log(
            "### Created Collateral Token ### - ",
            collateralToken.name()
        );
    }
}
