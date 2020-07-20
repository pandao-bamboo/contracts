const { expect } = require("chai");
const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;
const { deployments, getNamedAccounts } = require("@nomiclabs/buidler");
const fs = require("fs");
const InsuranceToken = require("../artifacts/InsuranceToken.json");

const Gelato = require("@gelatonetwork/core");

const storageFormat = require("./utils/deployment").storageFormat;

describe("PanDAO Contract Network: Insurance Pool Contract - Automated monthly premium payment with Gelato", () => {
  let InsurancePool;
  let ip;

  let EternalStorage;
  let eternalStorage;

  let MockToken;
  let mockToken;

  let GelatoCore;
  let gelatoCore;

  let GelatoGasPriceOracle;
  let gelatoGasPriceOracle;

  let PanDaoProviderModule;

  let agent;
  let user;
  let userAddress;
  let gelatoExecutor;
  let gelatoExecutorAddress;
  let testAmount = ethers.utils.parseEther("10");

  let currentGasPrice;
  let gelatoMaxGas;

  const nullRecord = "0x0000000000000000000000000000000000000000";

  const coverageDuration = 50;
  const termLengthInMonths = 12;
  const insureeFeeRate = ethers.utils.bigNumberify("5");
  const serviceFeeRate = ethers.utils.bigNumberify("2");

  let currentBlockNumber;

  beforeEach(async () => {
    [agent, user] = await bre.getSigners();
    userAddress = await user.getAddress();
    gelatoExecutorAddress = { gelatoExecutor } = await getNamedAccounts();
    gelatoExecutor = bre.provider.getSigner(gelatoExecutor);
    const { deploy, log } = deployments;

    await deployments.fixture();

    // setup needed contracts
    Manager = await deployments.get("Manager");
    manager = new ethers.Contract(Manager.address, Manager.abi, agent);

    EternalStorage = await deployments.get("EternalStorage");
    StorageHelper = await deployments.get("StorageHelper");
    TokenHelper = await deployments.get("TokenHelper");
    StringHelper = await deployments.get("StringHelper");
    GelatoCore = await deployments.get("GelatoCore");
    PanDaoProviderModule = await deployments.get("PanDaoProviderModule");
    GelatoManager = await deployments.get("GelatoManager");
    GelatoGasPriceOracle = await deployments.get("GelatoGasPriceOracle");
    eternalStorage = new ethers.Contract(EternalStorage.address, EternalStorage.abi, agent);
    gelatoCore = new ethers.Contract(GelatoCore.address, GelatoCore.abi, gelatoExecutor);
    gelatoGasPriceOracle = new ethers.Contract(
      GelatoGasPriceOracle.address,
      GelatoGasPriceOracle.abi,
      gelatoExecutor
    );
    currentGasPrice = await gelatoGasPriceOracle.latestAnswer();
    gelatoMaxGas = await gelatoCore.gelatoMaxGas();

    MockToken = await bre.getContractFactory("Token", user);
    mockToken = await MockToken.deploy();
    await mockToken.deployed();

    currentBlockNumber = await bre.provider.getBlockNumber();

    insurancePool = await deploy("InsurancePool", {
      from: agent._address,
      args: [
        mockToken.address,
        "BTC++",
        insureeFeeRate,
        serviceFeeRate,
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

    // const insurancePoolAddress = await eternalStorage.functions.getAddress(
    //   storageFormat(["string", "address"], ["insurance.pool.address", mockToken.address])
    // );

    ip = new ethers.Contract(InsurancePool.address, InsurancePool.abi, user);
  });

  it(`User should pay a fee of ${testAmount
    .mul(insureeFeeRate)
    .div(
      100
    )} tokens as premium to the Insurance Pool contract and receive ${testAmount} Claims Tokens`, async () => {
    await mockToken.connect(user).functions.approve(InsurancePool.address, testAmount);

    await ip
      .connect(user)
      .functions.buyInsurance(testAmount, userAddress, termLengthInMonths, { gasLimit: 4000000 });

    const claimsTokenAddress = await eternalStorage.functions.getAddress(
      storageFormat(["string", "address"], ["insurance.pool.claimsToken", InsurancePool.address])
    );

    const claimsToken = new ethers.Contract(claimsTokenAddress, InsuranceToken.abi, agent);

    const ipBalance = await mockToken.functions.balanceOf(InsurancePool.address);

    const insureeFee = testAmount.mul(insureeFeeRate).div(100);

    const expectedIpBalance = insureeFee.sub(
      testAmount.mul(insureeFeeRate).div(100).mul(serviceFeeRate).div(100)
    );

    // check balances on the tokens themselves to confirm
    expect(await claimsToken.functions.balanceOf(userAddress)).to.equal(testAmount);
    expect(ipBalance).to.equal(expectedIpBalance);
  });

  it(`For each "buyInsurance" call, a premium payment will be conduced, followed 11 monthly schedule payments which should be executed, if the user has sufficient balance and gave sufficient approval. One month after the last preimum payment, all claim tokens should be burned, ending the insurance`, async () => {
    const totalPremiumAmount = testAmount.mul(insureeFeeRate).div(100);

    // approve 12 x the premium payment
    await mockToken
      .connect(user)
      .functions.approve(InsurancePool.address, totalPremiumAmount.mul(12));

    await expect(
      ip
        .connect(user)
        .functions.buyInsurance(testAmount, userAddress, termLengthInMonths, { gasLimit: 4000000 })
    ).to.emit(gelatoCore, "LogTaskSubmitted");

    const currentTaskId = await gelatoCore.currentTaskReceiptId();
    expect(currentTaskId).to.equal(1, "Current Task Id on GelatoCore should be 1");

    const filter = {
      address: gelatoCore.address,
      topics: [gelatoCore.interface.events["LogTaskSubmitted"].topic],
    };

    // User still has all claim tokens
    const claimsTokenAddress = await eternalStorage.functions.getAddress(
      storageFormat(["string", "address"], ["insurance.pool.claimsToken", InsurancePool.address])
    );

    const claimsToken = new ethers.Contract(claimsTokenAddress, InsuranceToken.abi, agent);

    let monthlyPayments = 0;
    let newTime = new Date().getTime();
    while (monthlyPayments < 11) {
      const filteredLogs = await bre.provider.getLogs(filter);

      const logWithTxHash = filteredLogs[0];
      const parsedLog = gelatoCore.interface.parseLog(logWithTxHash);

      const taskReceiptAsArray = parsedLog.values.taskReceipt; // Due to ethers v4

      const taskReceiptAsObj = Gelato.convertTaskReceiptArrayToObj(taskReceiptAsArray);

      let canExecResult = await gelatoCore
        .connect(gelatoExecutor)
        .canExec(taskReceiptAsObj, gelatoMaxGas, currentGasPrice);

      expect(canExecResult).to.equal("ConditionNotOk:NotOkBlockDidNotPass");

      // Condition not passed, gelato cannot execute the premium payment
      await expect(
        gelatoCore
          .connect(gelatoExecutor)
          .exec(taskReceiptAsObj, { gasLimit: 4000000, gasPrice: currentGasPrice })
      ).to.emit(gelatoCore, "LogCanExecFailed");

      for (let i = 0; i < coverageDuration; i++) {
        await bre.provider.send("evm_mine", [newTime]);
        newTime = newTime + 1000;
      }

      canExecResult = await gelatoCore
        .connect(gelatoExecutor)
        .canExec(taskReceiptAsObj, gelatoMaxGas, currentGasPrice);

      expect(canExecResult).to.equal("OK");

      const userBalanceBeforePayment = await mockToken.functions.balanceOf(userAddress);

      const ipBalanceBeforePayment = await mockToken.functions.balanceOf(InsurancePool.address);

      if (monthlyPayments < 11) {
        await expect(
          gelatoCore
            .connect(gelatoExecutor)
            .exec(taskReceiptAsObj, { gasLimit: 4000000, gasPrice: currentGasPrice })
        )
          .to.emit(gelatoCore, "LogExecSuccess")
          .to.emit(gelatoCore, "LogTaskSubmitted");
      } else {
        // for the last Premium payment, no new premium payment will be scheduled, hence no "LogTaskSubmitted" event will be emitted
        await expect(
          gelatoCore
            .connect(gelatoExecutor)
            .exec(taskReceiptAsObj, { gasLimit: 4000000, gasPrice: currentGasPrice })
        ).to.emit(gelatoCore, "LogExecSuccess");
      }

      if (monthlyPayments < 11) {
        const userBalanceAfterPayment = await mockToken.functions.balanceOf(userAddress);

        expect(userBalanceAfterPayment).to.equal(userBalanceBeforePayment.sub(totalPremiumAmount));

        const ipBalanceAfterPayment = await mockToken.functions.balanceOf(InsurancePool.address);

        const expectedIpTokenSurplus = totalPremiumAmount.sub(
          testAmount.mul(insureeFeeRate).div(100).mul(serviceFeeRate).div(100)
        );

        expect(ipBalanceAfterPayment).to.equal(ipBalanceBeforePayment.add(expectedIpTokenSurplus));

        // User should still have all claim tokens
        expect(testAmount).to.equal(await claimsToken.functions.balanceOf(userAddress));
      } else {
        // Claim tokens should be burned

        // User should have 0 claim token balance left:
        expect(0).to.equal(await claimsToken.functions.balanceOf(userAddress));
      }

      monthlyPayments++;
    }

    expect(testAmount).to.equal(await claimsToken.functions.balanceOf(userAddress));
  });

  it(`If user calls "buyInsurance" and when the first monthly payment is due, he does not have the required allowance, burn all his claim tokens`, async () => {
    const totalPremiumAmount = testAmount.mul(insureeFeeRate).div(100);

    const claimsTokenAddress = await eternalStorage.functions.getAddress(
      storageFormat(["string", "address"], ["insurance.pool.claimsToken", InsurancePool.address])
    );

    const claimsToken = new ethers.Contract(claimsTokenAddress, InsuranceToken.abi, agent);

    // approve 1 x the premium payment (for the first payment when buyInsurance is called)
    // => Insufficient approval for the first monthly premium payment done by gelato
    await mockToken
      .connect(user)
      .functions.approve(InsurancePool.address, totalPremiumAmount.mul(1));

    await expect(
      ip
        .connect(user)
        .functions.buyInsurance(testAmount, userAddress, termLengthInMonths, { gasLimit: 4000000 })
    ).to.emit(gelatoCore, "LogTaskSubmitted");

    // User received claims tokens = testAmount
    expect(testAmount).to.equal(await claimsToken.functions.balanceOf(userAddress));

    const currentTaskId = await gelatoCore.currentTaskReceiptId();
    expect(currentTaskId).to.equal(1, "Current Task Id on GelatoCore should be 1");

    const filter = {
      address: gelatoCore.address,
      topics: [gelatoCore.interface.events["LogTaskSubmitted"].topic],
    };

    const filteredLogs = await bre.provider.getLogs(filter);

    const logWithTxHash = filteredLogs[0];
    const parsedLog = gelatoCore.interface.parseLog(logWithTxHash);

    const taskReceiptAsArray = parsedLog.values.taskReceipt; // Due to ethers v4

    const taskReceiptAsObj = Gelato.convertTaskReceiptArrayToObj(taskReceiptAsArray);

    let canExecResult = await gelatoCore
      .connect(gelatoExecutor)
      .canExec(taskReceiptAsObj, gelatoMaxGas, currentGasPrice);

    expect(canExecResult).to.equal("ConditionNotOk:NotOkBlockDidNotPass");

    // Condition not passed, gelato cannot execute the premium payment
    await expect(
      gelatoCore
        .connect(gelatoExecutor)
        .exec(taskReceiptAsObj, { gasLimit: 4000000, gasPrice: currentGasPrice })
    ).to.emit(gelatoCore, "LogCanExecFailed");

    let newTime = new Date().getTime();
    for (let i = 0; i < coverageDuration; i++) {
      await bre.provider.send("evm_mine", [newTime]);
      newTime = newTime + 1000;
    }

    canExecResult = await gelatoCore
      .connect(gelatoExecutor)
      .canExec(taskReceiptAsObj, gelatoMaxGas, currentGasPrice);

    expect(canExecResult).to.equal("OK");

    const userBalanceBeforePayment = await mockToken.functions.balanceOf(userAddress);

    const ipBalanceBeforePayment = await mockToken.functions.balanceOf(InsurancePool.address);

    // payPremium was executed, yet insufficient approval was given, hence claim tokens got burned
    await expect(
      gelatoCore
        .connect(gelatoExecutor)
        .exec(taskReceiptAsObj, { gasLimit: 4000000, gasPrice: currentGasPrice })
    ).to.emit(gelatoCore, "LogExecSuccess");

    const userBalanceAfterPayment = await mockToken.functions.balanceOf(userAddress);

    expect(userBalanceAfterPayment).to.equal(userBalanceBeforePayment);

    const ipBalanceAfterPayment = await mockToken.functions.balanceOf(InsurancePool.address);

    expect(ipBalanceAfterPayment).to.equal(ipBalanceBeforePayment);

    // User should have 0 claim token balance left:
    expect(0).to.equal(await claimsToken.functions.balanceOf(userAddress));
  });
});
