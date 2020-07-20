const { expect } = require("chai");
const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;
const { deployments } = require("@nomiclabs/buidler");

const storageFormat = require("./utils/deployment").storageFormat;

describe("PanDAO Contract Network: Manager Contract", () => {
  let Manager;
  let manager;

  let EternalStorage;
  let eternalStorage;

  let MockToken;
  let mockToken;

  let agent;
  let address1;
  let address2;

  let coverageDuration = 172800;
  let currentBlockNumber;

  beforeEach(async () => {
    [agent, address1, address2] = await bre.getSigners();

    await deployments.fixture();

    StorageHelper = await deployments.get("StorageHelper");
    storageHelper = new ethers.Contract(StorageHelper.address, StorageHelper.abi, agent);
    StringHelper = await deployments.get("StringHelper");
    TokenHelper = await deployments.get("TokenHelper");
    TokenFactoryHelper = await deployments.get("TokenFactoryHelper");

    // setup needed contracts
    Manager = await deployments.get("Manager");
    manager = new ethers.Contract(Manager.address, Manager.abi, agent);

    EternalStorage = await deployments.get("EternalStorage");
    eternalStorage = new ethers.Contract(EternalStorage.address, EternalStorage.abi, agent);

    MockToken = await bre.getContractFactory("Token");
    mockToken = await MockToken.deploy();
    await mockToken.deployed();

    currentBlockNumber = await bre.provider.getBlockNumber();
  });

  it("Manager is stored in EternalStorage", async () => {
    expect(
      await eternalStorage.functions.getAddress(
        storageFormat(["string", "address"], ["contract.address", Manager.address])
      )
    ).to.equal(Manager.address);
  });

  it("Can get contract address by contract name", async () => {
    expect(
      await eternalStorage.functions.getAddress(
        storageFormat(["string", "string"], ["contract.name", "Manager"])
      )
    ).to.equal(Manager.address);
  });

  it("Agent owns deployed Manager contract", async () => {
    expect(
      await eternalStorage.functions.getAddress(
        storageFormat(["string", "address"], ["contract.owner", Manager.address])
      )
    ).to.equal(await agent.getAddress());
  });

  it("Can create an Insurance Pool", async () => {
    const ip = await manager.functions.createInsurancePool(
      mockToken.address,
      mockToken.symbol(),
      5,
      2,
      currentBlockNumber,
      coverageDuration
    );

    const insurancePoolAddress = await storageHelper.functions.getInsurancePoolAddress(
      mockToken.address,
      EternalStorage.address
    );

    expect(
      await eternalStorage.functions.getUint(
        storageFormat(
          ["string", "address"],
          ["insurance.pool.insureeFeeRate", insurancePoolAddress]
        )
      )
    ).to.equal(5);
  });

  it("Fails to create an Insurance Pool if not Agent", async () => {
    notAgentSigner = new ethers.Contract(Manager.address, Manager.abi, address1);
    await expect(
      notAgentSigner.functions.createInsurancePool(
        mockToken.address,
        mockToken.symbol(),
        5,
        2,
        currentBlockNumber,
        coverageDuration
      )
    ).to.be.revertedWith("PanDAO: UnAuthorized - Agent only");
  });
});
