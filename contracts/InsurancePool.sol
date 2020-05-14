pragma solidity 0.6.6;

import "./factories/TokenFactory.sol";
import "./EternalStorage.sol";
import "./lib/StorageHelper.sol";


/// @author PanDAO - https://pandao.org
/// @title PanDAO Insurance Pool
/// @notice PanDAO Insurance Pool is the implementation contract which allows a user to add/remove collateral, claim rewards, and create claims
contract InsurancePool {
    struct IPool {
        address claimTokenAddress;
        address collateralTokenAddress;
        address insuredTokenAddress;
        string insuredTokenSymbol;
        uint256 insureeFeeRate; // the rate the buyer payers for insurance
        uint256 serviceFeeRate; // dao (Note: insureeFeeRate - serviceFeeRate = insurerReward)
        uint256 premiumPeriod; // (n) Blocks
    }

    IPool internal iPool;
    EternalStorage internal eternalStorage;

    constructor(
        address _insuredTokenAddress,
        string memory _insuredTokenSymbol,
        uint256 _insureeFeeRate,
        uint256 _serviceFeeRate,
        uint256 _premiumPeriod
    ) public {
        insuredTokenAddress = _insuredTokenAddress;
        insuredTokenSymbol = _insuredTokenSymbol;
        insureeFeeRate = _insureeFeeRate;
        serviceFeeRate = _serviceFeeRate;
        premiumPeriod = _premiumPeriod;
    }

    // Public

    function addCollateralForMatching() public {}

    function buyInsurance() public {}

    function claimRewards() public {}

    function createInsuranceClaim() public {}

    function removeCollateralFromMatching() public {}

    // Private
}
