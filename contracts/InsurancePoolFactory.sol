pragma solidity ^0.6.4;

// FOR DEVELOPMENT
import "../node_modules/@nomiclabs/buidler/console.sol";

// IMPORTS
import "../node_modules/@pie-dao/proxy/contracts/PProxyPausable.sol";
import "../node_modules/@openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol";


contract InsurancePoolFactory is Ownable {
    // VARIABLES
    address[] public insurancePools;

    // EVENTS
    event InsurancePoolCreated(
        address indexed insurancePoolAddress,
        string name,
        string symbol
    );

    // PUBLIC

    // PRIVATE
}
