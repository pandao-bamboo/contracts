pragma solidity 0.6.6;

import "@nomiclabs/buidler/console.sol";

import "./EternalStorage.sol";
import "./lib/StorageHelper.sol";
import "./lib/StringHelper.sol";
import "./factories/TokenFactory.sol";
import "./tokens/InsuranceToken.sol";


/// @author PanDAO - https://pandao.org
/// @title PanDAO Insurance Pool
/// @notice PanDAO Insurance Pool is the implementation contract which allows a user to add/remove collateral, claim rewards, and create claims
contract InsurancePool {
function coverage_0x1465c448(bytes32 c__0x1465c448) public pure {}

  /// @dev Gives access to PanDAO Eternal Storage
  EternalStorage internal eternalStorage;

  event InsurancePoolCreated(
    address insurancePoolAddress,
    address insuredTokenAddress,
    string insuredTokenSymbol,
    uint256 insureeFeeRate,
    uint256 premiumPeriod,
    uint256 serviceFeeRate
  );

  /// @notice Stores IPool information on init
  /// @param _insurableTokenAddress the digital asset to be insured
  /// @param _insurableTokenSymbol the symbol for the digital asset to be insured
  /// @param _insureeFeeRate The rate the insuree pays
  /// @param _serviceFeeRate The DAO's cut from the insuree premium
  /// @param _premiumPeriod number of blocks between premium payments
  /// @param _eternalStorageAddress address contract address of eternalStorage
  /// @dev _insureeFeeRate - _serviceFeeRate = insurerFee
  constructor(
    address _insurableTokenAddress,
    string memory _insurableTokenSymbol,
    uint256 _insureeFeeRate,
    uint256 _serviceFeeRate,
    uint256 _premiumPeriod,
    address _eternalStorageAddress
  ) public {coverage_0x1465c448(0x5f0706566c84e8aef72b2badd82b05956f9ce1b1399e7670b9f6ef93e5a85b5c); /* function */ 

coverage_0x1465c448(0x90583f1e7fd735c02cc2050f770de905481be918de1ea90301eda5f5c29049e9); /* line */ 
    coverage_0x1465c448(0x0a2a67fee646e9f25f31ed60db80ea251dd526359ddd0d4c08cdce1d3b805dad); /* statement */ 
eternalStorage = EternalStorage(_eternalStorageAddress);

coverage_0x1465c448(0xcf27de1d86a448a5aa674445fc5553c64ae2022b5ea351f565bf3a1f39062682); /* line */ 
    coverage_0x1465c448(0xa503733257540e68188d9f16aaf8d3a30ec564087e9027240547a8c203c27221); /* statement */ 
address insurableToken = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.insuredToken", _insurableTokenAddress)
    );

    /// @dev Require insurable token to be unique
coverage_0x1465c448(0x09fcd78b333fde1da74a1d51d1bfc2d5d19f5e231cc06893ec683c55189826f8); /* line */ 
    coverage_0x1465c448(0xcfdd3b233ffc4a1c00b4895bca514351ee46fa36cb75afde69194255fc9041eb); /* assertPre */ 
coverage_0x1465c448(0x03d959d1fcd273c933ffbbfaf820f58eb07f7a8ae6ac88bd404b998f3275c66a); /* statement */ 
require(insurableToken == address(0), "PanDAO: Insurance Pool already exists for that asset");coverage_0x1465c448(0xe95410c281d0170d9cb51a91484e94c6fe273012450a93fb1840d94b5ce2f4e6); /* assertPost */ 


coverage_0x1465c448(0x166f3abc519ee2d1abf309fabdcdc75709d36cf6544f948be2925b9da0c53f4f); /* line */ 
    coverage_0x1465c448(0xeeb72319e5ad6537b0a3fc193ac3cbb6407baa8b1c9801d28c20321c3288850b); /* statement */ 
bool poolInitialized = StorageHelper.initializeInsurancePool(
      eternalStorage,
      address(this),
      eternalStorage.getAddress(StorageHelper.formatString("contract.name", "Manager")),
      _insurableTokenSymbol
    );

coverage_0x1465c448(0xfd5ab1290b8b6dede3387784892f327ada3262a6789f5627af0703d204bf45e9); /* line */ 
    coverage_0x1465c448(0x8b2f1e77c0e0903fa16daa636afa1eaf3171b5fa4d416111eaf14b343d0a654b); /* assertPre */ 
coverage_0x1465c448(0x062f811afb7dbefb6f18de31451c981667d08e511b59f1753da3491581409201); /* statement */ 
require(poolInitialized == true, "PanDAO: Failed to initialized Insurance Pool");coverage_0x1465c448(0x7bc5ab106634133430a3962eb99065359073e01e1b7c9290f2ed579b9def0fd4); /* assertPost */ 


    /// @dev Create collateral and claims tokens for pool
coverage_0x1465c448(0xd0a66d067be0701753fb70df7e6ab7839dd65dce5d6df493d7d09232fc36faae); /* line */ 
    coverage_0x1465c448(0xc58a8d64e5b9cdf365fdc76789a0372f8ce1ace30e6dc90af273bdaf52cbdbc5); /* statement */ 
TokenFactory tokenFactory = TokenFactory(
      eternalStorage.getAddress(StorageHelper.formatString("contract.name", "TokenFactory"))
    );

coverage_0x1465c448(0xb6e36f71fe709b891aa8015ae12ecbc02430182ca356ac2f8074e53f45f8d593); /* line */ 
    coverage_0x1465c448(0xc29c0080ef0df2ff66ed1bd8b7d8e4792e7be20537848ce6f77a143d6bd595d8); /* statement */ 
address[] memory tokens = tokenFactory.createTokens(_insurableTokenSymbol, address(this));

coverage_0x1465c448(0x3f8f4de53459d4795b48f4aab7aea9ecd9b395440489dafa62d8871b8f1cabea); /* line */ 
    coverage_0x1465c448(0x1882320d2b718e4ed22dcb375bb0698bc0805df2d7c697e9ea99c0c9c36e483f); /* statement */ 
StorageHelper.saveInsurancePool(
      eternalStorage,
      address(this),
      tokens[0],
      tokens[1],
      _insurableTokenAddress,
      _insurableTokenSymbol,
      _insureeFeeRate,
      _serviceFeeRate,
      _premiumPeriod
    );

coverage_0x1465c448(0x6d8f84d858469d325292688ac86227be530bdae0e9c5d49bc136e31a689f18b3); /* line */ 
    coverage_0x1465c448(0xfd49184f68cea7c5d474b75e499359ea2ab2a55e2e2050f09baae9829eac4c25); /* statement */ 
emit InsurancePoolCreated(
      address(this),
      _insurableTokenAddress,
      _insurableTokenSymbol,
      _insureeFeeRate,
      _premiumPeriod,
      _serviceFeeRate
    );
  }

  //////////////////////////////
  /// @notice Public
  /////////////////////////////

  function addCollateralForMatching(address _insurerAddress, uint256 _amount) public payable {coverage_0x1465c448(0x630fe07adcc1f631f69628c6927d7133c4ef88770669063107dbf072f1b1c3d6); /* function */ 

coverage_0x1465c448(0x40662233c2e34daade5cdb14791be5fc16e51bd8ab8aaf2807010e46fa32b7f3); /* line */ 
    coverage_0x1465c448(0x86a67e5942d196c73c1f341757930c31ece3548f44584e4e459688eb7c39bea1); /* statement */ 
address collateralTokenAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.collateralToken", address(this))
    );

