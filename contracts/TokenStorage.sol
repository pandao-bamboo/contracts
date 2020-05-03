pragma solidity ^0.6.4;


contract TokenStorage {
    bytes32 public constant COLLATERAL_TOKEN_STORAGE = keccak256(
        "CollateralTokenStorage.storage.location"
    );
    bytes32 public constant CLAIMS_TOKEN_STORAGE = keccak256(
        "ClaimsTokenStorage.storage.location"
    );

    struct tokenStorage {
        string name;
        string symbol;
        uint256 totalSupply;
        mapping(address => uint256) balance;
        mapping(address => mapping(address => uint256)) allowance;
    }

    /// @notice Loads the collateral token pool storage
    /// @param  _storageLocation TokenStorage.STORAGE_CONSTANT
    /// @return s tokenStorage
    function load(bytes32 _storageLocation)
        internal
        pure
        returns (tokenStorage storage s)
    {
        bytes32 location = _storageLocation;

        assembly {
            s_slot := location
        }
    }
}
