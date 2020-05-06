module.exports = async function main({ namedAccounts, deployments }) {
  const { deployIfDifferent, log } = deployments;
  const { agent } = namedAccounts;
  const storage = await deployIfDifferent('data', 'Storage', { from: deployer }, 'Storage')

  if (deployResult.newlyDeployed) {
    await storage.setBool(ethers.utils.keccak256("contract.storage.initialized"), true);

    log(`contract Storage has been deployed and initialized: ${storage.contract.address}`);
  }
}
module.exports.tags = ['Storage'];
