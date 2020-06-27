module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { agent } = await getNamedAccounts();
  const storage = await deploy("EternalStorage", { from: agent, args: [] });

  if (storage.newlyDeployed) {
    log(`##### PanDAO: Contract Storage has been deployed: ${storage.address}`);
  }
};
module.exports.tags = ["EternalStorage"];