coverage_0x1465c448(0x3af1f59da27d04a9d6480e42189ed446e9272cb587e7780daf9ca3fa3bde191f); /* line */ 
    coverage_0x1465c448(0xf3690bb8230b8fd4362301bbba64d836ac6873b129672d65986ca784e0d57510); /* statement */ 
InsuranceToken collateralToken = InsuranceToken(collateralTokenAddress);

coverage_0x1465c448(0xa5ebc30f4824eece68583df00e3bf15a0c6ff91d290429d0a570cdcb8202d417); /* line */ 
    coverage_0x1465c448(0x0a381688f691ec5d2173964b62508814702a501a0a836c5b13e250238364ee9c); /* statement */ 
address insuredTokenAddress = eternalStorage.getAddress(
      StorageHelper.formatAddress("insurance.pool.insuredToken", address(this))
    );

coverage_0x1465c448(0x594ad122343bc70053e794e8d51fc276f8d334c83aedf4c94d283bca5cb4b2f3); /* line */ 
    coverage_0x1465c448(0x58b2d8bae673ef49db55aef873f693eb3f3722662203162a736079ec8662036b); /* statement */ 
ERC20 insuredToken = ERC20(insuredTokenAddress);

coverage_0x1465c448(0x84ff3a950485d7c62c63b77438bdec8e7ac28ca3d79a35a9045f1fbf0a8c2e5f); /* line */ 
    coverage_0x1465c448(0xd91164627f4618339175c50ce1bbd42a096cf746b1336d0b57c0b8717e1001da); /* statement */ 
