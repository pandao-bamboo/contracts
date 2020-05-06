module.exports = async function main({ namedAccounts, deployments }) {
  const { deployIfDifferent, log } = deployments;
  const { agent } = namedAccounts;
  const Storage = await deployments.get("Storage");

  const manager = await deployIfDifferent('data', 'Manager', { from: agent }, 'Storage')

  if (deployResult.newlyDeployed) {
    await Storage.setAddress(ethers.utils.keccak256("contract.owner", manager.address), agent);
    await Storage.setAddress(ethers.utils.keccak256("contract.name", manager), manager.address);
    await Storage.setAddress(ethers.utils.keccak256("contract.address", manager.address), manager.address);
    await Storage.setAddress(ethers.utils.keccak256("contract.owner", Storage.address), manager.address);
    log(`contract Manager has been deployed: ${storage.contract.address}`);
  }
}
module.exports.tags = ['Manager'];
module.exports.dependencies = ['Storage'];
