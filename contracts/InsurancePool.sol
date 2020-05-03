pragma solidity ^0.6.4;

import "../node_modules/@nomiclabs/buidler/console.sol";
import "../node_modules/@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";


contract InsurancePool is Ownable {
    bytes32 public constant insurancePoolStorage = keccak256(
        "InsurancePool.storage.location"
    );
    struct insurancePool {
        address insuredTokenAddress;
        uint256 insureeFeeRate;
        uint256 serviceFeeRate;
        uint256 claimPenalty;
    }

    // PUBLIC
    function create(
        address _tokenAddressToInsure,
        uint256 _insureeFeeRate,
        uint256 _serviceFeeRate,
        uint256 _claimPenalty
    ) external {
        insurancePool storage ip = load();

        require(
            address(ip.insuredTokenAddress) == address(_tokenAddressToInsure),
            "InsurancePool.create: Insurance Pool already exists."
        );
        require(
            _tokenAddressToInsure != address(0),
            "InsurancePool.create: _tokenAddressToInsure can not be 0x00"
        );

        ip.insuredTokenAddress = _tokenAddressToInsure;
        ip.insureeFeeRate = _insureeFeeRate;
        ip.serviceFeeRate = _serviceFeeRate;
        ip.claimPenalty = _claimPenalty;
    }

    // load insurance pool storage
    function load() internal pure returns (insurancePool storage s) {
        bytes32 location = insurancePoolStorage;

        assembly {
            s_slot := location
        }
    }
}
