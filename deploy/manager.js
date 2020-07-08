const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { agent } = await getNamedAccounts();

  const EternalStorageDeployment = await deployments.get("EternalStorage");
  const TokenHelperDeployment = await deployments.get("TokenHelper");
  const StorageHelperDeployment = await deployments.get("StorageHelper");
  const StringHelperDeployment = await deployments.get("StringHelper");

  const manager = await deploy("Manager", {
    from: agent,
    args: [EternalStorageDeployment.address],
    libraries: {
      TokenHelper: TokenHelperDeployment.address,
      StorageHelper: StorageHelperDeployment.address,
      StringHelper: StringHelperDeployment.address,
    },
  });

  if (manager.newlyDeployed) {
    log(`##### PanDAO: Contract Manager has been deployed: ${manager.address}`);
  }
};
module.exports.tags = ["Manager"];
module.exports.dependencies = ["Libraries"];
module.exports.dependencies = ["EternalStorage"];
