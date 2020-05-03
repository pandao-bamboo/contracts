pragma solidity ^0.6.4;

/// Utilities
import "../../node_modules/@nomiclabs/buidler/console.sol";
import "../libraries/StringHelper.sol";

/// Imports
import "../../node_modules/@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";

/// PanDAO
import "../tokens/ClaimsToken.sol";
import "../tokens/CollateralToken.sol";
import "../TokenStorage.sol";


contract TokenFactory is Ownable {
    function createTokens(string _insurableTokenSymbol) public onlyOwner {
        /// Collateral token
        _createCollateralToken(_insurableTokenSymbol);
        console.log("CollateralToken", collateralToken);

        /// Claims token
        _createClaimsToken(_insurableTokenSymbol);
        console.log("ClaimsToken", claimsToken);
    }

    /// Private
    function _createClaimsToken(string _insurableTokenSymbol) internal {
        bytes32 claimsTokenStorage = TokenStorage.load(
            TokenStorage.claimsTokenStorage
        );
        string claimsTokenName = StringHelper.concat(
            "PanDAO Claims Token - ",
            _insurableTokenSymbol
        );
        ClaimsToken claimsToken = new ClaimsToken(claimsTokenName, "mPAN", 18);

        claimsTokenStorage().name = claimsToken.name;
        claimsTokenStorage().symbol = claimsToken.symbol;
        claimsTokenStorage().totalSupply = 0;
    }

    function _createCollateralToken(string _insurableTokenSymbol) internal {
        bytes32 collateralTokenStorage = TokenStorage.load(
            TokenStorage.collateralTokenStorage
        );
        string collateralTokenName = StringHelper.concat(
            "PanDAO Collateral Token - ",
            _insurableTokenSymbol
        );
        CollateralToken collateralToken = new CollateralToken(
            collateralTokenName,
            "cPAN",
            18
        );

        collateralTokenStorage().name = collateralToken.name;
        collateralTokenStorage().symbol = collateralToken.symbol;
        collateralTokenStorage().totalSupply = 0;
    }
}
