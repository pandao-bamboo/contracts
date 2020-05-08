const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;
const storageFormat = require("../utils/deploymentUtils").storageFormat;

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { log } = deployments;
  const { agent } = await getNamedAccounts();
  const nullRecord = "0x0000000000000000000000000000000000000000";

  /// Deployed Contracts
  const EternalStorage = await deployments.get("EternalStorage");
  const eternalStorage = new ethers.Contract(
    EternalStorage.address,
    EternalStorage.abi,
    bre.provider.getSigner(agent)
  );
  const { setAddress, getAddress, getBool, setBool } = eternalStorage.functions;

  const Manager = await deployments.get("Manager");

  log(`##### PanDAO: Initializing Manager`);
  const daoAgentLocation = storageFormat(["string"], ["dao.agent"]);
  const daoAgent = await getAddress(daoAgentLocation);

  // Setup DAO Agent
  if (daoAgent == nullRecord) {
    await setAddress(daoAgentLocation, agent);
    log(
      `##### PanDAO: Agent successfully initialized: Location - ${daoAgentLocation} / agent - ${agent}`
    );
  } else {
    log(`##### PanDAO: Agent already initialized`);
  }

  // Add Management Contract to Storage
  await setAddress(
    storageFormat(["string", "address"], ["contract.owner", Manager.address]),
    agent
  );
  await setAddress(
    storageFormat(["string", "string"], ["contract.name", "Manager"]),
    Manager.address
  );
  await setAddress(
    storageFormat(["string", "address"], ["contract.address", Manager.address]),
    Manager.address
  );

  const storageInitialized = await getBool(
    storageFormat(["string"], ["contract.storage.initialized"])
  );

  if (storageInitialized == false) {
    log(`##### PanDAO: Initializing Storage`);

    await setAddress(
      storageFormat(
        ["string", "address"],
        ["contract.owner", EternalStorage.address]
      ),
      Manager.address
    );
    await setBool(
      storageFormat(["string"], ["contract.storage.initialized"]),
      true
    );
  } else {
    log(`##### PanDAO: (Not Upgraded)Storage Already Initialized}`);
  }
};

module.exports.dependencies = ["EternalStorage"];
module.exports.dependencies = ["Manager"];
