const { expect } = require("chai");
const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;
const { deployments } = require("@nomiclabs/buidler");
const fs = require("fs");
const InsuranceToken = require("../artifacts/InsuranceToken.json");

const storageFormat = require("../utils/deployment").storageFormat;

describe("PanDAO Contract Network: Insurance Pool Contract", () => {
  let InsurancePool;
  let ip;

  let EternalStorage;
  let eternalStorage;

  let MockToken;
  let mockToken;

  let agent;

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

    const positions = await eternalStorage.functions.getInsurancePoolQueue(
      mockToken.address
    );

    const collateralTokenAddress = await eternalStorage.functions.getAddress(
      storageFormat(
        ["string", "address"],
        ["insurance.pool.collateralToken", InsurancePool.address]
      )
    );
    const collateralToken = new ethers.Contract(
      collateralTokenAddress,
      InsuranceToken.abi,
      agent
    );

    // test storage
    expect(positions).to.have.lengthOf(1);
    expect(positions[0].liquidityProviderAddress).to.equal(agent._address);
    expect(positions[0].amount).to.equal(5);

    // check balances on the tokens themselves to confirm
    expect(await collateralToken.functions.balanceOf(agent._address)).to.equal(
      5
    );
    expect(await mockToken.functions.balanceOf(InsurancePool.address)).to.equal(
      5
    );
  });
});
