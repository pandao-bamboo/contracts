pragma solidity 0.6.6;

import "@nomiclabs/buidler/console.sol";

// Imports
import "./EternalStorage.sol";
import "./lib/StorageHelper.sol";


contract Manager {
    // Eternal Storage Contract
    EternalStorage public eternalStorage;

    /// Constructor

    /// Modifiers
    modifier onlyAgent() {
        require(
            eternalStorage.getAddress(formatGet("dao.agent")) == msg.sender,
            "PanDAO: UnAuthorized - Agent only"
        );
        _;
    }

    modifier onlyOwner(address _contractAddress) {
        require(
            eternalStorage.getAddress(
                formatAddress("contract.owner", _contractAddress)
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
                    formatString("contract.name", _contractName)
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
