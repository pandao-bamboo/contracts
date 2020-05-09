pragma solidity ^0.6.0;


library EternalStorageHelper {
    // Setter Format
    function formatAddress(string memory _storageLocation, address _value)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_storageLocation, _value));
    }

    function formatBool(string memory _storageLocation, bool _value)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_storageLocation, _value));
    }

    function formatInt(string memory _storageLocation, int256 _value)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_storageLocation, _value));
    }

    function formatString(string memory _storageLocation, string memory _value)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_storageLocation, _value));
    }

    function formatUint(string memory _storageLocation, uint256 _value)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_storageLocation, _value));
    }

    // Getter Format
    function formatGet(string memory _location)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_location));
    }
}
