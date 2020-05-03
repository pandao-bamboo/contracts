pragma solidity ^0.6.4;

// Utilities
import "../../node_modules/@nomiclabs/buidler/console.sol";

// Inheritance
import "../../node_modules/@pie-dao/proxy/contracts/PProxyPausable.sol";
import "../../node_modules/@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";


contract InsurancePoolFactory is Ownable {
    // Variables
    address[] public insurancePools;

    // Events
    event InsurancePoolCreated(
        address indexed insurancePoolAddress,
        string name,
        string symbol
    );

    // Public

    // Private
}
