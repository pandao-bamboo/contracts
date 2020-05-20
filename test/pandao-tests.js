const { expect } = require("chai");
const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;
const { deployments, getNamedAccounts } = require("@nomiclabs/buidler");

const storageFormat = require("../utils/deployment").storageFormat;

describe("PanDAO Contract Network", () => {
  let Manager;
  let manager;

  let EternalStorage;
  let eternalStorage;

  let MockToken;
  let mockToken;

  let agent;
  let address1;
  let address2;

  const nullRecord = "0x0000000000000000000000000000000000000000";

  beforeEach(async () => {
    [agent, address1, address2] = await bre.getSigners();

    await deployments.fixture();

    // setup needed contracts
    Manager = await deployments.get("Manager");
    manager = new ethers.Contract(Manager.address, Manager.abi, agent);

    EternalStorage = await deployments.get("EternalStorage");
    eternalStorage = new ethers.Contract(
      EternalStorage.address,
      EternalStorage.abi,
      agent
    );

    MockToken = await bre.getContractFactory("Token");
    mockToken = await MockToken.deploy();
    await mockToken.deployed();
  });

  describe("Manager Contract", () => {
    it("Manager is stored in EternalStorage", async () => {
      expect(
        await eternalStorage.functions.getAddress(
          storageFormat(
            ["string", "address"],
            ["contract.address", Manager.address]
          )
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
          storageFormat(
            ["string", "address"],
            ["contract.owner", Manager.address]
          )
        )
      ).to.equal(await agent.getAddress());
    });

    it("Can create an Insurance Pool if it doesn't exist", async () => {
      const ip = await manager.functions.createInsurancePool(
        mockToken.address,
        "BTC++",
        5,
        2,
        172800
      );
      const insurancePoolAddress = await eternalStorage.functions.getAddress(
        storageFormat(["string", "string"], ["insurance.pool.name", "BTC++"])
      );

      expect(ip).to.have.property("hash");
      expect(
        await eternalStorage.functions.getAddress(
          storageFormat(["string", "string"], ["insurance.pool.name", "BTC++"])
        )
      )
        .to.be.an("string")
        .that.does.not.include(nullRecord);

      expect(
        await eternalStorage.functions.getAddress(
          storageFormat(
            ["string", "address"],
            ["insurance.pool.insuredToken", mockToken.address]
          )
        )
      ).to.equal(mockToken.address);

      expect(
        await eternalStorage.functions.getUint(
          storageFormat(
            ["string", "address"],
            ["insurance.pool.insureeFeeRate", insurancePoolAddress]
          )
        )
      ).to.equal(5);

      expect(
        await eternalStorage.functions.getUint(
          storageFormat(
            ["string", "address"],
            ["insurance.pool.serviceFeeRate", insurancePoolAddress]
          )
        )
      ).to.equal(2);

      expect(
        await eternalStorage.functions.getUint(
          storageFormat(
            ["string", "address"],
            ["insurance.pool.premiumPeriod", insurancePoolAddress]
          )
        )
      ).to.equal(172800);
    });

    it("Fails to create Insurance Pool if it already exists", async () => {
      const originalPool = await manager.functions.createInsurancePool(
        mockToken.address,
        "BTC++",
        5,
        2,
        172800
      );
      const duplicatePool = await expect(
        manager.functions.createInsurancePool(
          mockToken.address,
          "BTC++",
          5,
          2,
          172800
        )
      ).to.be.revertedWith(
        "PanDAO: Insurance Pool already exists for that asset"
      );
    });
  });
});