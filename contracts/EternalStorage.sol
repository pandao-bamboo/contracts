pragma solidity 0.6.6;

import "./lib/StorageHelper.sol";


// PanDAO implementation of Eternal Storage(https://fravoll.github.io/solidity-patterns/eternal_storage.html)
// Influenced by Rocket Pools implementation(https://github.com/rocket-pool/rocketpool/blob/master/contracts/RocketStorage.sol)
// https://pandao.org

contract EternalStorage {
    struct Storage {
        mapping(bytes32 => uint256) uIntStorage;
        mapping(bytes32 => string) stringStorage;
        mapping(bytes32 => address) addressStorage;
        mapping(bytes32 => bool) boolStorage;
        mapping(bytes32 => int256) intStorage;
        mapping(bytes32 => bytes) bytesStorage;
    }

    Storage internal s;

    modifier restrictVersionAccess() {
        if (
            s.boolStorage[StorageHelper.formatGet(
                "contract.storage.initialized"
            )] == true
        ) {
            // makes sure correct contract versions have access to storage
            require(
                s.addressStorage[StorageHelper.formatAddress(
                    "contract.address",
                    msg.sender
                )] != address(0x0)
            );
        }
        _;
    }

    /// Getters
    function getUint(bytes32 _key) external view returns (uint256) {
        return s.uIntStorage[_key];
    }

    function getString(bytes32 _key) external view returns (string memory) {
        require(_key[0] != 0);

        return s.stringStorage[_key];
    }

    function getAddress(bytes32 _key) external view returns (address) {
        return s.addressStorage[_key];
    }

    function getBool(bytes32 _key) external view returns (bool) {
        return s.boolStorage[_key];
    }

    function getInt(bytes32 _key) external view returns (int256) {
        return s.intStorage[_key];
    }

    function getBytes(bytes32 _key) external view returns (bytes memory) {
        return s.bytesStorage[_key];
    }

    /// Setters
    function setUint(bytes32 _key, uint256 _value)
        external
        restrictVersionAccess
    {
        s.uIntStorage[_key] = _value;
    }

    function setString(bytes32 _key, string calldata _value)
        external
        restrictVersionAccess
    {
        s.stringStorage[_key] = _value;
    }

    function setAddress(bytes32 _key, address _value)
        external
        restrictVersionAccess
    {
        s.addressStorage[_key] = _value;
    }

    function setBool(bytes32 _key, bool _value) external restrictVersionAccess {
        s.boolStorage[_key] = _value;
    }

    function setInt(bytes32 _key, int256 _value)
        external
        restrictVersionAccess
    {
        s.intStorage[_key] = _value;
    }

    function setBytes(bytes32 _key, bytes calldata _value)
        external
        restrictVersionAccess
    {
        s.bytesStorage[_key] = _value;
    }

    // Delete
    function deleteUint(bytes32 _key) external restrictVersionAccess {
        delete s.uIntStorage[_key];
    }

    function deleteString(bytes32 _key) external restrictVersionAccess {
        delete s.stringStorage[_key];
    }

    function deleteAddress(bytes32 _key) external restrictVersionAccess {
        delete s.addressStorage[_key];
    }

    function deleteBool(bytes32 _key) external restrictVersionAccess {
        delete s.boolStorage[_key];
    }

    function deleteInt(bytes32 _key) external restrictVersionAccess {
        delete s.intStorage[_key];
    }

    function deleteBytes(bytes32 _key) external restrictVersionAccess {
        delete s.bytesStorage[_key];
    }
}
