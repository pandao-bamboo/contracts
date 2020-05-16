pragma solidity 0.6.6;

/// Utilities
import "@nomiclabs/buidler/console.sol";
import "../lib/StringHelper.sol";

/// Imports
import "../tokens/InsuranceToken.sol";
import "../Manager.sol";


/// @author PanDAO - https://pandao.org
/// @title PanDAO Insurance Pool Token Factory
/// @notice TokenFactory creates ERC20 tokens to represent a persons collateral or claim in the pool
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

    //////////////////////////////
    /// @notice Public
    /////////////////////////////

    /// @notice Create a set of Claim and Collateral Tokens for the Pool
    /// @param _insuredTokenSymbol string Insured token symbol
    /// @return address[] Returns collateral token in index position 0 and claims token in index position 1
    function createTokens(string memory _insurableTokenSymbol)
        public
        onlyOwner(address(this))
        returns (address[])
    {
        address[] tokens;
        /// Collateral token
        address collateralToken = _createCollateralToken(_insurableTokenSymbol);
        tokens.push(collateralToken);

        /// Claims token
        address claimsToken = _createClaimsToken(_insurableTokenSymbol);
        tokens.push(claimsToken);

        return tokens;
    }

    //////////////////////////////
    /// @notice Private
    /////////////////////////////

    /// @notice Create a claim token
    /// @param _insuredTokenSymbol string Insured token symbol
    /// @return address Returns newly created claim token address
    function _createClaimsToken(string memory _insurableTokenSymbol)
        private
        returns (address)
    {
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

        return claimsToken;
        console.log("### Created Claims Token ### - ", claimsToken.name());
    }

    /// @notice Create a collateral token
    /// @param _insuredTokenSymbol string Insured token symbol
    /// @return address Returns newly created collateral token address
    function _createCollateralToken(string memory _insurableTokenSymbol)
        private
        returns (address)
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

        return collateralToken;
        console.log(
            "### Created Collateral Token ### - ",
            collateralToken.name()
        );
    }
}
