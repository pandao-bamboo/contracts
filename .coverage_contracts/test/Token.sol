// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity 0.6.6;

// We import this library to be able to use console.log
import "@nomiclabs/buidler/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


// This is the main building block for smart contracts.
contract Token is ERC20 {
function coverage_0x71bd9d8c(bytes32 c__0x71bd9d8c) public pure {}

  // The fixed amount of tokens stored in an unsigned integer type variable.
  //prettier-ignore
  // An address type variable is used to store ethereum accounts.
  address public owner;

  /**
   * Contract initialization.
   *
   * The `constructor` is executed only once when the contract is created.
   * The `public` modifier makes a function callable from outside the contract.
   */
  constructor() public ERC20("Test BTC++", "BTC++") {coverage_0x71bd9d8c(0x9fb3324cb097e0b8e6be90d26db6d14d693f304c83049270d50dc0107ba6bffa); /* function */ 

    // The totalSupply is assigned to transaction sender, which is the account
    // that is deploying the contract.
coverage_0x71bd9d8c(0x598b853d0f06e3531ee1c346336b68c213ff1b64b98cb1a8b8c0c303a69da884); /* line */ 
    coverage_0x71bd9d8c(0x364bbc4000877c1501c4d017926b3bc090c4eb1074f558a751d18386c1df9153); /* statement */ 
owner = msg.sender;

coverage_0x71bd9d8c(0x8f068b97acfe8c5282d3222d912b1b12155e849c0a79110be5804e561ee256f4); /* line */ 
    coverage_0x71bd9d8c(0xf93ee55877141ca969db7e1cfb540b4bae1537053f69723e65d16b42509dfed6); /* statement */ 
_mint(msg.sender, 100000);
  }
}
