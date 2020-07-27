const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { agent } = await getNamedAccounts();

  const stringHelper = await deploy("StringHelper", {
    from: agent,
  });

  const tokenFactoryHelper = await deploy("TokenFactoryHelper", {
    from: agent,
  });

  const safeMath = await deploy("SafeMath", {
    from: agent,
  });

  const storageHelper = await deploy("StorageHelper", {
    from: agent,
    libraries: {
      StringHelper: stringHelper.address,
      TokenFactoryHelper: tokenFactoryHelper.address,
    },
  });

  const tokenHelper = await deploy("TokenHelper", {
    from: agent,
    libraries: {
      StringHelper: stringHelper.address,
      StorageHelper: storageHelper.address,
    },
  });

  if (
    tokenHelper.newlyDeployed &&
    storageHelper.newlyDeployed &&
    stringHelper.newlyDeployed &&
    tokenFactoryHelper.newlyDeployed &&
    safeMath.newlyDeployed
  ) {
    log(`##### PanDAO: TokenFactoryHelper has been deployed: ${tokenFactoryHelper.address}`);
    log(`##### PanDAO: TokenHelper has been deployed: ${tokenHelper.address}`);
    log(`##### PanDAO: StorageHelper has been deployed: ${storageHelper.address}`);
    log(`##### PanDAO: StringHelper has been deployed: ${stringHelper.address}`);
    log(`##### PanDAO: SafeMath has been deployed: ${safeMath.address}`);
  }
};
module.exports.tags = ["Libraries"];
