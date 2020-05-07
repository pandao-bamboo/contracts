pragma solidity 0.6.6;

// Imports
import "./EternalStorage.sol";
import "@nomiclabs/buidler/console.sol";


contract Manager {
    // Eternal Storage Contract
    EternalStorage public eternalStorage;

    /// Constructor
    constructor() public {
        // Save initial DAO Agent to Storage
        // eternalStorage.setAddress(
        //     keccak256(abi.encodePacked("dao.agent")),
        //     msg.sender
        // );
    }

    /// Modifiers
    modifier onlyAgent() {
        require(
            eternalStorage.getAddress(
                keccak256(abi.encodePacked("dao.agent"))
            ) == msg.sender,
            "PanDAO: UnAuthorized - Agent only"
        );
        _;
    }

    modifier onlyOwner(address _contractAddress) {
        require(
            eternalStorage.getAddress(
                keccak256(abi.encodePacked("contract.owner", _contractAddress))
            ) == msg.sender,
            "PanDAO: UnAuthorized - Owner only"
        );
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

    /// Internal

    /// External

    /// Private
}
