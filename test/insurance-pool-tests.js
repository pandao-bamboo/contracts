const { expect } = require("chai");
const { ethers } = require("ethers");
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
  let testAmount = 5.0;

  let coverageDuration = 172800;
  let currentBlockNumber;

  beforeEach(async () => {
    [agent, address1, address2] = await bre.getSigners();
    const { deploy, log } = deployments;

    await deployments.fixture();

    // setup needed contracts
    Manager = await deployments.get("Manager");
    manager = new ethers.Contract(Manager.address, Manager.abi, agent);

    EternalStorage = await deployments.get("EternalStorage");
    StorageHelper = await deployments.get("StorageHelper");
    TokenHelper = await deployments.get("TokenHelper");
    StringHelper = await deployments.get("StringHelper");
    eternalStorage = new ethers.Contract(EternalStorage.address, EternalStorage.abi, agent);

    MockToken = await bre.getContractFactory("Token");
    mockToken = await MockToken.deploy();
    await mockToken.deployed();

    currentBlockNumber = await bre.provider.getBlockNumber();

    insurancePool = await deploy("InsurancePool", {
      from: agent._address,
      args: [
        mockToken.address,
        mockToken.symbol(),
        5.0,
        2.0,
        currentBlockNumber,
        coverageDuration,
        EternalStorage.address,
      ],
      libraries: {
        TokenHelper: TokenHelper.address,
        StorageHelper: StorageHelper.address,
        StringHelper: StringHelper.address,
      },
    });
    InsurancePool = await deployments.get("InsurancePool");

    ip = new ethers.Contract(InsurancePool.address, InsurancePool.abi, agent);
  });

  it(`Should deposit ${testAmount} insurable tokens as liquidity to the Insurance Pool contract and receive an equal amount of LPAN Tokens`, async () => {
    await mockToken.functions.approve(InsurancePool.address, testAmount);

    await ip.functions.addLiquidity(testAmount);

    const liquidityTokenAddress = await eternalStorage.functions.getAddress(
      storageFormat(["string", "address"], ["insurance.pool.liquidityToken", InsurancePool.address])
    );

    const liquidityToken = new ethers.Contract(liquidityTokenAddress, InsuranceToken.abi, agent);

    // check balances on the tokens themselves to confirm
    expect(await liquidityToken.functions.balanceOf(agent._address)).to.equal(testAmount);
    expect(await mockToken.functions.balanceOf(InsurancePool.address)).to.equal(testAmount);
  });

  it(`Should remove ${testAmount} insurable tokens from liquidity pool and burn an equal amount of LPAN Tokens`, async () => {
    await mockToken.functions.approve(InsurancePool.address, testAmount);
    await ip.functions.addLiquidity(testAmount);

    await ip.functions.removeLiquidity(testAmount);

    const liquidityTokenAddress = await eternalStorage.functions.getAddress(
      storageFormat(["string", "address"], ["insurance.pool.liquidityToken", InsurancePool.address])
    );
    const liquidityToken = new ethers.Contract(liquidityTokenAddress, InsuranceToken.abi, agent);

    // check balances on the tokens themselves to confirm
    expect(await liquidityToken.functions.balanceOf(agent._address)).to.equal(0);
    expect(await mockToken.functions.balanceOf(InsurancePool.address)).to.equal(0);
  });

  it.only(`Should buy insurance for the Insuree`, async () => {
    const claimsTokenAddress = await eternalStorage.functions.getAddress(
      storageFormat(["string", "address"], ["insurance.pool.claimsToken", InsurancePool.address])
    );
    const claimsToken = new ethers.Contract(claimsTokenAddress, InsuranceToken.abi, agent);
    const insureeFee = await eternalStorage.functions.getUint(
      storageFormat(["string", "address"], ["insurance.pool.insureeFeeRate", InsurancePool.address])
    );
    const serviceFee = await eternalStorage.functions.getUint(
      storageFormat(["string", "address"], ["insurance.pool.serviceFeeRate", InsurancePool.address])
    );

    const premiumAmount = testAmount * insureeFee;
    const doaFee = premiumAmount * serviceFee;

    await mockToken.approve(InsurancePool.address, premiumAmount);
    await ip.functions.buyInsurance(testAmount, agent._address, 12);

    const poolAssetAmount = await mockToken.balanceOf(InsurancePool.address);
    console.log("poolAssetAmount", poolAssetAmount);

    expect(await claimsToken.functions.balanceOf(agent._address)).to.equal(testAmount);
    expect(poolAssetAmount).to.equal(premiumAmount);
  });
});
