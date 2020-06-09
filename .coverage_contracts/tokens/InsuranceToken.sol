pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Pausable.sol";
import "../Manager.sol";
import "../lib/StorageHelper.sol";


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
function coverage_0xb5af4d5a(bytes32 c__0xb5af4d5a) public pure {}

  constructor(
    string memory _name,
    string memory _symbol,
    address _eternalStorageAddress,
    address _insurancePoolAddress
  ) public ERC20(_name, _symbol) Manager(_eternalStorageAddress) {coverage_0xb5af4d5a(0xa1a109f18a99ed3877f4b88424bdc56d54459ef79cb1e265a68df410506cadb2); /* function */ 

coverage_0xb5af4d5a(0x77480dc505b81a345d398552fed60f714d82cc24ab5cce3c6a4608d567d54c38); /* line */ 
    coverage_0xb5af4d5a(0x9ce2695ec406f2ff83003656c8db95b4f5f326cad8a0c72c45a8e4b2b45351f0); /* statement */ 
eternalStorage.setAddress(
      StorageHelper.formatAddress("contract.owner", address(this)),
      _insurancePoolAddress
    );
  }

  function thirdPartyApprove(
    address owner,
    address spender,
    uint256 amount
  )
    public
    onlyOwner(
      eternalStorage.getAddress(StorageHelper.formatAddress("contract.owner", address(this))),
      address(this)
    )
    returns (bool)
  {coverage_0xb5af4d5a(0xb519baa66ce7b72e072208649815f3f03f9d1452a7206052b8be52924b09915f); /* function */ 

coverage_0xb5af4d5a(0x7551f7dd60ef7362a82207dbe12cc7cea9260b1802a122347024e5b7661a70c4); /* line */ 
    coverage_0xb5af4d5a(0x68c8573cba255c590cf8e19e9dbf5d50177197188865d35450451922e4ee3205); /* statement */ 
_approve(owner, spender, amount);
coverage_0xb5af4d5a(0xd13c20d902f3c873572d0c95b0f89ae19a815d905f85475d54e17dc4b654a218); /* line */ 
    coverage_0xb5af4d5a(0x469720eb6dedcaf714fcf70e553d388925b2ce9fc61c59368d286eb4ffa5bf76); /* statement */ 
return true;
  }

  /**
   * @dev Creates `amount` new tokens for `to`.
   *
   * See {ERC20-_mint}.
   *
   * Requirements:
   *
   */
  function mint(address _to, uint256 _amount)
    public
    onlyOwner(
      eternalStorage.getAddress(StorageHelper.formatAddress("contract.owner", address(this))),
      address(this)
    )
  {coverage_0xb5af4d5a(0x421043988e886c1fd6a625cbc8791d23f2a92add233bf2ee008ff2df676181b2); /* function */ 

coverage_0xb5af4d5a(0xbe89577034cbed5dde0e4ff427611c2fe1ff6c58052e3d6e526089bc8fa120e3); /* line */ 
    coverage_0xb5af4d5a(0xb576bb253536bed863ddd7b332a76e20585706ad810edb6218d9c27537adefc9); /* statement */ 
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
  function pause()
    public
    onlyOwner(
      eternalStorage.getAddress(StorageHelper.formatAddress("contract.owner", address(this))),
      address(this)
    )
  {coverage_0xb5af4d5a(0x4ecb305ace1b44bb215fe24c68e913efbd759114ea7775f9a80b52fb6b7632df); /* function */ 

coverage_0xb5af4d5a(0x9540637d8f2b2363e21530c59b1d221a31028f11a0a4a8cfb202451cde4f0a91); /* line */ 
    coverage_0xb5af4d5a(0xa7ba270817f828031b6e077458bf16d1d5c3edc174fb1fe88ef746a3c46df365); /* statement */ 
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
  function unpause()
    public
    onlyOwner(
      eternalStorage.getAddress(StorageHelper.formatAddress("contract.owner", address(this))),
      address(this)
    )
  {coverage_0xb5af4d5a(0x8792e912f3252d91a9ff95061274ae461272e946eccdf7a32724a36863c11a61); /* function */ 

coverage_0xb5af4d5a(0x35fb0f90a5cc0664ceb07840ee62f8a0b24f007c296b33404c78f4dd1496e04b); /* line */ 
    coverage_0xb5af4d5a(0x00d074b976ce87d649f932ef7fbdd1875fb299323bbba170b251a7322ee2effe); /* statement */ 
_unpause();
  }

  // prettier-ignore
  function _beforeTokenTransfer(address _from, address _to, uint256 _amount)
        internal
        override(ERC20, ERC20Pausable)
    {coverage_0xb5af4d5a(0x026700aa547da3eaf74459b397a0ebc46d22a036a127ef0625b92cf4e9710e8a); /* function */ 

coverage_0xb5af4d5a(0xe6fd9471a1fb7374b7962b2f67c043df49ac07ea67355da880903fb27be587fa); /* line */ 
        coverage_0xb5af4d5a(0xc5bf003fb1e221a504fef0d168335b7862788a6543778d8e2ff2d3e776893406); /* statement */ 
super._beforeTokenTransfer(_from, _to, _amount);
    }
}
