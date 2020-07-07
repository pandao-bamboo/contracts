module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { agent } = await getNamedAccounts();

  const PoolsHelperDeployment = await deployments.get("PoolsHelper");
  const StringHelperDeployment = await deployments.get("StringHelper");
  const StorageHelperDeployment = await deployments.get("StorageHelper");

  const storage = await deploy("EternalStorage", {
    from: agent,
    args: [],
    libraries: {
      PoolsHelper: PoolsHelperDeployment.address,
      StorageHelper: StorageHelperDeployment.address,
      StringHelper: StringHelperDeployment.address,
    },
  });

  if (storage.newlyDeployed) {
    log(`##### PanDAO: Contract Storage has been deployed: ${storage.address}`);
  }
};
module.exports.tags = ["EternalStorage"];
module.exports.dependencies = ["Libraries"];
