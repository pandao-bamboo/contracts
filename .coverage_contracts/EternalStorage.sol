pragma solidity 0.6.6;
pragma experimental ABIEncoderV2;

import "./lib/StorageHelper.sol";
import "./InsurancePool.sol";


/// @author PanDAO - https://pandao.org
/// @title  Implementation of Eternal Storage(https://fravoll.github.io/solidity-patterns/eternal_storage.html)
/// @notice This contract is used for storing contract network data
/// @dev PanDAO network contracts can read/write from this contract
contract EternalStorage {
function coverage_0xcf343fca(bytes32 c__0xcf343fca) public pure {}

  struct InsurancePoolQueuePosition {
    address liquidityProviderAddress;
    uint256 amount;
  }

  struct Storage {
    mapping(bytes32 => uint256) uIntStorage;
    mapping(bytes32 => string) stringStorage;
    mapping(bytes32 => address) addressStorage;
    mapping(bytes32 => bool) boolStorage;
    mapping(bytes32 => int256) intStorage;
    mapping(bytes32 => bytes) bytesStorage;
    mapping(address => InsurancePoolQueuePosition[]) insurancePoolQueueStorage;
  }

  Storage internal s;

  //////////////////////////////
  /// @notice Modifiers
  /////////////////////////////
  modifier onlyCurrentImplementation() {coverage_0xcf343fca(0x9e80bf191960f648d1dde458e43db41c434d84cbab92f1e46009c3c7e6b5eac3); /* function */ 

coverage_0xcf343fca(0x7acba45751316cd39ce541acdecb0268c53262432f00f189d2e11fdafa53f698); /* line */ 
    _;
  }

  //////////////////////////////
  /// @notice Getter Functions
  /////////////////////////////

  /// @notice Get stored contract data in uint256 format
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  /// @return uint256 _value from storage _key location
  function getUint(bytes32 _key) external view returns (uint256) {coverage_0xcf343fca(0x3d4038b503ef09f4633a00d890157ea60cb1803448e5730b1ae8d5ea0b509ca0); /* function */ 

coverage_0xcf343fca(0x95268541afd5483cd3d8c5ef66d021db714391ccc7070ed249cb4f164c7f9c46); /* line */ 
    coverage_0xcf343fca(0xbc1f056a58133ad8309d6c093478a8ad4e06c438489e73f95c3875aa6c7a0055); /* statement */ 
return s.uIntStorage[_key];
  }

  /// @notice Get stored contract data in string format
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  /// @return string _value from storage _key location
  function getString(bytes32 _key) external view returns (string memory) {coverage_0xcf343fca(0x2aaa9bbc16a741b165ceccdd5f636b7a7632cd15c4c5dd7321823827dbec1be6); /* function */ 

coverage_0xcf343fca(0x628593b5f1dfd9239139c7d43028a88f60f75e79b7bd0ad016a60f9e5b01035a); /* line */ 
    coverage_0xcf343fca(0xaaf92a2a245ddbb2595942811bd9eb947e7f8b9c5ad49a87f5873a8e88950e9f); /* assertPre */ 
coverage_0xcf343fca(0xcd76fce4bb23f59671ee364314eb5c05e02a18e8260696018e1cb24828253ac1); /* statement */ 
require(_key[0] != 0);coverage_0xcf343fca(0xe3de47a28689bdd1e292ce322f00ba8839863afea59ffda3d013de1697b88934); /* assertPost */ 


coverage_0xcf343fca(0xa29f11f5121b6cc02e38dec6f70488b2bc3ac94211f7ca311ff4ef3420b3abe3); /* line */ 
    coverage_0xcf343fca(0x35a203873783ba26d1477031aa10b35f14e3390e4220ea9a6e6df507f2ba60fd); /* statement */ 
return s.stringStorage[_key];
  }

  /// @notice Get stored contract data in address format
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  /// @return address _value from storage _key location
  function getAddress(bytes32 _key) external view returns (address) {coverage_0xcf343fca(0x61abca2cf5fa4acbd1704e67b717b27e57f90cbdd59d58714c8d269c41b3ad7c); /* function */ 

coverage_0xcf343fca(0x82d40a5e863c628dc93a51cab89eac0b3f845b8e0e0679f3fa13c75259553cea); /* line */ 
    coverage_0xcf343fca(0xc1d83eb7357b276a288272f90e75987d5745a0e1275c274381fa304300b06e74); /* statement */ 
return s.addressStorage[_key];
  }

  /// @notice Get stored contract data in bool format
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  /// @return bool _value from storage _key location
  function getBool(bytes32 _key) external view returns (bool) {coverage_0xcf343fca(0xa98db38e106f046a9e5368af0812082ca8ff7cae8f78ad74bcb9a638ec8bf3e0); /* function */ 

coverage_0xcf343fca(0x13ee7761327663823bd4f7bb2b3a108ebe7944f7a535a762eefd6abbb294160b); /* line */ 
    coverage_0xcf343fca(0xad889dbdd8192efa8733620dbfe6cf638e07d91b8769136b3cd3a26f5dc72fee); /* statement */ 
return s.boolStorage[_key];
  }

  /// @notice Get stored contract data in int256 format
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  /// @return int256 _value from storage _key location
  function getInt(bytes32 _key) external view returns (int256) {coverage_0xcf343fca(0xde41c3755cdd05ae65ff60597ca4d4da9af19e3988206fab5a804ea78e804650); /* function */ 

coverage_0xcf343fca(0x72a0d7f7d10ada88d015728844afb876663f73afd402db67cfb4fb341c763818); /* line */ 
    coverage_0xcf343fca(0x9e72cdae3a6c229ec68ac3ec866440123f8d6623c9364560c402f6e2ce935524); /* statement */ 
return s.intStorage[_key];
  }

  /// @notice Get stored contract data in bytes format
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  /// @return bytes _value from storage _key location
  function getBytes(bytes32 _key) external view returns (bytes memory) {coverage_0xcf343fca(0xe855c8ec29ab571969860f36f1d7c9ef4ffc9a835e9a7288c1d9f38bfe948246); /* function */ 

coverage_0xcf343fca(0x29d147be64ee5a7d544cff3b3aec484e658de9874e79c877979ab27b461e2414); /* line */ 
    coverage_0xcf343fca(0xc1680a9c00fae5e9bb553f350291f98d87ab37b236c49891c17df754f13ff38d); /* assertPre */ 
coverage_0xcf343fca(0x88573b5bc6cb695cea50cf0a1c6323a9ef8d8b94373719d869e36af441e65cf9); /* statement */ 
require(_key[0] != 0);coverage_0xcf343fca(0xc7dc0bcfc40de3b25cc3de4d7d1e87acb17887f1d4c2271d900f6a3627cd9a2f); /* assertPost */ 


coverage_0xcf343fca(0x419c6fe73aa178967c4ccaeca191125c00f2f4ff75fe8ca340bb12fcafa77bdd); /* line */ 
    coverage_0xcf343fca(0xb4d1747d0a4e42c6461b68e9bcda4bc5c2ba4a945c0eeb5f4225b31f02e5d939); /* statement */ 
return s.bytesStorage[_key];
  }

  /// @notice Returns index of InsurancePoolQueuePositions by Liquidity Provider Address
  /// @param _insuredTokenAddress Address for the token that is insured
  /// @param _liquidityProviderAddress Address for the liquidity provider
  /// @return InsurancePoolQueuePosition[] Array of InsurancePoolQueuePosition Structs for the given liquidity provider address
  function getInsurancePoolQueuePositions(
    address _insuredTokenAddress,
    address _liquidityProviderAddress
  ) external view returns (InsurancePoolQueuePosition[] memory) {coverage_0xcf343fca(0x97d1d012c0e99e457ccd81781fc6254e0691830af141426779d9370b859a072a); /* function */ 

coverage_0xcf343fca(0x534e35f3be12b774025e6a894604a5b794895a73e82cb69cabe699c49d8bd65f); /* line */ 
    coverage_0xcf343fca(0x12d220332e6ab14d2ac6f26256b1d54776763e0ebf2175d0acfa722eba9d5f9f); /* statement */ 
InsurancePoolQueuePosition[] memory insurancePoolQueue = s
      .insurancePoolQueueStorage[_insuredTokenAddress];

coverage_0xcf343fca(0xc694c82df68584ff4eef548edefa3c5952f84248c6b06a0dd8a9ca108cb94275); /* line */ 
    coverage_0xcf343fca(0x6f66ff7596b0bec799cdb8b731ea9a146814ef438f377e67742236d4b16ff81e); /* statement */ 
InsurancePoolQueuePosition[] memory liquidityProviderPositions;

coverage_0xcf343fca(0xf782eafadca11be9b06f797952519add9d63ca88ee4862a8c4e1cd28ead90b57); /* line */ 
    coverage_0xcf343fca(0x75dcca73f14cf1ff8687bbb78e45e685d35cb1fec571d06e6e0c54e3f24d0760); /* statement */ 
for (uint256 i = 0; insurancePoolQueue.length <= i; i++) {
coverage_0xcf343fca(0x32fd10c193b151439d658f801f6d0929f9bc3e568c6da2490058157aafe5d283); /* line */ 
      coverage_0xcf343fca(0x425efae9acf490bf0b796300d25733ce9dc23eb8a5a5e418a40751ad5157c88b); /* statement */ 
if (insurancePoolQueue[i].liquidityProviderAddress == _liquidityProviderAddress) {coverage_0xcf343fca(0x682cc6bd66979b851ccd64c11654a1a1833f45feadd5add61f64570dcfe956bb); /* branch */ 

coverage_0xcf343fca(0x0602c6da6e45450096dc4dde2b6bf1f189f9e0a55a67e059be8c0d7c90c63753); /* line */ 
        coverage_0xcf343fca(0xb40e28169a04ecfe210daf9e233105e5a00ed2f69b7567d24ae3c73c03d245a8); /* statement */ 
liquidityProviderPositions[liquidityProviderPositions.length] = insurancePoolQueue[i];
      }else { coverage_0xcf343fca(0x5f872b6a0695353fe47a7b4f3f9cf63d2d67f0bce29ac22c4fb0c3b3ed323219); /* branch */ 
}
    }

coverage_0xcf343fca(0xdfde38cd6e37b68bd87c4e2cf5183c65dc1ae8ee1b66bb842dfca9d70e1bb54f); /* line */ 
    coverage_0xcf343fca(0xd37c1776af388d37608d6c7d3101c6e2cd53e512ba8aacb2ca860da5712db104); /* statement */ 
return liquidityProviderPositions;
  }

  function getInsurancePoolQueue(address _insuredTokenAddress)
    external
    view
    returns (InsurancePoolQueuePosition[] memory)
  {coverage_0xcf343fca(0x82a7f697a747c30ac33d9115a1c9cb196d4f3370fc6ed30c69b81b9fa833819e); /* function */ 

coverage_0xcf343fca(0xe69c50e911d90c4459dd427ec19b05e76c2e98472eadc288abe3e44bc1d7f600); /* line */ 
    coverage_0xcf343fca(0xde98e3e2d4bb447f6b88d1ddd73e5fcd7d3f63f106fc09969e4887e1f8e0ffc4); /* statement */ 
InsurancePoolQueuePosition[] memory insurancePoolQueue = s
      .insurancePoolQueueStorage[_insuredTokenAddress];

coverage_0xcf343fca(0xd2736a8861d709db6970e52dfbd2eb3fa93331b496f2a4d13a8ebd78a15e27b4); /* line */ 
    coverage_0xcf343fca(0x7aecf935979a3baabc30221fa8d33233da6baf2a0fb732b41f2abcf9cf6befd9); /* statement */ 
return insurancePoolQueue;
  }

  //////////////////////////////
  /// @notice Setter Functions
  /////////////////////////////

  /// @notice Store contract data in uint256 format
  /// @dev restricted to latest PanDAO Networks contracts
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  /// @param _value uint256 value
  function setUint(bytes32 _key, uint256 _value) external {coverage_0xcf343fca(0xaa5407459013e075af39042428a22e61822fd2ecf6d6276e578babbc0d6cd028); /* function */ 

coverage_0xcf343fca(0x1930528589e8b7ca3dace94ef316556c01832a4e3b478212d2cab134ab424a76); /* line */ 
    coverage_0xcf343fca(0x8da3140c7d14f9d9be69cbb9e2c1edf7373a726e14e3c9ce6404d70eec288d5f); /* statement */ 
s.uIntStorage[_key] = _value;
  }

  /// @notice Store contract data in string format
  /// @dev restricted to latest PanDAO Networks contracts
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  /// @param _value string value
  function setString(bytes32 _key, string calldata _value) external {coverage_0xcf343fca(0x77d4b7f8e0dade344bb8ff8ff1fd58626c5d0bb86574db89234b27716b248470); /* function */ 

coverage_0xcf343fca(0x6320d3b58ff19e5d171330422ef3af07dbe1d734ebc0687c1361d5bdad3168fd); /* line */ 
    coverage_0xcf343fca(0xa316fab9e8b5f0d7c66bffa67e6bf6d5acdb41daf410f005019c0430bf9c6ade); /* statement */ 
s.stringStorage[_key] = _value;
  }

  /// @notice Store contract data in address format
  /// @dev restricted to latest PanDAO Networks contracts
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  /// @param _value address value
  function setAddress(bytes32 _key, address _value) external {coverage_0xcf343fca(0x673fc54dbcbab3ba3e15684e8dc319170cf0877c5fb57b00699fc7d929fad487); /* function */ 

coverage_0xcf343fca(0xb43a0fb7618bb49a88bb3076df9e5870b6d5fc07a7fc2e0ee2cc3b3cd8bd58ab); /* line */ 
    coverage_0xcf343fca(0xa818821da8888a9fda372bb9f894594cae09bd7aeddd98d29e27a193cc805d47); /* statement */ 
s.addressStorage[_key] = _value;
  }

  /// @notice Store contract data in bool format
  /// @dev restricted to latest PanDAO Networks contracts
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  /// @param _value bool value
  function setBool(bytes32 _key, bool _value) external {coverage_0xcf343fca(0xfba254ea27ca07b21e7ab0fb7f401294f804a2dbd4d3b150b010fdc4e934b21f); /* function */ 

coverage_0xcf343fca(0x703b3c17c4b3a9648b9ade481ba68749b48c352ec4baa543b992cc060e63276f); /* line */ 
    coverage_0xcf343fca(0xe8fb9c8a4179fa7ef5e6b2265c01000c4536154c7e8adea0e8bfe58840ab2aa5); /* statement */ 
s.boolStorage[_key] = _value;
  }

  /// @notice Store contract data in int256 format
  /// @dev restricted to latest PanDAO Networks contracts
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  /// @param _value int256 value
  function setInt(bytes32 _key, int256 _value) external {coverage_0xcf343fca(0xb9bfbe405916d4ab3c292c5a04f42e57e5e9fb682e60516c9465d4185fe923f9); /* function */ 

coverage_0xcf343fca(0xa02bfece2a0be99077d4fcaa29f437bbc4d97da8a3c1c708fb40335694f649b2); /* line */ 
    coverage_0xcf343fca(0xa9d9f0c53ec26f0c98d7e27cef52ff426151c691f03f3acdb23ba8992b57a323); /* statement */ 
s.intStorage[_key] = _value;
  }

  /// @notice Store contract data in bytes format
  /// @dev restricted to latest PanDAO Networks contracts
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  /// @param _value bytes value
  function setBytes(bytes32 _key, bytes calldata _value) external {coverage_0xcf343fca(0x52f378ab986673a71e20cb6e0a7d3b159ba122f63c20c52c43bf924d1cede9fa); /* function */ 

coverage_0xcf343fca(0xabdd74debf984543acb970a62c83d5083bde54998967ac6a6c10f982cdef32be); /* line */ 
    coverage_0xcf343fca(0x8efaa7ad5a4883d7b3b677c109655300be6f7d878d83bd43c0d0d8f81837b9fd); /* statement */ 
s.bytesStorage[_key] = _value;
  }

  /// @notice Store contract data in int256 format
  /// @dev restricted to latest PanDAO Networks contracts
  function setInsurancePoolQueuePosition(
    address _insuredTokenAddress,
    address _liquidityProviderAddress,
    uint256 _amount
  ) external {coverage_0xcf343fca(0x2fe76502f4a4985cf0b69f1f052bef3beb2eec63c7e790793754377cd35da462); /* function */ 

coverage_0xcf343fca(0xaae1c7060b687a613307beeafc0d59ac5c1c55d2d70634a9f90bcbd66f28e2ca); /* line */ 
    coverage_0xcf343fca(0x7bcd7d72fea1c5c63413f883440b38c6fa9d80a468f70bfe3785de1d40a2b08d); /* statement */ 
InsurancePoolQueuePosition memory insurancePoolQueuePosition;
coverage_0xcf343fca(0xa1d95f852c33e831b79f41e5a4d9cb4411bc42ee755605abc78cd1a4d680d5f0); /* line */ 
    coverage_0xcf343fca(0x2578e170e3f02b5f53b6042876590f966dd755ba61bbcb2cb0941caed443ba8a); /* statement */ 
insurancePoolQueuePosition.liquidityProviderAddress = _liquidityProviderAddress;
coverage_0xcf343fca(0xcafa7b4804ce9f1e59edb0a75feecaa89eb25617f6b4c680762582bb5d2dd008); /* line */ 
    coverage_0xcf343fca(0x45aabaa47c4bf036daea33c255701faba483d61cd57a5f1fa0c2e3a0153d5ecf); /* statement */ 
insurancePoolQueuePosition.amount = _amount;

coverage_0xcf343fca(0x207a7cccdc94dffe788655219cbbf37b626908a18c493a3301d8ed0ecf742f37); /* line */ 
    coverage_0xcf343fca(0x9b9bb6784f7eb7a40b713944c5c3a8ced7aba4992b89c0156667ed4468c0b64b); /* statement */ 
s.insurancePoolQueueStorage[_insuredTokenAddress].push(insurancePoolQueuePosition);
  }

  //////////////////////////////
  /// @notice Delete Functions
  /////////////////////////////

  /// @notice Delete stored contract data in bytes format
  /// @dev restricted to latest PanDAO Networks contracts
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  function deleteUint(bytes32 _key) external {coverage_0xcf343fca(0x006c6b8f2216db2bdea214fa5badd79bcdfd84ba88654cd17a62789686efdba1); /* function */ 

coverage_0xcf343fca(0xb53d53dd7584e05d00ea327bd42a1e804ea7718eb6aefdbcaca52d7d16210abd); /* line */ 
    delete s.uIntStorage[_key];
  }

  /// @notice Delete stored contract data in string format
  /// @dev restricted to latest PanDAO Networks contracts
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  function deleteString(bytes32 _key) external {coverage_0xcf343fca(0xca22a010ed0eeeadead3dac261be08e6ae2890a0acfa1e7fae8f7c1c5c6c0a4a); /* function */ 

coverage_0xcf343fca(0x8ea82e4269ee213523bee1d20c3c036f48ee6eee2402e5d782c2c011424df015); /* line */ 
    delete s.stringStorage[_key];
  }

  /// @notice Delete stored contract data in address format
  /// @dev restricted to latest PanDAO Networks contracts
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  function deleteAddress(bytes32 _key) external {coverage_0xcf343fca(0x543d08847bb0d0e0578bbb228928f46ccdbd0905a35bf4ce06ddbc99c5e6ac42); /* function */ 

coverage_0xcf343fca(0x699a15fc7b48d58e0965e1f3ec55d0ca5d6eeeac5a293ad3f60864f862824ae6); /* line */ 
    delete s.addressStorage[_key];
  }

  /// @notice Delete stored contract data in bool format
  /// @dev restricted to latest PanDAO Networks contracts
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  function deleteBool(bytes32 _key) external {coverage_0xcf343fca(0xef9c71eb0c5cd44211331af8961518281b6220a042c1b5308c95badf9b6b8078); /* function */ 

coverage_0xcf343fca(0x98a3a29346345e7908cd680a213af1e7a0dede37e8f1844e24a951dcfe97d220); /* line */ 
    delete s.boolStorage[_key];
  }

  /// @notice Delete stored contract data in int256 format
  /// @dev restricted to latest PanDAO Networks contracts
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  function deleteInt(bytes32 _key) external {coverage_0xcf343fca(0xdd1c5d98b1e0eb0774c11915854ff87f9001363cc94187d2d04ef5808a67a3b2); /* function */ 

coverage_0xcf343fca(0x29824743a9126622e1814720fbca34d3a9bb6838a75e041ec734cd25e1dba3a5); /* line */ 
    delete s.intStorage[_key];
  }

  /// @notice Delete stored contract data in bytes format
  /// @dev restricted to latest PanDAO Networks contracts
  /// @param _key bytes32 location should be keccak256 and abi.encodePacked
  function deleteBytes(bytes32 _key) external {coverage_0xcf343fca(0x80b688d164169cc64ee51aea55a542107028141418b17ff250a0472b32d667d0); /* function */ 

coverage_0xcf343fca(0xc160de587eb797a2e167710f0451a1962a95473e866f45ff86712630e28223fc); /* line */ 
    delete s.bytesStorage[_key];
  }

  function deletePositionFromInsurancePoolQueue(
    address _insuredTokenAddress,
    address _liquidityProviderAddress,
    uint256 _amount
  ) external view {coverage_0xcf343fca(0xd9aed671d0e61fc9c30c276e37b027b55b022879d08cb2edaf2623360549a5ab); /* function */ 

coverage_0xcf343fca(0xf64ff00e1c2f6594cadab7e1cc417adb853f7f48bc8f581f4ab0f930a57572f2); /* line */ 
    coverage_0xcf343fca(0x8b046d7c75d61c471a1a5de935c8d7018384cd0dcf2da3faf8de0e2eda3dd0f3); /* statement */ 
InsurancePoolQueuePosition[] memory insurancePoolQueue = s
      .insurancePoolQueueStorage[_insuredTokenAddress];

coverage_0xcf343fca(0x620cdfba0e0f5125b378535da7b76fcacd093f8acf29c432de3c557db5e0ae66); /* line */ 
    coverage_0xcf343fca(0x449627f52cf9acc06f1c32e9c716416c8a3539b7391cd37896ad5e7b504064c8); /* statement */ 
for (uint256 i = 0; insurancePoolQueue.length <= i; i++) {
coverage_0xcf343fca(0x837dc85aa015de7525c16d360146ca51c8aca93abfa9c587dcbb85da748de033); /* line */ 
      coverage_0xcf343fca(0x2783543ea38e4252ad770d212c7fe45690479a596d81dd8ecbb3bfc37fa0c2cb); /* statement */ 
if (
        insurancePoolQueue[i].liquidityProviderAddress == _liquidityProviderAddress &&
        insurancePoolQueue[i].amount == _amount
      ) {coverage_0xcf343fca(0xd474b091a69cababd445c318e0f1c35bcb44b481b70a7393633d7869df10946e); /* branch */ 

coverage_0xcf343fca(0x0ac199c90863097c7479cd803b633c0c44827b49f7f5608407b262b33a78e700); /* line */ 
        delete insurancePoolQueue[i];
      }else { coverage_0xcf343fca(0x5933001d31c2428a838d0fd9a340e99de53aca07548200ef3318ca04273afabf); /* branch */ 
}
    }
  }
}
