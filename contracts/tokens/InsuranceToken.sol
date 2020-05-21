pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Pausable.sol";
import "../Manager.sol";


/**
 * @dev {ERC20} token, including:
 *
 *  - ability for holders to burn (destroy) their tokens
 *  - a minter role that allows for token minting (creation)
 *  - a pauser role that allows to stop all token transfers
 *
 * This contract uses {AccessControl} to lock permissioned functions using the
 * different roles - head to its documentation for details.
 *
 * The account that deploys the contract will be granted the minter and pauser
 * roles, as well as the default admin role, which will let it grant both minter
 * and pauser roles to aother accounts
 */
contract InsuranceToken is Context, ERC20Burnable, ERC20Pausable, Manager {
    constructor(
        string memory _name,
        string memory _symbol,
        address _eternalStorageAddress
    ) public ERC20(_name, _symbol) Manager(_eternalStorageAddress) {}

    /**
     * @dev Creates `amount` new tokens for `to`.
     *
     * See {ERC20-_mint}.
     *
     * Requirements:
     *
     */
    function mint(address _to, uint256 _amount) public onlyOwner(msg.sender) {
        _mint(_to, _amount);
    }

    /**
     * @dev Pauses all token transfers.
     *
     * See {ERC20Pausable} and {Pausable-_pause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function pause() public onlyOwner(msg.sender) {
        _pause();
    }

    /**
     * @dev Unpauses all token transfers.
     *
     * See {ERC20Pausable} and {Pausable-_unpause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function unpause() public onlyOwner(msg.sender) {
        _unpause();
    }

    // prettier-ignore
    function _beforeTokenTransfer(address _from, address _to, uint256 _amount)
        internal
        override(ERC20, ERC20Pausable)
    {
        super._beforeTokenTransfer(_from, _to, _amount);
    }
}
