pragma solidity ^0.6.0;


library EternalStorageHelper {
    function formatString(string memory _storageLocation, string memory _value)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_storageLocation, _value));
    }

    function formatAddress(string memory _storageLocation, address _value)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_storageLocation, _value));
    }

    function formatGet(string memory _location)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_location));
    }
}
