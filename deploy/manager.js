const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deployIfDifferent, log } = deployments;
  const { agent } = await getNamedAccounts();
  const EternalStorageDeployment = await deployments.get("EternalStorage");
  const EternalStorage = await bre.getContract("EternalStorage");

  const eternalStorage = await new ethers.Contract(EternalStorageDeployment.address, EternalStorageDeployment.abi, bre.provider.getSigner(agent))


  const manager = await deployIfDifferent('data', 'Manager', { from: agent }, 'Manager');


  if (manager.newlyDeployed) {
    manager.eternalStorage = eternalStorage;

    // Setup DAO Agent
    await eternalStorage.functions.setAddress(ethers.utils.formatBytes32String((ethers.utils.solidityPack(['string'], ["dao.agent"]))), agent);

    // // Add Management Contract to Storage
    // await EternalStorage.setAddress(ethers.utils.solidityKeccak256(["contract.owner", manager.address]), [agent]);
    // await EternalStorage.setAddress(ethers.utils.solidityKeccak256(["contract.name", manager]), [manager.address]);
    // await EternalStorage.setAddress(ethers.utils.solidityKeccak256(["contract.address", manager.address]), [manager.address]);


    // // Initialize Storage
    // if (EternalStorage.getBool(ethers.utils.solidityKeccak256(["contract.storage.initialized"])) == false) {
    //   await EternalStorage.setAddress(ethers.utils.solidityKeccak256(["contract.owner", Storage.address]), [manager.address]);
    //   await EternalStorage.setBool(ethers.utils.solidityKeccak256(["contract.storage.initialized"]), [true]);

    //   log(`contract Storage has been initialized: ${EternalStorage.address}`);
    // }


    log(`contract Manager has been deployed: ${manager.address}`);
  }
}
module.exports.tags = ['Manager'];
module.exports.dependencies = ['EternalStorage'];