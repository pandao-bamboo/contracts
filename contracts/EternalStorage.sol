pragma solidity 0.6.6;

import "./lib/StorageHelper.sol";


/// @author PanDAO - https://pandao.org
/// @title  Implementation of Eternal Storage(https://fravoll.github.io/solidity-patterns/eternal_storage.html)
/// @notice This contract is used for storing contract network data
/// @dev PanDAO network contracts can read/write from this contract
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

    //////////////////////////////
    /// @notice Modifiers
    /////////////////////////////

    /// @dev Restricts version access to the latest version of the contract making requests
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

    //////////////////////////////
    /// @notice Getter Functions
    /////////////////////////////

    /// @notice Get stored contract data in uint256 format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @return uint256 _value from storage _key location
    /// @dev restricted to latest PanDAO Networks contracts
    function getUint(bytes32 _key) external view returns (uint256) {
        return s.uIntStorage[_key];
    }

    /// @notice Get stored contract data in string format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @return string _value from storage _key location
    /// @dev restricted to latest PanDAO Networks contracts
    function getString(bytes32 _key) external view returns (string memory) {
        require(_key[0] != 0);

        return s.stringStorage[_key];
    }

    /// @notice Get stored contract data in address format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @return address _value from storage _key location
    /// @dev restricted to latest PanDAO Networks contracts
    function getAddress(bytes32 _key) external view returns (address) {
        return s.addressStorage[_key];
    }

    /// @notice Get stored contract data in bool format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @return bool _value from storage _key location
    /// @dev restricted to latest PanDAO Networks contracts
    function getBool(bytes32 _key) external view returns (bool) {
        return s.boolStorage[_key];
    }

    /// @notice Get stored contract data in int256 format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @return int256 _value from storage _key location
    /// @dev restricted to latest PanDAO Networks contracts
    function getInt(bytes32 _key) external view returns (int256) {
        return s.intStorage[_key];
    }

    /// @notice Get stored contract data in bytes format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @return bytes _value from storage _key location
    /// @dev restricted to latest PanDAO Networks contracts
    function getBytes(bytes32 _key) external view returns (bytes memory) {
        require(_key[0] != 0);

        return s.bytesStorage[_key];
    }

    //////////////////////////////
    /// @notice Setter Functions
    /////////////////////////////

    /// @notice Store contract data in uint256 format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @param _value uint256 value
    /// @dev restricted to latest PanDAO Networks contracts
    function setUint(bytes32 _key, uint256 _value)
        external
        restrictVersionAccess
    {
        s.uIntStorage[_key] = _value;
    }

    /// @notice Store contract data in string format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @param _value string value
    /// @dev restricted to latest PanDAO Networks contracts
    function setString(bytes32 _key, string calldata _value)
        external
        restrictVersionAccess
    {
        s.stringStorage[_key] = _value;
    }

    /// @notice Store contract data in address format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @param _value address value
    /// @dev restricted to latest PanDAO Networks contracts
    function setAddress(bytes32 _key, address _value)
        external
        restrictVersionAccess
    {
        s.addressStorage[_key] = _value;
    }

    /// @notice Store contract data in bool format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @param _value bool value
    /// @dev restricted to latest PanDAO Networks contracts
    function setBool(bytes32 _key, bool _value) external restrictVersionAccess {
        s.boolStorage[_key] = _value;
    }

    /// @notice Store contract data in int256 format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @param _value int256 value
    /// @dev restricted to latest PanDAO Networks contracts
    function setInt(bytes32 _key, int256 _value)
        external
        restrictVersionAccess
    {
        s.intStorage[_key] = _value;
    }

    /// @notice Store contract data in bytes format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @param _value bytes value
    /// @dev restricted to latest PanDAO Networks contracts
    function setBytes(bytes32 _key, bytes calldata _value)
        external
        restrictVersionAccess
    {
        s.bytesStorage[_key] = _value;
    }

    //////////////////////////////
    /// @notice Delete Functions
    /////////////////////////////

    /// @notice Delete stored contract data in bytes format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @dev restricted to latest PanDAO Networks contracts
    function deleteUint(bytes32 _key) external restrictVersionAccess {
        delete s.uIntStorage[_key];
    }

    /// @notice Delete stored contract data in string format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @dev restricted to latest PanDAO Networks contracts
    function deleteString(bytes32 _key) external restrictVersionAccess {
        delete s.stringStorage[_key];
    }

    /// @notice Delete stored contract data in address format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @dev restricted to latest PanDAO Networks contracts
    function deleteAddress(bytes32 _key) external restrictVersionAccess {
        delete s.addressStorage[_key];
    }

    /// @notice Delete stored contract data in bool format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @dev restricted to latest PanDAO Networks contracts
    function deleteBool(bytes32 _key) external restrictVersionAccess {
        delete s.boolStorage[_key];
    }

    /// @notice Delete stored contract data in int256 format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @dev restricted to latest PanDAO Networks contracts
    function deleteInt(bytes32 _key) external restrictVersionAccess {
        delete s.intStorage[_key];
    }

    /// @notice Delete stored contract data in bytes format
    /// @param _key bytes32 location should be keccak256 and abi.encodePacked
    /// @dev restricted to latest PanDAO Networks contracts
    function deleteBytes(bytes32 _key) external restrictVersionAccess {
        delete s.bytesStorage[_key];
    }
}
