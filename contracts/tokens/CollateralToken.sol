pragma solidity ^0.6.4;

// Utilities
import "../../node_modules/@nomiclabs/buidler/console.sol";

// Inheritance
import "../../node_modules/@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20.sol";
import "../../node_modules/@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Burnable.sol";
import "../../node_modules/@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Mintable.sol";
import "../../node_modules/@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";

// PanDAO
import "../TokenStorage.sol";


contract CollateralToken is
    ERC20Detailed,
    ERC20Burnable,
    ERC20Mintable,
    Ownable
{
    constructor(string _name, string _symbol, uint8 _decimals)
        public
        ERC20Detailed(_name, _symbol, _decimals)
    {
        owner = msg.sender;
    }
}
