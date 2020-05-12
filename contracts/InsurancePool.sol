pragma solidity 0.6.6;

import "./factories/TokenFactory.sol";


contract InsurancePool {
    address claimTokenAddress;
    address collateralTokenAddress;
    address insuredTokenAddress;
    string insuredTokenSymbol;
    uint256 insureeFeeRate; // the rate the buyer payers for insurance
    uint256 serviceFeeRate; // dao (Note: insureeFeeRate - serviceFeeRate = insurerReward)
    uint256 termLength; // length in days

    constructor(
        address _insuredTokenAddress,
        string memory _insuredTokenSymbol,
        uint256 _insureeFeeRate,
        uint256 _serviceFeeRate,
        uint256 _termLength
    ) public {
        insuredTokenAddress = _insuredTokenAddress;
        insuredTokenSymbol = _insuredTokenSymbol;
        insureeFeeRate = _insureeFeeRate;
        serviceFeeRate = _serviceFeeRate;
        termLength = _termLength;
    }

    // Public

    function addCollateralForMatching() public {}

    function buyInsurance() public {}

    function claimRewards() public {}

    function createInsuranceClaim() public {}

    function removeCollateralFromMatching() public {}

    // Private
}
