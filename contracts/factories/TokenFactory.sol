pragma solidity 0.6.6;

/// Utilities
import "@nomiclabs/buidler/console.sol";
import "../lib/StringHelper.sol";

/// Imports
import "../tokens/InsuranceToken.sol";
import "../Manager.sol";


contract TokenFactory is Manager {
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
        onlyOwner(address(this))
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

        InsuranceToken claimsToken = new InsuranceToken(
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

        InsuranceToken collateralToken = new InsuranceToken(
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
