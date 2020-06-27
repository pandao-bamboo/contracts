const { expect } = require("chai");
const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;
const { deployments } = require("@nomiclabs/buidler");
const fs = require("fs");
const InsuranceToken = require("../artifacts/InsuranceToken.json");

const storageFormat = require("./utils/deployment").storageFormat;

describe("PanDAO Contract Network: Insurance Pool Contract", () => {
  let InsurancePool;
  let ip;

  let EternalStorage;
  let eternalStorage;

  let MockToken;
  let mockToken;

  let agent;
  let testAmount = 5;

  const nullRecord = "0x0000000000000000000000000000000000000000";

  beforeEach(async () => {
    [agent, address1, address2] = await bre.getSigners();
    const { deploy, log } = deployments;

    await deployments.fixture();

    // setup needed contracts
    Manager = await deployments.get("Manager");
    manager = new ethers.Contract(Manager.address, Manager.abi, agent);

    EternalStorage = await deployments.get("EternalStorage");
    eternalStorage = new ethers.Contract(EternalStorage.address, EternalStorage.abi, agent);

    MockToken = await bre.getContractFactory("Token");
    mockToken = await MockToken.deploy();
    await mockToken.deployed();

    insurancePool = await deploy("InsurancePool", {
      from: agent._address,
      args: [mockToken.address, "BTC++", 5, 2, 172800, EternalStorage.address],
    });
    InsurancePool = await deployments.get("InsurancePool");

    const insurancePoolAddress = await eternalStorage.functions.getAddress(
      storageFormat(["string", "address"], ["insurance.pool.address", mockToken.address])
    );

    ip = new ethers.Contract(insurancePoolAddress, InsurancePool.abi, agent);
  });

  it(`Should deposit ${testAmount} insurable tokens as liquidity to the Insurance Pool contract and receive an equal amount of LPAN Tokens`, async () => {
    await mockToken.functions.approve(InsurancePool.address, testAmount);

    await ip.functions.addLiquidity(mockToken.address, agent._address, testAmount);

    const liquidityTokenAddress = await eternalStorage.functions.getAddress(
      storageFormat(["string", "address"], ["insurance.pool.liquidityToken", mockToken.address])
    );

    const liquidityToken = new ethers.Contract(liquidityTokenAddress, InsuranceToken.abi, agent);

    // test storage

    // check balances on the tokens themselves to confirm
    expect(await liquidityToken.functions.balanceOf(agent._address)).to.equal(testAmount);
    expect(await mockToken.functions.balanceOf(InsurancePool.address)).to.equal(testAmount);
  });
});
