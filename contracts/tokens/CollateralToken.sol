pragma solidity ^0.6.4;

// Utilities
import "../../node_modules/@nomiclabs/buidler/console.sol";

// Inheritance
import "../../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../../node_modules/@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "../../node_modules/@openzeppelin/contracts/access/Ownable.sol";


contract CollateralToken is ERC20, Ownable {}
