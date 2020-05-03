pragma solidity ^0.6.4;


library StringHelper {
    function concat(bytes memory a, bytes memory b)
        internal
        pure
        returns (bytes memory)
    {
        return abi.encodePacked(a, b);
    }
}
