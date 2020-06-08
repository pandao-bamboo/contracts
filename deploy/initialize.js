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
  const TokenFactory = await deployments.get("TokenFactory");

  // Initialize Contracts
  log(`##### PanDAO: Initializing Contracts`);
  const daoAgentLocation = storageFormat(["string"], ["dao.agent"]);
  const daoAgent = await getAddress(daoAgentLocation);

  // Setup DAO Agent
  if (daoAgent == nullRecord) {
    await setAddress(daoAgentLocation, agent);
    log(`##### PanDAO(Storage): Agent Initialized - (Loc:${daoAgentLocation} / agent: ${agent})`);
  } else {
    log(`##### PanDAO: Agent already initialized`);
  }

  // Initialize Management Contract to Storage
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
  log(`##### PanDAO(Storage): Manager Initialized - (Contract: ${Manager.address})`);

  // Initialize TokenFactory Contract to Storage
  await setAddress(
    storageFormat(["string", "address"], ["contract.owner", TokenFactory.address]),
    Manager.address
  );
  await setAddress(
    storageFormat(["string", "string"], ["contract.name", "TokenFactory"]),
    TokenFactory.address
  );
  await setAddress(
    storageFormat(["string", "address"], ["contract.address", TokenFactory.address]),
    TokenFactory.address
  );
  log(`##### PanDAO(Storage): TokenFactory Initialized - (Contract: ${TokenFactory.address})`);

  // THIS SHOULD ALWAYS BE LAST!!!!!
  // Once the storage is initialized only the
  // latest version of a contract in the network can call its functions
  const storageInitialized = await getBool(
    storageFormat(["string"], ["contract.storage.initialized"])
  );

  if (storageInitialized == false) {
    log(`##### PanDAO: Initializing Storage`);

    await setAddress(
      storageFormat(["string", "address"], ["contract.owner", EternalStorage.address]),
      Manager.address
    );
    await setAddress(
      storageFormat(["string", "string"], ["contract.name", "Storage"]),
      EternalStorage.address
    );
    await setAddress(
      storageFormat(["string", "address"], ["contract.address", EternalStorage.address]),
      EternalStorage.address
    );
    await setBool(storageFormat(["string"], ["contract.storage.initialized"]), true);
  } else {
    log(`##### PanDAO: (Not Upgraded)Storage Already Initialized}`);
  }
};

module.exports.dependencies = ["EternalStorage", "Manager", "TokenFactory"];
