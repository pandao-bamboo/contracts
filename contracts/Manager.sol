pragma solidity 0.6.6;

import "@nomiclabs/buidler/console.sol";
import "@pie-dao/proxy/contracts/PProxyPausable.sol";

// Imports
import "./EternalStorage.sol";
import "./lib/StorageHelper.sol";
import "./lib/StringHelper.sol";
import "./InsurancePool.sol";


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
        console.log(
            eternalStorage.getAddress(
                StorageHelper.formatAddress(
                    "contract.address",
                    _insuredTokenAddress
                )
            )
        );
        require(
            eternalStorage.getAddress(
                StorageHelper.formatAddress(
                    "contract.address",
                    _insuredTokenAddress
                )
            ) == address(0),
            "PanDAO: Insurance Pool already exists"
        );

        InsurancePool insurancePool = new InsurancePool(
            _insuredTokenAddress,
            _insuredTokenSymbol,
            _insureeFeeRate,
            _serviceFeeRate,
            _termLength
        );

        PProxyPausable proxy = new PProxyPausable();
        proxy.setImplementation(address(insurancePool));
        proxy.setPauzer(address(this));
        proxy.setProxyOwner(address(this));

        _saveInsurancePool(address(proxy), _insuredTokenSymbol);

        emit InsurancePoolCreated(
            "PanDAO: Insurance Pool Created",
            insurancePool
        );
        console.log("##### PanDAO: Insurance Pool Create: ", proxy);
    }

    function pauseInsurancePool() public onlyAgent() {}

    function approveInsuranceClaim() public onlyAgent() {}

    function denyInsuranceClaim() public onlyAgent() {}

    /// Internal

    /// External

    /// Private
    function _saveInsurancePool(
        address _insurancePoolAddress,
        string memory _insuredTokenSymbol
    ) private {
        eternalStorage.setAddress(
            StorageHelper.formatAddress(
                "contract.owner",
                _insurancePoolAddress
            ),
            address(this)
        );
        eternalStorage.setAddress(
            StorageHelper.formatAddress("contract.name", _insuredTokenSymbol),
            _insurancePoolAddress
        );
        eternalStorage.setAddress(
            StorageHelper.formatAddress(
                "contract.address",
                _insurancePoolAddress
            ),
            _insurancePoolAddress
        );

        insurancePools.push(_insurancePoolAddress);
        isInsurancePool[_insurancePoolAddress] = true;
    }
}
