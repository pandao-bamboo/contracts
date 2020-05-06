pragma solidity 0.6.6;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";


// PanDAO implementation of Eternal Storage(https://fravoll.github.io/solidity-patterns/eternal_storage.html)
// Influenced by Rocket Pools implementation(https://github.com/rocket-pool/rocketpool/blob/master/contracts/RocketStorage.sol)
// Storage only controllable by DAO Agent

contract Storage is Ownable {
    mapping(bytes32 => uint256) private uIntStorage;
    mapping(bytes32 => string) private stringStorage;
    mapping(bytes32 => address) private addressStorage;
    mapping(bytes32 => bool) private boolStorage;
    mapping(bytes32 => int256) private intStorage;

    modifier restrictVersionAccess() {
        if (
            boolStorage[keccak256(
                abi.encodePacked("contract.storage.initialized")
            )] == true
        ) {
            // makes sure correct contract versions have access to storage
            require(
                addressStorage[keccak256(
                    abi.encodePacked("contract.address", msg.sender)
                )] != address(0x0)
            );
        }
        _;
    }

    /// Getters
    function getUint(bytes32 _key) external view returns (uint256) {
        require(_key[0].length != 0);

        return uIntStorage[_key];
    }

    function getString(bytes32 _key) external view returns (string memory) {
        require(_key[0].length != 0);

        return stringStorage[_key];
    }

    function getAddress(bytes32 _key) external view returns (address) {
        require(_key[0].length != 0);

        return addressStorage[_key];
    }

    function getBool(bytes32 _key) external view returns (bool) {
        require(_key[0].length != 0);

        return boolStorage[_key];
    }

    function getInt(bytes32 _key) external view returns (int256) {
        require(_key[0].length != 0);

        return intStorage[_key];
    }

    /// Setters
    function setUint(bytes32 _key, uint256 _value)
        external
        restrictVersionAccess
    {
        uIntStorage[_key] = _value;
    }

    function setString(bytes32 _key, string calldata _value)
        external
        restrictVersionAccess
    {
        stringStorage[_key] = _value;
    }

    function setAddress(bytes32 _key, address _value)
        external
        restrictVersionAccess
    {
        addressStorage[_key] = _value;
    }

    function setBool(bytes32 _key, bool _value) external restrictVersionAccess {
        boolStorage[_key] = _value;
    }

    function setInt(bytes32 _key, int256 _value)
        external
        restrictVersionAccess
    {
        intStorage[_key] = _value;
    }

    // Delete
    function deleteUint(bytes32 _key) external restrictVersionAccess {
        delete uIntStorage[_key];
    }

    function deleteString(bytes32 _key) external restrictVersionAccess {
        delete stringStorage[_key];
    }

    function deleteAddress(bytes32 _key) external restrictVersionAccess {
        delete addressStorage[_key];
    }

    function deleteBool(bytes32 _key) external restrictVersionAccess {
        delete boolStorage[_key];
    }

    function deleteInt(bytes32 _key) external restrictVersionAccess {
        delete intStorage[_key];
    }
}