insuredToken.transferFrom(_insurerAddress, address(this), _amount);

    /// @dev Mint 1:1 representation of collateral stored in contract
coverage_0x1465c448(0xe535a5a6c35965feeb34ee771402d8ab097f655d83ca4cca4abbc842fa1cfccd); /* line */ 
    coverage_0x1465c448(0x171d9b47e94fc2f853e2241fca10909eefe63aecce6da7c18276a30114a7deb8); /* statement */ 
collateralToken.mint(_insurerAddress, _amount);

    /// @dev Approve the insurance pool to transfer the collateral representation tokens back
coverage_0x1465c448(0xcd72ceb65d43dd58e3141300da2f905eec42d95764f8f133735c23bc88cb8a96); /* line */ 
    coverage_0x1465c448(0x409c0762e8249accd10403209ba586903583722b0eb5043f788a372c805b0d24); /* statement */ 
collateralToken.thirdPartyApprove(_insurerAddress, address(this), _amount);

coverage_0x1465c448(0x831b70c0b80465b2ad7dc99257f86f28ac9878e463581c974db86dda48148608); /* line */ 
    coverage_0x1465c448(0x79723d3d4756c5adb2509215bdf29c1eeabba439b58cd536006c2de31023f2dc); /* statement */ 
eternalStorage.setInsurancePoolQueuePosition(insuredTokenAddress, _insurerAddress, _amount);
  }

  function buyInsurance() public {coverage_0x1465c448(0x0766a1128aeadd9e96d83decca68b36e633a68adf8af7f62ed6359c8fc16b4a8); /* function */ 
}

  function claimRewards() public {coverage_0x1465c448(0x111e810fc58c2209973610bab0afcfb898c64c69dd542fd8d72d5b9dbc795cad); /* function */ 
}

  function createInsuranceClaim() public {coverage_0x1465c448(0x495e417fbf384e10577617147ed31ac2a87d066d1a0a91459b8894e2d6ddf9df); /* function */ 
}

  function removeCollateralFromMatching() public {coverage_0x1465c448(0x5e7b4d3501e5db1e0c804cf0bc67b9ce30e811f2bd79d8108ba4ee55d9c8833b); /* function */ 
}

  function getCollateralBalance() public {coverage_0x1465c448(0x403ad40353dfdc8baed453c8a16f2713e61385f65cc9dbb0b2494217d8aa45fe); /* function */ 
}

  function getClaimsBalance() public {coverage_0x1465c448(0x9aba2e7cb1582013837fdbe2f6206f13b3a85adbf10f5594a28c9e61aa85fb41); /* function */ 
}

  //////////////////////////////
  /// @notice Private
  /////////////////////////////
}
