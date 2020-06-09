pragma solidity 0.6.6;

import "@nomiclabs/buidler/console.sol";
import "@pie-dao/proxy/contracts/PProxyPausable.sol";

// Imports
import "./EternalStorage.sol";
import "./lib/StorageHelper.sol";
import "./lib/StringHelper.sol";
import "./InsurancePool.sol";


/// @author PanDAO - https://pandao.org
/// @title PanDAO Contract Network Manager
/// @notice This contract can be used by PanDAO to manage `InsurancePools` and resolve claims
/// @dev All functionality controlled by Aragon AGENT
contract Manager {
function coverage_0xcd4d8852(bytes32 c__0xcd4d8852) public pure {}

  /// @dev Gives access to PanDAO Eternal Storage
  address public eternalStorageAddress;
  EternalStorage internal eternalStorage;

  //////////////////////////////
  /// @notice Modifiers
  /////////////////////////////

  /// @dev Ensures only Aragon Agent can call functions
  modifier onlyAgent() {coverage_0xcd4d8852(0x8fd3aecb986953f53cc219fb1973b7e75f1248194aca114c438f1d1842507b46); /* function */ 

coverage_0xcd4d8852(0xc3007cba0475a8e4c2b980e3967be641f4c52688537385beee4d2857d26a47ce); /* line */ 
    coverage_0xcd4d8852(0x1ab9770a653698385c4a72e3c42150f8f0326b762d899ba9dfb9a1b75e88f48c); /* assertPre */ 
coverage_0xcd4d8852(0xb45623fc0787c2b2fa5d1797615961a3d146fb0b83a56b188c14731d3d6ec495); /* statement */ 
require(
      eternalStorage.getAddress(StorageHelper.formatGet("dao.agent")) == msg.sender,
      "PanDAO: UnAuthorized - Agent only"
    );coverage_0xcd4d8852(0x6a9485a936f25315b24e6731c5c4006740d08067e6933850999bdb2d8a0b029e); /* assertPost */ 

coverage_0xcd4d8852(0x4846215bf61f35319be062f21e9d890a8197c725a65230a3762d526ae2be94a3); /* line */ 
    _;
  }

  /// @dev Ensures only the owning contract can call functions
  modifier onlyOwner(address _owner, address _contractAddress) {coverage_0xcd4d8852(0x108fa3db25bccc83fda4f62d1b76de79987eb53a2158dcfb44851700926c116a); /* function */ 

coverage_0xcd4d8852(0xcf9218e4603ac9246070f8421c33bac87ebf96872defe12addf2646c001f3865); /* line */ 
    coverage_0xcd4d8852(0x43db55bc882d15f77969311bc1bb4c1aa44cb820c2decd0dfdc90c5e9c2ed2b5); /* assertPre */ 
coverage_0xcd4d8852(0x79c2c59246d9f7aef0f06ab7c7d65beec9c920b325bd2b6407a5170f90be52ad); /* statement */ 
require(
      eternalStorage.getAddress(StorageHelper.formatAddress("contract.owner", _contractAddress)) ==
        _owner,
      "PanDAO: UnAuthorized - Contract owner only"
    );coverage_0xcd4d8852(0xef0319a7b5092cc61691fa5ce96ed13af3637d1e55af58f78d90d4f418ba1538); /* assertPost */ 

coverage_0xcd4d8852(0x1af6e915613e7646faf42d966efd017286bf14971baeb9b3721a89177c3c7fcd); /* line */ 
    _;
  }

  //////////////////////////////
  /// @notice Events
  /////////////////////////////

  event InsurancePoolCreated(address indexed insurancePoolAddress, string symbol);

  event InsurancePoolPaused(address indexed insurancePoolAddress, string symbol);

  constructor(address _eternalStorageAddress) public {coverage_0xcd4d8852(0x2365d41936e63c54320dcb6c140536b8f648ea10d299e468187f37ea32fa7350); /* function */ 

coverage_0xcd4d8852(0xa4709adafe0b05ea7c2265952c73b053a73007c8e3a0fef1f36e06b721e98020); /* line */ 
    coverage_0xcd4d8852(0x0a6642c1e009a97b1277767da105929e781014b1aa5c55b9c4b53be435c40ded); /* statement */ 
eternalStorageAddress = _eternalStorageAddress;
coverage_0xcd4d8852(0x463fe2d9f8d91a81765a210d26c2a9ebab53e8e3e7a53217456b6de6491570c2); /* line */ 
    coverage_0xcd4d8852(0x46a24c5dfcc9e0bdf4c8e278bb68709698aec0e4afae1c08a5f6f7c676287dda); /* statement */ 
eternalStorage = EternalStorage(eternalStorageAddress);
  }

  //////////////////////////////
  /// @notice Public Functions
  /////////////////////////////

  /// @notice Create a new PanDAO Insurance Pool
  /// @dev This function can only be called by the Aragon Agent
  /// @param _insuredTokenAddress address of the digital asset we want to insure
  /// @param _insuredTokenSymbol string token symbol
  /// @param _insureeFeeRate uint256 fee the insuree pays
  /// @param _serviceFeeRate uint256 DAO fee
  /// @param _premiumPeriod uint256 how often premium is pulled from the wallet insuree's wallet
  function createInsurancePool(
    address _insuredTokenAddress,
    string memory _insuredTokenSymbol,
    uint256 _insureeFeeRate,
    uint256 _serviceFeeRate,
    uint256 _premiumPeriod
  ) public onlyAgent() {coverage_0xcd4d8852(0x8923a381a54a5780f857d563f763e7dc472aac072ab8f18488aa35714ab2a23e); /* function */ 

coverage_0xcd4d8852(0x32b14887ec8ff55ad0b0256911e935ff2508b76382460ae79130286c66a86b4c); /* line */ 
    coverage_0xcd4d8852(0x48d5e7c6e46113c5fc1c3aa108b71d8bee73ba804fca1b0a069a552ab20910ea); /* assertPre */ 
coverage_0xcd4d8852(0xba66040c56e3fe07753360a78384f0031ee0aba0e44775fa9a44c188f264a785); /* statement */ 
require(
      eternalStorage.getAddress(
        StorageHelper.formatAddress("contract.address", _insuredTokenAddress)
      ) == address(0),
      "PanDAO: Insurance Pool already exists"
    );coverage_0xcd4d8852(0xf451a21ea42abbe5f3f64b06ae2510c78201fe6bc2101bca2f1c09759e6d56fb); /* assertPost */ 


coverage_0xcd4d8852(0xe3d3d92c49a96c7308453a841c9e0755c326e19b7bbfa93f3a66e310df0a3ba7); /* line */ 
    coverage_0xcd4d8852(0x04f2302722d6088b40ee1cad663ea75bbf2a24e5bc8bd4f508a1be9b78694c8d); /* statement */ 
InsurancePool insurancePool = new InsurancePool(
      _insuredTokenAddress,
      _insuredTokenSymbol,
      _insureeFeeRate,
      _serviceFeeRate,
      _premiumPeriod,
      eternalStorageAddress
    );

coverage_0xcd4d8852(0x9a56e91e7e1ef9b773e947a0ccb3a1e7368848dd2b34bf567067c267a7f3b3d7); /* line */ 
    coverage_0xcd4d8852(0x771e1a0f2105074811b068124b96a0d27940a269b82758e072bdbf51387414e3); /* statement */ 
PProxyPausable proxy = new PProxyPausable();
coverage_0xcd4d8852(0xa81dce8e03573234ce07dec87d19fb4189e168f89202c61bdeb7c79afda335d0); /* line */ 
    coverage_0xcd4d8852(0xc9a3da4e485efbddd706bd80e86086a0bd50f8e0de721fe4c4b1eccaff65bc90); /* statement */ 
proxy.setImplementation(address(insurancePool));
coverage_0xcd4d8852(0x08c2014d1298b3dbd3d9ec33f46e7d7cde96e88cb58fa1ef2a678fe416492713); /* line */ 
    coverage_0xcd4d8852(0xf3f0964cce9b92b26c5eced6278e9d2a0deac9d44fb0419e3517b519b6c86975); /* statement */ 
proxy.setPauzer(address(this));
coverage_0xcd4d8852(0x89e1ae25b3e0992c40b7b6533bdc3f306fc1b8186ffc5a840b751172e6104835); /* line */ 
    coverage_0xcd4d8852(0x74a694df4fafe3f1fa45b872b4a3fb1b7843d81ddd562b98d6beb204cac374c6); /* statement */ 
proxy.setProxyOwner(address(this));

coverage_0xcd4d8852(0x409835b1dac065a21077d778c83856f3b0a98627d54e7df74ec4d059ee9b307d); /* line */ 
    coverage_0xcd4d8852(0x42f8abd3e062e4884b802991dcb0f24e6c8064cabd6596c5d737fe76a7677794); /* statement */ 
emit InsurancePoolCreated(address(insurancePool), _insuredTokenSymbol);
  }

  function pauseNetwork() public onlyAgent() {coverage_0xcd4d8852(0x9958114d9cb83c73529a2e3f3cdacf5d739c862e7670c79484ae9c8fb6033c3d); /* function */ 
}

  function approveInsuranceClaim() public onlyAgent() {coverage_0xcd4d8852(0xc66374c49b3e49817294174c9bb45253cdb75dd111239b546c569a2b94162eaa); /* function */ 
}

  function denyInsuranceClaim() public onlyAgent() {coverage_0xcd4d8852(0x44e7a9b6705aa2338a07bd4561b2a0058373c4e579a81bc5c5911681127f2933); /* function */ 
}

  function updateContractImplementation() public onlyAgent() {coverage_0xcd4d8852(0xff73e3247f2f8279116747501494cc6c2522e871b9521e16232655c5532f4534); /* function */ 
}
}
