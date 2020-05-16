const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deployIfDifferent, log } = deployments;
  const { agent } = await getNamedAccounts();

  const EternalStorageDeployment = await deployments.get("EternalStorage");
  const tokenFactory = await deployIfDifferent(
    "data",
    "TokenFactory",
    { from: agent },
    "TokenFactory"
  );

  if (tokenFactory.newlyDeployed) {
    tokenFactory.eternalStorage = EternalStorageDeployment.address;

    log(
      `##### PanDAO: TokenFactory has been deployed: ${tokenFactory.address}`
    );
  }
};
module.exports.tags = ["TokenFactory"];
module.exports.dependencies = ["Manager"];
module.exports.dependencies = ["EternalStorage"];
