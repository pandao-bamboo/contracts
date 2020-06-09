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
function coverage_0x9904d005(bytes32 c__0x9904d005) public pure {}

  /// @dev Gives access to PanDAO Eternal Storage
  address public eternalStorageAddress;

  /// Events
  event CollateralTokenCreated(
    string _tokenName,
    string _tokenSymbol,
    address indexed _tokenAddress
  );
  event ClaimsTokenCreated(string _tokenName, string _tokenSymbol, address indexed _tokenAddress);

  address[] internal tokens;

  /// @dev Ensures that only active Insurance Pools can create tokens
  modifier onlyPools(address _poolAddress) {coverage_0x9904d005(0x93de8cffc6fce08102b8c3351af633f2ddea23f283ad9d785556f2b98586d7de); /* function */ 

coverage_0x9904d005(0x362c524747d6dbb89cc29c0f88fd06c448a111ed93e976dcf8d6aad8b401d377); /* line */ 
    _;
coverage_0x9904d005(0x8b1b360a599cd0ec5bc05b024ca3fcd9aef48d4f8919b0fef0d2fa7ba7189ce8); /* line */ 
    coverage_0x9904d005(0x9f063b5296e7011a5d92811d5bd0ec9691b657b75089bc57ca29c3814641bd6e); /* statement */ 
EternalStorage eternalStorage = EternalStorage(eternalStorageAddress);

coverage_0x9904d005(0x2bfbe7c1565c8e52699a5f85dd039c18c5559adacb42fd3ac771b73c38c94d8c); /* line */ 
    coverage_0x9904d005(0x1acbddb3949245860f6153fc14c6aa4aea24ead468ffe9b016836a74f096143d); /* statement */ 
address insurancePool = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.address", _poolAddress)
    );

coverage_0x9904d005(0x1453ed8ecdaae95f9c6d09e51bff09e658322c748dde7a5c1a3c2c1337417084); /* line */ 
    coverage_0x9904d005(0x1ec1cc4337a5db51fc76432b15485efcee53fefcbd868c6fcc9d123b44e2ca68); /* assertPre */ 
