const { expect } = require("chai");
const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;
const { deployments } = require("@nomiclabs/buidler");
const fs = require("fs");

const storageFormat = require("../utils/deployment").storageFormat;

describe("PanDAO Contract Network: Insurance Pool Contract", () => {
  let InsurancePool;
  let insurancePool;
  let ip;

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
    const { deploy, log } = deployments;

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

    insurancePool = await deploy(
      "InsurancePool",
      { from: agent._address },
      "InsurancePool",
      mockToken.address,
      "BTC++",
      5,
      2,
      172800,
      EternalStorage.address
    );
    InsurancePool = await deployments.get("InsurancePool");

    const insurancePoolAddress = await eternalStorage.functions.getAddress(
      storageFormat(["string", "string"], ["insurance.pool.name", "BTC++"])
    );

    ip = new ethers.Contract(insurancePoolAddress, InsurancePool.abi, agent);
  });

  it("Should deposit X amount of collateral to Insurance Pool contract and receive an equal amount of cPAN Token", async () => {
    await mockToken.functions.approve(InsurancePool.address, 5);

    depositCollateral = await ip.functions.addCollateralForMatching(
      agent._address,
      5
    );
  });
});
