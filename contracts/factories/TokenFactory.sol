pragma solidity ^0.6.0;

/// Utilities
import "@nomiclabs/buidler/console.sol";
import "../libraries/StringHelper.sol";

/// Imports
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol";


/// PanDAO

contract TokenFactory is Ownable {
    function createTokens(string memory _insurableTokenSymbol)
        public
        onlyOwner
        returns (string memory)
    {
        /// Collateral token
        _createCollateralToken(_insurableTokenSymbol);

        /// Claims token
        _createClaimsToken(_insurableTokenSymbol);
    }

    /// Private
    function _createClaimsToken(string memory _insurableTokenSymbol)
        internal
        returns (string memory)
    {
        string memory claimsTokenName = StringHelper.concat(
            "PanDAO Claims Token - ",
            _insurableTokenSymbol
        );

        ERC20PresetMinterPauser claimsToken = new ERC20PresetMinterPauser(
            claimsTokenName,
            "mPAN"
        );

        console.log("Created Claims Token - ", claimsToken.name());
        return claimsToken.name();
    }

    function _createCollateralToken(string memory _insurableTokenSymbol)
        internal
        returns (string memory)
    {
        string memory collateralTokenName = StringHelper.concat(
            "PanDAO Collateral Token - ",
            _insurableTokenSymbol
        );

        ERC20PresetMinterPauser collateralToken = new ERC20PresetMinterPauser(
            collateralTokenName,
            "cPAN"
        );

        console.log("Created Collateral Token - ", collateralToken.name());
        return collateralToken.name();
    }
}
