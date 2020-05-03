pragma solidity ^0.6.4;


contract TokenStorage {
    bytes32 public constant claimsTokenStorage = keccak256(
        "CollateralTokenStorage.storage.location"
    );
    bytes32 public constant collateralTokenStorage = keccak256(
        "CollateralTokenStorage.storage.location"
    );

    struct tokenStorage {
        string name;
        string symbol;
        uint256 totalSupply;
        mapping(address => uint256) balance;
        mapping(address => mapping(address => uint256)) allowance;
    }

    /// load storage
    /// @param _tokenStorage claimsTokenStorage or collateralTokenStorage
    /// @return s storage tokenStorage
    function load(bytes32 _tokenStorage) internal pure returns (tokenStorage storage s) {
        bytes32 location = _tokenStorage

        assembly {
            s_slot := location
        }
    }
}
