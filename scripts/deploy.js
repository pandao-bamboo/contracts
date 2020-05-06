// This is a script for deploying your contracts. You can adapt it to deploy
// yours, or create new ones.
async function main() {
  // This is just a convenience check
  if (network.name === "buidlerevm") {
    console.warn(
      "You are trying to deploy a contract to the Buidler EVM network, which" +
      "gets automatically created and destroyed every time. Use the Buidler" +
      " option '--network localhost'"
    );
  }

  // ethers is avaialble in the global scope
  const [deployer] = await ethers.getSigners();
  console.log(
    "Deploying the contracts with the account:",
    await deployer.getAddress()
  );

  console.log("Account balance:", (await deployer.getBalance()).toString());

  // Deploy Eternal Storage
  const Storage = await ethers.getContractFactory("Storage");
  const storage = await Storage.deploy();
  await storage.deployed();
  await storage.setBool(ethers.utils.keccak256("contract.storage.initialized"), true);

  // Deploy Contracts
  const contracts = [];

  const Manager = await ethers.getContractFactory("Manager");
  const manager = await Manager.deploy();
  await manager.deployed();
  contracts.push(manager);

  // transfer ownership of contracts to MANAGER

  // add contracts to storage
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });