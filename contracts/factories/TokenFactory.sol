pragma solidity 0.6.6;

/// Utilities
import "@nomiclabs/buidler/console.sol";
import "../lib/StringHelper.sol";

/// Imports
import "../tokens/InsuranceToken.sol";

/// @author PanDAO - https://pandao.org
/// @title PanDAO Insurance Pool Token Factory
/// @notice TokenFactory creates ERC20 tokens to represent a persons liquidity or claim in the pool
contract TokenFactory {
  /// @dev Gives access to PanDAO Eternal Storage
  address public eternalStorageAddress;

  /// Events
  event LiquidityTokenCreated(
    string _tokenName,
    string _tokenSymbol,
    address indexed _tokenAddress
  );
  event ClaimsTokenCreated(string _tokenName, string _tokenSymbol, address indexed _tokenAddress);

  address[] internal tokens;

  /// @dev Ensures that only active Insurance Pools can create tokens
  modifier onlyPools(address sender, address _insuredAssetAddress) {
    _;
    EternalStorage eternalStorage = EternalStorage(eternalStorageAddress);

    address insurancePool = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.address", _insuredAssetAddress)
    );

    require(insurancePool == sender, "PanDAO: Only insurance pools can create new tokens");
  }

  constructor(address _eternalStorageAddress) public {
    eternalStorageAddress = _eternalStorageAddress;
  }

  //////////////////////////////
  /// @notice Public
  /////////////////////////////

  /// @notice Create a set of Claim and Liquidity Tokens for the Pool
  /// @dev Returns LiquidityToken in index position 0 and Claims token in index position 1
  /// @param _insurableAssetSymbol string Insured token symbol
  /// @return address[] Array of token addresses.
  function createTokens(
    string memory _insurableAssetSymbol,
    address _insuredAssetAddress,
    address _insurancePoolAddress
  ) public onlyPools(msg.sender, _insuredAssetAddress) returns (address[] memory) {
    /// Liquidity Token
    address liquidityToken = _createLiquidityToken(_insurableAssetSymbol, _insurancePoolAddress);
    tokens.push(address(liquidityToken));

    /// Claims token
    address claimsToken = _createClaimsToken(_insurableAssetSymbol, _insurancePoolAddress);
    tokens.push(address(claimsToken));

    return tokens;
  }

  //////////////////////////////
  /// @notice Private
  /////////////////////////////

  /// @notice Create a claim token(mPAN)
  /// @param _insurableAssetSymbol string Insured token symbol
  /// @return address New token contract address
  function _createClaimsToken(string memory _insurableAssetSymbol, address _insurancePoolAddress)
    private
    returns (address)
  {
    string memory claimsTokenName = StringHelper.concat(
      "PanDAO Claims Token - ",
      _insurableAssetSymbol
    );

    InsuranceToken claimsToken = new InsuranceToken(
      claimsTokenName,
      "CPAN",
      eternalStorageAddress,
      _insurancePoolAddress
    );

    emit ClaimsTokenCreated(claimsToken.name(), claimsToken.symbol(), address(claimsToken));

    return address(claimsToken);
  }

  /// @notice Create a Liquidity Token(cPAN)
  /// @param _insurableAssetSymbol string Insured token symbol
  /// @return address New token contract address
  function _createLiquidityToken(string memory _insurableAssetSymbol, address _insurancePoolAddress)
    private
    returns (address)
  {
    string memory liquidityTokenName = StringHelper.concat(
      "PanDAO Liquidity Token - ",
      _insurableAssetSymbol
    );

    InsuranceToken liquidityToken = new InsuranceToken(
      liquidityTokenName,
      "LPAN",
      eternalStorageAddress,
      _insurancePoolAddress
    );

    emit LiquidityTokenCreated(
      liquidityToken.name(),
      liquidityToken.symbol(),
      address(liquidityToken)
    );

    return address(liquidityToken);
  }
}
