module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deployIfDifferent, log } = deployments;
  const { agent } = await getNamedAccounts();
  const storage = await deployIfDifferent('data', 'EternalStorage', { from: agent }, 'EternalStorage')

  if (storage.newlyDeployed) {
    log(`contract Storage has been deployed: ${storage.address}`);
  }
}
module.exports.tags = ['EternalStorage'];
