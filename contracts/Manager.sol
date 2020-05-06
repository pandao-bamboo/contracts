pragma solidity 0.6.6;

// Imports
import "@openzeppelin/contracts/access/AccessControl.sol";

import "./interfaces/IStorage.sol";


contract Manager is AccessControl {
    // Storage contract
    IStorage eternalStorage = IStorage(0);

    /// Roles
    bytes32 public constant DAO_AGENT_ROLE = keccak256(
        abi.encodePacked("DAO_AGENT_ROLE")
    );

    /// Events
    event agentChanged(
        address previousAgent,
        address newAgent
    );

    /// Constructor
    constructor() public {
        // Setup roles
        _setupRole(DAO_AGENT_ROLE, _msgSender());

        // Save initial DAO Agent to Storage
        eternalStorage.setAddress(
            keccak256(abi.encodePacked("dao.agent")),
            _msgSender()
        );
    }

    /// Modifiers
    modifier onlyAgent() {
        require(hasRole(DAO_AGENT_ROLE, _msgSender()));
        _;
    }

    modifier onlyLatestContract(
        string memory _contractName,
        address _contractAddress
    ) {
        require(
            _contractAddress ==
                eternalStorage.getAddress(
                    keccak256(abi.encodePacked("contract.name", _contractName))
                ),
            "PanDAO: Invalid contract version"
        );
        _;
    }

    /// Public
    function changeAgent() public onlyAgent 
    /// Internal

    /// External

    /// Private
}
