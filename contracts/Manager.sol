pragma solidity 0.6.6;

import "@nomiclabs/buidler/console.sol";
import "@pie-dao/proxy/contracts/PProxyPausable.sol";

// Imports
import "./EternalStorage.sol";
import "./lib/StorageHelper.sol";
import "./lib/StringHelper.sol";
import "./factories/InsurancePoolFactory.sol";


contract Manager {
    // Eternal Storage Contract
    EternalStorage public eternalStorage;
    address[] public insurancePools;
    mapping(address => bool) public isInsurancePool;

    /// Modifiers
    modifier onlyAgent() {
        require(
            eternalStorage.getAddress(StorageHelper.formatGet("dao.agent")) ==
                msg.sender,
            "PanDAO: UnAuthorized - Agent only"
        );
        _;
    }

    modifier onlyOwner(address _contractAddress) {
        require(
            eternalStorage.getAddress(
                StorageHelper.formatAddress("contract.owner", _contractAddress)
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
                    StorageHelper.formatString("contract.name", _contractName)
                ),
            "PanDAO: Invalid contract version"
        );
        _;
    }

    /// Events
    event InsurancePoolCreated(
        address indexed insurancePoolAddress,
        string name,
        string symbol
    );

    event InsurancePoolPaused(
        address indexed insurancePoolAddress,
        string name,
        string symbol
    );

    /// Public
    function createInsurancePool(
        address _insuredTokenAddress,
        string memory _insuredTokenSymbol,
        uint256 _insureeFeeRate,
        uint256 _serviceFeeRate,
        uint256 _termLength
    ) public onlyAgent() {
        InsurancePool insurancePool = new InsurancePool(
            _insuredTokenAddress,
            _insuredTokenSymbol,
            _insureeFeeRate,
            _serviceFeeRate,
            _termLength
        );

        _saveInsurancePool(insurancePool.address, _insuredTokenSymbol);

        emit InsurancePoolCreated(
            "PanDAO: Insurance Pool Created",
            insurancePool
        );
        console.log("##### PanDAO: Insurance Pool Create: ", insurancePool.address);
    }

    function pauseInsurancePool() public onlyAgent() {}

    function approveInsuranceClaim() public onlyAgent() {}

    function denyInsuranceClaim() public onlyAgent() {}

    /// Internal

    /// External

    /// Private
    function _saveInsurancePool(address _insurancePoolAddress, string _insuredTokenSymbol) private {
        eternalStorage.setAddress(
            formatAddress("contract.owner", insurancePool.address),
            address(this)
        );
        eternalStorage.setAddress(
            formatAddress("contract.name", _insuredTokenSymbol),
            insurancePool.address
        );
        eternalStorage.setString(
            formatAddress("contract.address", insurancePool.address),
            _insuredTokenSymbol
        );
        insurancePools.push(_insurancePoolAddress);
        isInsurancePool[_insurancePoolAddress] = true;
}   
