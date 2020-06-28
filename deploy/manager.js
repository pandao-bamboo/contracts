const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { agent } = await getNamedAccounts();

  const EternalStorageDeployment = await deployments.get("EternalStorage");
  const manager = await deploy("Manager", {
    from: agent,
    args: [EternalStorageDeployment.address],
  });

  if (manager.newlyDeployed) {
    log(`##### PanDAO: Contract Manager has been deployed: ${manager.address}`);
  }
};
module.exports.tags = ["Manager"];
module.exports.dependencies = ["EternalStorage"];
