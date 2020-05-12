const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;
const storageFormat = require("../utils/deployment").storageFormat;

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { log } = deployments;
  const { agent } = await getNamedAccounts();
  const nullRecord = "0x0000000000000000000000000000000000000000";

  // Storage
  const EternalStorage = await deployments.get("EternalStorage");
  const eternalStorage = new ethers.Contract(
    EternalStorage.address,
    EternalStorage.abi,
    bre.provider.getSigner(agent)
  );
  const { setAddress, getAddress, getBool, setBool } = eternalStorage.functions;

  /// Deployed Contracts
  const Manager = await deployments.get("Manager");

  // Initialize Contracts
  log(`##### PanDAO: Initializing Manager`);
  const daoAgentLocation = storageFormat(["string"], ["dao.agent"]);
  const daoAgent = await getAddress(daoAgentLocation);

  // Setup DAO Agent
  if (daoAgent == nullRecord) {
    await setAddress(daoAgentLocation, agent);
    log(
      `##### PanDAO(Storage): Agent Initialized - (Loc:${daoAgentLocation} / agent: ${agent})`
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
  await setString(
    storageFormat(["string", "address"], ["contract.address", Manager.address]),
    Manager.address
  );
  log(
    `##### PanDAO(Storage): Manager Initialized - (Manager: ${Manager.address})`
  );

  // THIS SHOULD ALWAYS BE LAST!!!!!
  // Once the storage is initialized only the
  // latest version of a contract in the network can call its functions
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
