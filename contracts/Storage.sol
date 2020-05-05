pragma solidity 0.6.6;


/// @title Inspried by Rocketpool Storage
/// @author Original Author: David Rugendyke / Updated For PanDAO By: Travis Mathis

contract Storage {
    /// Types
    mapping(bytes32 => uint256) private uIntStorage;
    mapping(bytes32 => string) private stringStorage;
    mapping(bytes32 => address) private addressStorage;
    mapping(bytes32 => bytes) private bytesStorage;
    mapping(bytes32 => bool) private boolStorage;
    mapping(bytes32 => int256) private intStorage;
    mapping(bytes32 => bytes32) private bytes32Storage;

    /// Modifier

    /// @dev Only allow access from the latest version of a contract in the PanDAO Network

    modifier onlyLatestPanDAOContract() {
        // The owner and other contracts are only allowed to set the storage upon deployment to register the initial contracts/settings, afterwards their direct access is disabled
        if (
            boolStorage[keccak256(
                abi.encodePacked("contract.storage.initialised")
            )] == true
        ) {
            // Make sure the access is permitted to only our contracts
            require(
                addressStorage[keccak256(
                    abi.encodePacked("contract.address", msg.sender)
                )] != address(0x0),
                "PanDAO: Unauthorized"
            );
        }
        _;
    }

    /// @dev constructor
    constructor() public {
        // Set the main owner upon deployment
        boolStorage[keccak256(
            abi.encodePacked("access.role", "owner", msg.sender)
        )] = true;
    }

    /// Getters

    /// @param _key The key for the record
    function getAddress(bytes32 _key) external view returns (address) {
        return addressStorage[_key];
    }

    /// @param _key The key for the record
    function getUint(bytes32 _key) external view returns (uint256) {
        return uIntStorage[_key];
    }

    /// @param _key The key for the record
    function getString(bytes32 _key) external view returns (string memory) {
        return stringStorage[_key];
    }

    /// @param _key The key for the record
    function getBytes(bytes32 _key) external view returns (bytes memory) {
        return bytesStorage[_key];
    }

    /// @param _key The key for the record
    function getBool(bytes32 _key) external view returns (bool) {
        return boolStorage[_key];
    }

    /// @param _key The key for the record
    function getInt(bytes32 _key) external view returns (int256) {
        return intStorage[_key];
    }

    /// @param _key The key for the record
    function getBytes32(bytes32 _key) external view returns (bytes32) {
        return bytes32Storage[_key];
    }

    /// Setters

    /// @param _key The key for the record
    function setAddress(bytes32 _key, address _value)
        external
        onlyLatestPanDAOContract
    {
        addressStorage[_key] = _value;
    }

    /// @param _key The key for the record
    function setUint(bytes32 _key, uint256 _value)
        external
        onlyLatestPanDAOContract
    {
        uIntStorage[_key] = _value;
    }

    /// @param _key The key for the record
    function setString(bytes32 _key, string memory _value)
        public
        onlyLatestPanDAOContract
    {
        stringStorage[_key] = _value;
    }

    /// @param _key The key for the record
    function setBytes(bytes32 _key, bytes memory _value)
        public
        onlyLatestPanDAOContract
    {
        bytesStorage[_key] = _value;
    }

    /// @param _key The key for the record
    function setBool(bytes32 _key, bool _value)
        external
        onlyLatestPanDAOContract
    {
        boolStorage[_key] = _value;
    }

    /// @param _key The key for the record
    function setInt(bytes32 _key, int256 _value)
        external
        onlyLatestPanDAOContract
    {
        intStorage[_key] = _value;
    }

    /// @param _key The key for the record
    function setBytes32(bytes32 _key, bytes32 _value)
        external
        onlyLatestPanDAOContract
    {
        bytes32Storage[_key] = _value;
    }

    /**** Delete Methods ***********/

    /// @param _key The key for the record
    function deleteAddress(bytes32 _key) external onlyLatestPanDAOContract {
        delete addressStorage[_key];
    }

    /// @param _key The key for the record
    function deleteUint(bytes32 _key) external onlyLatestPanDAOContract {
        delete uIntStorage[_key];
    }

    /// @param _key The key for the record
    function deleteString(bytes32 _key) external onlyLatestPanDAOContract {
        delete stringStorage[_key];
    }

    /// @param _key The key for the record
    function deleteBytes(bytes32 _key) external onlyLatestPanDAOContract {
        delete bytesStorage[_key];
    }

    /// @param _key The key for the record
    function deleteBool(bytes32 _key) external onlyLatestPanDAOContract {
        delete boolStorage[_key];
    }

    /// @param _key The key for the record
    function deleteInt(bytes32 _key) external onlyLatestPanDAOContract {
        delete intStorage[_key];
    }

    /// @param _key The key for the record
    function deleteBytes32(bytes32 _key) external onlyLatestPanDAOContract {
        delete bytes32Storage[_key];
    }
}
