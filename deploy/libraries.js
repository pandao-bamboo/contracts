const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { agent } = await getNamedAccounts();

  const stringHelper = await deploy("StringHelper", {
    from: agent,
    args: [],
  });

  const storageHelper = await deploy("StorageHelper", {
    from: agent,
    libraries: {
      StringHelper: stringHelper.address,
    },
  });

  const poolsHelper = await deploy("PoolsHelper", {
    from: agent,
    libraries: {
      StringHelper: stringHelper.address,
      StorageHelper: storageHelper.address,
    },
  });

  if (poolsHelper.newlyDeployed && storageHelper.newlyDeployed && stringHelper.newlyDeployed) {
    log(`##### PanDAO: PoolsHelper has been deployed: ${poolsHelper.address}`);
    log(`##### PanDAO: StorageHelper has been deployed: ${storageHelper.address}`);
    log(`##### PanDAO: StringHelper has been deployed: ${stringHelper.address}`);
  }
};
module.exports.tags = ["Libraries"];
