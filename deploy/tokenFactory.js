const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { agent } = await getNamedAccounts();

  const EternalStorageDeployment = await deployments.get("EternalStorage");
  const TokenHelperDeployment = await deployments.get("TokenHelper");
  const StorageHelperDeployment = await deployments.get("StorageHelper");
  const StringHelperDeployment = await deployments.get("StringHelper");
  const SafeMath = await deployments.get("SafeMath");

  const tokenFactory = await deploy("TokenFactory", {
    from: agent,
    args: [EternalStorageDeployment.address],
    libraries: {
      TokenHelper: TokenHelperDeployment.address,
      StorageHelper: StorageHelperDeployment.address,
      StringHelper: StringHelperDeployment.address,
      SafeMath: SafeMath.address,
    },
  });

  if (tokenFactory.newlyDeployed) {
    log(`##### PanDAO: TokenFactory has been deployed: ${tokenFactory.address}`);
  }
};
module.exports.tags = ["TokenFactory"];
module.exports.dependencies = ["Libraries"];
module.exports.dependencies = ["Manager"];
module.exports.dependencies = ["EternalStorage"];
