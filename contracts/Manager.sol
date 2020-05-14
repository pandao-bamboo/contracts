pragma solidity 0.6.6;

import "@nomiclabs/buidler/console.sol";
import "@pie-dao/proxy/contracts/PProxyPausable.sol";

// Imports
import "./EternalStorage.sol";
import "./lib/StorageHelper.sol";
import "./lib/StringHelper.sol";
import "./InsurancePool.sol";


/// @author PanDAO - https://pandao.org
/// @title PanDAO Contract Network Manager
/// @notice This contract can be used by PanDAO to manage `InsurancePools` and resolve claims
/// @dev All functionality controlled by Aragon AGENT
contract Manager {
    address[] public insurancePools;
    EternalStorage internal eternalStorage;

    //////////////////////////////
    /// @notice Modifiers
    /////////////////////////////

    /// @dev ensures only Aragon Agent can call functions
    modifier onlyAgent() {
        require(
            eternalStorage.getAddress(StorageHelper.formatGet("dao.agent")) ==
                msg.sender,
            "PanDAO: UnAuthorized - Agent only"
        );
        _;
    }

    /// @dev ensures only the owning contract can call functions
    modifier onlyOwner(address _contractAddress) {
        require(
            eternalStorage.getAddress(
                StorageHelper.formatAddress("contract.owner", _contractAddress)
            ) == msg.sender,
            "PanDAO: UnAuthorized - Owner only"
        );
        _;
    }

    /// @dev ensures that only the latest contract version can call functions
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

    //////////////////////////////
    /// @notice Events
    /////////////////////////////

    event InsurancePoolCreated(
        address indexed insurancePoolAddress,
        string symbol
    );

    event InsurancePoolPaused(
        address indexed insurancePoolAddress,
        string symbol
    );

    //////////////////////////////
    /// @notice Public Functions
    /////////////////////////////

    /// @notice Create a new PanDAO Insurance Pool
    /// @dev This function can only be called by the Aragon Agent
    /// @param _insuredTokenAddress address of the digital asset we want to insure
    /// @param _insuredTokenSymbol string token symbol
    /// @param _insureeFeeRate uint256 fee the insuree pays
    /// @param _serviceFeeRate uint256 DAO fee
    /// @param _permiumPeriod uint256 how often premium is pulled from the wallet insuree's wallet
    function createInsurancePool(
        address _insuredTokenAddress,
        string memory _insuredTokenSymbol,
        uint256 _insureeFeeRate,
        uint256 _serviceFeeRate,
        uint256 _premiumPeriod
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
            _premiumPeriod
        );

        PProxyPausable proxy = new PProxyPausable();
        proxy.setImplementation(address(insurancePool));
        proxy.setPauzer(address(this));
        proxy.setProxyOwner(address(this));

        _saveInsurancePool(address(insurancePool), _insuredTokenSymbol);

        emit InsurancePoolCreated(address(insurancePool), _insuredTokenSymbol);
    }

    function pauseInsurancePool() public onlyAgent() {}

    function approveInsuranceClaim() public onlyAgent() {}

    function denyInsuranceClaim() public onlyAgent() {}

    function updateContractImplementation() public onlyAgent() {}

    //////////////////////////////
    /// @notice Private Functions
    /////////////////////////////

    /// @notice Saves a new insurance pool to Storage
    /// @param _insurancePoolAddress address the pool that was created
    /// @param _insuredTokenSymbol string insured token symbol
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
            StorageHelper.formatString("contract.name", _insuredTokenSymbol),
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
    }
}
