const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { agent } = await getNamedAccounts();

  const EternalStorageDeployment = await deployments.get("EternalStorage");
  const tokenFactory = await deploy("TokenFactory", {
    from: agent,
    args: [EternalStorageDeployment.address],
  });

  if (tokenFactory.newlyDeployed) {
    log(`##### PanDAO: TokenFactory has been deployed: ${tokenFactory.address}`);
  }
};
module.exports.tags = ["TokenFactory"];
module.exports.dependencies = ["Manager"];
module.exports.dependencies = ["EternalStorage"];
