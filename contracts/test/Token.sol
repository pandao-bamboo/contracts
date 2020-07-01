// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity 0.6.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// This is the main building block for smart contracts.
contract Token is ERC20 {
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
  constructor() public ERC20("Test BTC++", "BTC++") {
    // The totalSupply is assigned to transaction sender, which is the account
    // that is deploying the contract.
    owner = msg.sender;

    _mint(msg.sender, 100000);
  }
}