coverage_0x9904d005(0xe2a83e2d8e8bfe2a6b295263a9baf35a1473c479086b104f07c64bd6e8fd086a); /* statement */ 
require(insurancePool != address(0), "PanDAO: Only insurance pools can create new tokens");coverage_0x9904d005(0x46eb31c9a5ef59592d8885e57f00338f6e6b8c97bb85683710e83b7f2e4c93db); /* assertPost */ 

  }

  constructor(address _eternalStorageAddress) public {coverage_0x9904d005(0x05cc5ef2d62759c862ee4e309533c0b9fb3af277392811ef13d1bb9cce8c3a39); /* function */ 

coverage_0x9904d005(0x94d34bf4a62ea36722cf0b37d113cbf5e2a37871bb47227d9211eb3ead7a6b66); /* line */ 
    coverage_0x9904d005(0x3cbc9f1abe19f8f2c32939b9d08e5de520ddcf8059c7c8b707da5b66f939f1ef); /* statement */ 
eternalStorageAddress = _eternalStorageAddress;
  }

  //////////////////////////////
  /// @notice Public
  /////////////////////////////

  /// @notice Create a set of Claim and Collateral Tokens for the Pool
  /// @dev Returns CollateralToken in index position 0 and Claims token in index position 1
  /// @param _insurableTokenSymbol string Insured token symbol
  /// @return address[] Array of token addresses.
  function createTokens(string memory _insurableTokenSymbol, address _insurancePoolAddress)
    public
    onlyPools(msg.sender)
    returns (address[] memory)
  {coverage_0x9904d005(0x22a89f9179792fea3fe7acd57e76869819d54066a4a009602fa5e6dd3c3f761a); /* function */ 

    /// Collateral token
coverage_0x9904d005(0x7a54f152bb8733237fa0f23ef29c6392529ae10de3a856b77080b26e5732e6e5); /* line */ 
    coverage_0x9904d005(0xd501f0bb4df08851f5030d129b10d5a451ef8060a972adefc6edd406d872109c); /* statement */ 
address collateralToken = _createCollateralToken(_insurableTokenSymbol, _insurancePoolAddress);
coverage_0x9904d005(0xd93158bcf8d08f172897694ac75984200591934f0f7af4d4d69798016303e102); /* line */ 
    coverage_0x9904d005(0xc61e8cb8fe3b4f66338e154673d949921c4e9384a712e2db7e8443ef766d3697); /* statement */ 
tokens.push(address(collateralToken));

    /// Claims token
coverage_0x9904d005(0xf3fc3fa3ad19642592401dc1956e6c4849b852402cdf6f7a29046ebf0ab30ec6); /* line */ 
    coverage_0x9904d005(0xe60fa8fc071c78c39c2017e75101635816b547af4fc97d971d9eb69b671a039c); /* statement */ 
address claimsToken = _createClaimsToken(_insurableTokenSymbol, _insurancePoolAddress);
coverage_0x9904d005(0x0c3055b03fbe601bc12f33ed2a1e3aeaa91052a5908088debd6dc126d6da14c6); /* line */ 
    coverage_0x9904d005(0x58cdbcf41f4ac4d53000a7f63db55e15e9cd2baeae9963851e9afb2ae6e311d1); /* statement */ 
tokens.push(address(claimsToken));

coverage_0x9904d005(0x8d5f601ac74f28e268cbfaee7f50ae9b162bbe3bba3148b7ece6a910b3f82784); /* line */ 
    coverage_0x9904d005(0x45ab285fbb23404695738a579e627509c73a12ae8d05ac8c6012c77f6ab71689); /* statement */ 
return tokens;
  }

  //////////////////////////////
  /// @notice Private
  /////////////////////////////

  /// @notice Create a claim token(mPAN)
  /// @param _insurableTokenSymbol string Insured token symbol
  /// @return address New token contract address
  function _createClaimsToken(string memory _insurableTokenSymbol, address _insurancePoolAddress)
    private
    returns (address)
  {coverage_0x9904d005(0x8ade4b4aaebe623560583b0b8412dcc4a2735d81e6afb2be9830c40a8141b7c2); /* function */ 

coverage_0x9904d005(0x0288c544b31e93c2a07ed6dcd476bb600652808db2b8551c3ea3a149f9751a03); /* line */ 
    coverage_0x9904d005(0xe2029b00ca8117ee2863d33f6e69c48f5d7cbe745358e9ba10ae16988487b41d); /* statement */ 
string memory claimsTokenName = StringHelper.concat(
      "PanDAO Claims Token - ",
      _insurableTokenSymbol
    );

coverage_0x9904d005(0xadaef4acba39961092c5ba1d6261064cab1117066fdf4541f1a49dfe88943c0c); /* line */ 
    coverage_0x9904d005(0x6cf1ae89cca390710f4b95471604e4478e5689ca0195ef193456e61ba8b90a09); /* statement */ 
InsuranceToken claimsToken = new InsuranceToken(
      claimsTokenName,
      "mPAN",
      eternalStorageAddress,
      _insurancePoolAddress
    );

coverage_0x9904d005(0xd0b2e3ad99185c2ccec43db1d967432cc7207cac661daae264ce2bbeb5d07a45); /* line */ 
    coverage_0x9904d005(0x020a40599c46942e7619129d669b79e8354a73c5bdfe61efe04cea4f693bb1b4); /* statement */ 
emit ClaimsTokenCreated(claimsToken.name(), claimsToken.symbol(), address(claimsToken));

coverage_0x9904d005(0xb97093e9ba174636915a81ba23f8a13e3e5b104d752216cb2d1d557ea2602f68); /* line */ 
    coverage_0x9904d005(0x12fc0e90485046f96bd365a288886092ed0549510bf4655907829dda23f0e69e); /* statement */ 
return address(claimsToken);
  }

  /// @notice Create a collateral token(cPAN)
  /// @param _insurableTokenSymbol string Insured token symbol
  /// @return address New token contract address
  function _createCollateralToken(
    string memory _insurableTokenSymbol,
    address _insurancePoolAddress
  ) private returns (address) {coverage_0x9904d005(0x4ec3edef202d54c8dfe8f7c51a5f8a6b009a671c7e9c0fa2a8ac02d42bb48c35); /* function */ 

coverage_0x9904d005(0x99c8b7ea8e087b6d13d1f3c318c63d06b6ea5a4a4fef343d8b4157c084e4f862); /* line */ 
    coverage_0x9904d005(0x49b3d57a6769e4d93fd116ff1511ca703f15cd9c045e5f9b3ffd5eb81170c391); /* statement */ 
string memory collateralTokenName = StringHelper.concat(
      "PanDAO Collateral Token - ",
      _insurableTokenSymbol
    );

coverage_0x9904d005(0xdfdffba34e45ce6cd1c600673b38f66dcc98e10e115e9b5cb9097d7ac9fd4972); /* line */ 
    coverage_0x9904d005(0xb410da5becc2261f63e0a1ca83f9bf8150004a7c3e13e869734eceb886cf74a5); /* statement */ 
InsuranceToken collateralToken = new InsuranceToken(
      collateralTokenName,
      "cPAN",
      eternalStorageAddress,
      _insurancePoolAddress
    );

coverage_0x9904d005(0xf3b5a351df637879bab615bb658dea10f0a0a401a7bcc088363e13a2899571cc); /* line */ 
    coverage_0x9904d005(0x43acba35c529b695b86d58064022b64b4281ae4373a3a1201ed668a56fe09ac0); /* statement */ 
emit CollateralTokenCreated(
      collateralToken.name(),
      collateralToken.symbol(),
      address(collateralToken)
    );

coverage_0x9904d005(0xeac2d2a14d725a3d650d5da28aea620089f0142e6165302a1e2bec8bc5d89442); /* line */ 
    coverage_0x9904d005(0x497720161029259dbc3735b23c75202272fd8b4518d6281e695ce9abaafa3bda); /* statement */ 
return address(collateralToken);
  }
}
