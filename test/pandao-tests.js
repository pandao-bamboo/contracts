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

  let agent;
  let address1;
  let address2;

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

    it("Can get contract address by name", async () => {
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
  });
});
