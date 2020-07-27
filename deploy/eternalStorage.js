module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { agent } = await getNamedAccounts();

  const TokenHelperDeployment = await deployments.get("TokenHelper");
  const StringHelperDeployment = await deployments.get("StringHelper");
  const StorageHelperDeployment = await deployments.get("StorageHelper");
  const SafeMath = await deployments.get("SafeMath");

  const storage = await deploy("EternalStorage", {
    from: agent,
    args: [],
    libraries: {
      TokenHelper: TokenHelperDeployment.address,
      StorageHelper: StorageHelperDeployment.address,
      StringHelper: StringHelperDeployment.address,
      SafeMath: SafeMath.address,
    },
  });

  if (storage.newlyDeployed) {
    log(`##### PanDAO: Contract Storage has been deployed: ${storage.address}`);
  }
};
module.exports.tags = ["EternalStorage"];
module.exports.dependencies = ["Libraries"];
