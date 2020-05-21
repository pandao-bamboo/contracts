pragma solidity 0.6.6;

/// Utilities
import "@nomiclabs/buidler/console.sol";
import "../lib/StringHelper.sol";

/// Imports
import "../tokens/InsuranceToken.sol";


/// @author PanDAO - https://pandao.org
/// @title PanDAO Insurance Pool Token Factory
/// @notice TokenFactory creates ERC20 tokens to represent a persons collateral or claim in the pool
contract TokenFactory {
    /// @dev Gives access to PanDAO Eternal Storage
    address public eternalStorageAddress;

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

    address[] internal tokens;

    /// @dev Ensures that only active Insurance Pools can create tokens
    modifier onlyPools(address _poolAddress) {
        _;
        EternalStorage eternalStorage = EternalStorage(eternalStorageAddress);

        address insurancePool = eternalStorage.getAddress(
            StorageHelper.formatAddress("insurance.pool.address", _poolAddress)
        );

        require(
            insurancePool != address(0),
            "PanDAO: Only insurance pools can create new tokens"
        );
    }

    constructor(address _eternalStorageAddress) public {
        eternalStorageAddress = _eternalStorageAddress;
    }

    //////////////////////////////
    /// @notice Public
    /////////////////////////////

    /// @notice Create a set of Claim and Collateral Tokens for the Pool
    /// @dev Returns CollateralToken in index position 0 and Claims token in index position 1
    /// @param _insurableTokenSymbol string Insured token symbol
    /// @return address[] Array of token addresses.
    function createTokens(string memory _insurableTokenSymbol)
        public
        onlyPools(msg.sender)
        returns (address[] memory)
    {
        /// Collateral token
        address collateralToken = _createCollateralToken(_insurableTokenSymbol);
        tokens.push(address(collateralToken));

        /// Claims token
        address claimsToken = _createClaimsToken(_insurableTokenSymbol);
        tokens.push(address(claimsToken));

        return tokens;
    }

    //////////////////////////////
    /// @notice Private
    /////////////////////////////

    /// @notice Create a claim token(mPAN)
    /// @param _insurableTokenSymbol string Insured token symbol
    /// @return address New token contract address
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

        return address(claimsToken);
    }

    /// @notice Create a collateral token(cPAN)
    /// @param _insurableTokenSymbol string Insured token symbol
    /// @return address New token contract address
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

        return address(collateralToken);
    }
}
