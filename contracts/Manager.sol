pragma solidity 0.6.6;

// Imports
import "../node_modules/@openzeppelin/contracts/access/AccessControl.sol";
import "./Storage.sol";


contract Manager is AccessControl, Storage {
    /// Roles
    bytes32 public constant ROLE_OWNER = keccak256(
        abi.encodePacked("role.owner")
    );

    /// Constructor
    constructor() public {
        uint256 version = 1;
    }

    /// Roles
}
