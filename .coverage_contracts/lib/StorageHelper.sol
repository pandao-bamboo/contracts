pragma solidity ^0.6.0;
import "../EternalStorage.sol";


library StorageHelper {
function coverage_0x0807d59e(bytes32 c__0x0807d59e) public pure {}

  /// @notice Initialized a new contract in EternalStorage
  /// @param _eternalStorage EternalStorage storage contract instance
  /// @param _contractAddress address Contract address to be initialized
  /// @param _contractOwner address Contract/Wallet address of owner(msg.sender)
  /// @param _contractName string Usually the insurableTokenSymbol
  function initializeInsurancePool(
    EternalStorage _eternalStorage,
    address _contractAddress,
    address _contractOwner,
    string memory _contractName
  ) internal returns (bool) {coverage_0x0807d59e(0x98cb62ab9d537a36a4a59fadb8bbf6dc796b7630703c09c5f3f48ea769c568bd); /* function */ 

    /// @dev initialize contract in EternalStorage
coverage_0x0807d59e(0x74a7add805a2f811c673bc051dfa1e3dd558f423feec21a03510da2125bcb359); /* line */ 
    coverage_0x0807d59e(0xfd7a1831f94480171b9663baf8f9bd6231d5181c24cd8749ad81b6dcbbc3ed06); /* statement */ 
_eternalStorage.setAddress(formatAddress("contract.owner", _contractAddress), _contractOwner);
coverage_0x0807d59e(0xd5d221451a22fe21b07bc3ff4291de92abe281488d341d772e82ee90f174ae07); /* line */ 
    coverage_0x0807d59e(0x0f7a3731c1b31224c57899ce180e7afa2d196c9006f11d28ee80e6d06b17ce1f); /* statement */ 
_eternalStorage.setAddress(
      formatString("insurance.pool.name", _contractName),
      _contractAddress
    );
coverage_0x0807d59e(0xc2ba5209ee881d740f7ef7a86a65054ca5dfd518b023a9f832f5dc63f28ce271); /* line */ 
    coverage_0x0807d59e(0x728cf2bc155da8ece717f29345aacefe538d735a5c459c3abb13d0054d671e3e); /* statement */ 
_eternalStorage.setAddress(
      formatAddress("insurance.pool.address", _contractAddress),
      _contractAddress
    );

coverage_0x0807d59e(0xfdbd983666c1131a79d3989e61168aeb7cfa9363330ea33f0f6c7ac665da398b); /* line */ 
    coverage_0x0807d59e(0x17f0ebbb8088be8f456645d3485c07c6f62faf7c4977657f795d1789a052cdc7); /* statement */ 
return true;
  }

  /// @notice Saves Insurance Pool Data to EternalStorage
  /// @param _eternalStorage EternalStorage storage contract instance
  /// @param _insurancePoolAddress address Insurance pool address
  /// @param _collateralTokenAddress address Collateral token address
  /// @param _claimsTokenAddress address Claims token address
  /// @param _insuredTokenAddress address Insured token address
  /// @param _insuredTokenSymbol string Token symbol
  /// @param _insureeFeeRate uint256 Rate insurance buyer pays
  /// @param _serviceFeeRate uint256 Rate paid to the DAO
  /// @param _premiumPeriod uint256 Premium period in blocks
  /// @dev insureeFeeRate - serviceFeeRate = Liquidity Provider Earnings
  function saveInsurancePool(
    EternalStorage _eternalStorage,
    address _insurancePoolAddress,
    address _collateralTokenAddress,
    address _claimsTokenAddress,
    address _insuredTokenAddress,
    string memory _insuredTokenSymbol,
    uint256 _insureeFeeRate,
    uint256 _serviceFeeRate,
    uint256 _premiumPeriod
  ) internal {coverage_0x0807d59e(0x979775814a16056edac61e48d89155b00c1dd87d2c8cb966afb9f5b9050349a3); /* function */ 

    /// @dev Saves IPool to EternalStorage
coverage_0x0807d59e(0xb4c2a38b028f598aab7f385cad652054d580714a61ca43f4b053c4ec0c695475); /* line */ 
    coverage_0x0807d59e(0x8fe78d8ef173c645e3a211a2b276d5b21608e7de7fa545e284d0613cd7268e92); /* statement */ 
_eternalStorage.setAddress(
      formatAddress("insurance.pool.collateralToken", _insurancePoolAddress),
      _collateralTokenAddress
    );
coverage_0x0807d59e(0x1b68225f59f1c22eb9a700b908745db725411665eac3eb33ec10134339cf12c7); /* line */ 
    coverage_0x0807d59e(0x613bd2d24f6e43eb99fa5bc9950a8ba35a862f00232678c663e28a7e4c0e6e78); /* statement */ 
_eternalStorage.setAddress(
      formatAddress("insurance.pool.claimsToken", _insurancePoolAddress),
      _claimsTokenAddress
    );
coverage_0x0807d59e(0xbfba5701f2188e469e4832b21d302d82694b46f7c0997b92dbe650b197c1a902); /* line */ 
    coverage_0x0807d59e(0x42fbf3cc9fbfbc6ee78baa2a24557dc37172e2402cd5e9ba83f1e11b77f73709); /* statement */ 
_eternalStorage.setAddress(
      formatAddress("insurance.pool.insuredToken", _insurancePoolAddress),
      _insuredTokenAddress
    );
coverage_0x0807d59e(0x9fbfd35f4749f990f9d64d4b7b96dd2508c8c18f7275dcf2d2b2e717a57e6792); /* line */ 
    coverage_0x0807d59e(0xb3b4540918bda622c4acf6df8e3476e847ac61f455f3952864b3428cd1412684); /* statement */ 
_eternalStorage.setAddress(
      formatAddress("insurance.pool.insuredToken", _insuredTokenAddress),
      _insuredTokenAddress
    );
coverage_0x0807d59e(0x8725209cc44e75ac23e1ad20861936d60e38e1ccfbacffaf3a1e8b2704001a15); /* line */ 
    coverage_0x0807d59e(0x333f0e938855631a36ea88fc2fc66212c5c5181db07b1487ccd8533fdc658eac); /* statement */ 
_eternalStorage.setString(
      formatAddress("insurance.pool.insuredTokenSymbol", _insurancePoolAddress),
      _insuredTokenSymbol
    );
coverage_0x0807d59e(0x039c67f37cc11da53dbe72a4256a07248da6557da78d9d543f1ee0f83601a238); /* line */ 
    coverage_0x0807d59e(0xd2c9d1318b626265fcf7c49d2bc14d2ce69dfc6834253a23d4dcc025d8c478ba); /* statement */ 
_eternalStorage.setUint(
      formatAddress("insurance.pool.insureeFeeRate", _insurancePoolAddress),
      _insureeFeeRate
    );
coverage_0x0807d59e(0x44fae45e78f9b00fe603c1e7b2c0f92116719d31a000be44ba2dee794706dc6d); /* line */ 
    coverage_0x0807d59e(0xa9680eb4427959178381d8d568ee33cb39b8371f2f8d99a57a65d913a266e29b); /* statement */ 
_eternalStorage.setUint(
      formatAddress("insurance.pool.serviceFeeRate", _insurancePoolAddress),
      _serviceFeeRate
    );
coverage_0x0807d59e(0x1372c47c34a76de758cf0c3943f64d3f73a52bde4c4198ffe85b8f49e2b79157); /* line */ 
    coverage_0x0807d59e(0x62d24c1043896ed9af0944832bd76eadfcf4c91613f58a36f108a1f269979681); /* statement */ 
_eternalStorage.setUint(
      formatAddress("insurance.pool.premiumPeriod", _insurancePoolAddress),
      _premiumPeriod
    );
  }

  // Setter Format
  function formatAddress(string memory _storageLocation, address _value)
    internal
    pure
    returns (bytes32)
  {coverage_0x0807d59e(0x93000be8698c82b4e46ea4a688d09b070f3b1db08845392d8868e40732b080c0); /* function */ 

coverage_0x0807d59e(0x85896f496a9ee21609c401fd7522e1d573b0419c131765596d27402adef606f1); /* line */ 
    coverage_0x0807d59e(0xe5eca5627b372f06a8b5d98dcdab2c9a7c2e6c87960d97757922c1ec86636bc1); /* statement */ 
return keccak256(abi.encode(_storageLocation, _value));
  }

  function formatBool(string memory _storageLocation, bool _value) internal pure returns (bytes32) {coverage_0x0807d59e(0x771b5b6b9fd35ea9cd5fc243b6aef022f500086b87bfb219451946ac6198c043); /* function */ 

coverage_0x0807d59e(0x53eea6764df008f70161ff3e19cad0a77072fd95e129ec4e8e64f539c7322ee7); /* line */ 
    coverage_0x0807d59e(0x8d06c2c4a351ae89414bfeda16bb0da170698f79657d210505120ba52a6afd53); /* statement */ 
return keccak256(abi.encode(_storageLocation, _value));
  }

  function formatInt(string memory _storageLocation, int256 _value)
    internal
    pure
    returns (bytes32)
  {coverage_0x0807d59e(0x028e5bb4f39c36cc0e6bad6b15565e47bb53ba825c5ed9970f3c2f1cb5769c18); /* function */ 

coverage_0x0807d59e(0x6217f0f354b69653a3dc3fe48ae588b6e2933452a160b82299eef383700d01a1); /* line */ 
    coverage_0x0807d59e(0x642fff9450d5c1a721809ae7ae64ec495b8a0e867cb2863bf320cf65dd04f70d); /* statement */ 
return keccak256(abi.encode(_storageLocation, _value));
  }

  function formatString(string memory _storageLocation, string memory _value)
    internal
    pure
    returns (bytes32)
  {coverage_0x0807d59e(0x1f3cf61ef05848ea49681f2e5dbba20b467fbd7abb38e92dcecb01e9419d2bee); /* function */ 

coverage_0x0807d59e(0xcdda782322e6e4e144f1d6332f59c800ae08f05f337c25fab99c3093546ce4c7); /* line */ 
    coverage_0x0807d59e(0x0cc27e443dc5568aa09e7421b9a38989a26012bfe493cefc4e0a093be64a8a9a); /* statement */ 
return keccak256(abi.encode(_storageLocation, _value));
  }

  function formatUint(string memory _storageLocation, uint256 _value)
    internal
    pure
    returns (bytes32)
  {coverage_0x0807d59e(0x20255375c73764e9423a5606756641bec2ca54e5d89e5249239253fcafaea497); /* function */ 

coverage_0x0807d59e(0xd6dc1e730ff770e37c7a19107d93086a9fc00de799f913acecae93cc7ec9e2e3); /* line */ 
    coverage_0x0807d59e(0x1925880c3401475d503dd6c1aed863814e220ad9a5179e5bd16b9aabd462d296); /* statement */ 
return keccak256(abi.encode(_storageLocation, _value));
  }

  // Getter Format
  function formatGet(string memory _location) internal pure returns (bytes32) {coverage_0x0807d59e(0xe81c0ae97dab5be2ec4e78909b73178136687195cce3959c337d866f97430219); /* function */ 

coverage_0x0807d59e(0x0ae245e520958a15227e966cb2e3f06d53f122e4efcdb3c88f712c22964a061e); /* line */ 
    coverage_0x0807d59e(0x954f0c0a77c709fff856942c3fc5d38e82d43c3c3d292aae9b6af0faeba652f8); /* statement */ 
return keccak256(abi.encode(_location));
  }
}
