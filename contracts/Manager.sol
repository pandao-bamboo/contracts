pragma solidity 0.6.6;

// Imports
import "../node_modules/@openzeppelin/contracts/access/AccessControl.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "./Storage.sol";


contract Manager is AccessControl, Ownable {
    /// Roles
    bytes32 public constant DAO_AGENT_ROLE = keccak256(
        abi.encodePacked("DAO_AGENT_ROLE")
    );

    /// Constructor
    constructor() public {
        // Setup roles
        _setupRole(DAO_AGENT_ROLE, _msgSender());
    }

    /// Modifiers
    modifier onlyAgent() {
        require(hasRole(DAO_AGENT_ROLE, _msgSender()));
        _;
    }
}
