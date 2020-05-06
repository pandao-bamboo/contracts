pragma solidity 0.6.6;

/// Utilities
import "../../node_modules/@nomiclabs/buidler/console.sol";
import "../libraries/StringHelper.sol";

/// Imports
import "../../node_modules/@openzeppelin/contracts/access/AccessControl.sol";
import "../tokens/InsuranceToken.sol";
import "../Manager.sol";


contract TokenFactory is AccessControl, Manager {
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
    function createTokens(string memory _insurableTokenSymbol) public {
        require(hasRole(Manager.DAO_AGENT_ROLE, _msgSender()));

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
