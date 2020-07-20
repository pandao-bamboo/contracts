const ethers = require("ethers");
const bre = require("@nomiclabs/buidler").ethers;
const Gelato = require("@gelatonetwork/core");

// GelatoGasPriceOracle Setup Vars
const STARTING_GAS_PRICE = ethers.utils.parseUnits("35", "gwei");

// Gelato Core Setup Vars
const GELATO_GAS_PRICE_ORACLE = ethers.constants.AddressZero; // Dummy value
const ORACLE_REQUEST_DATA = "0x50d25bcd"; // latestAnswer() selector
const GELATO_MAX_GAS = 7000000;
const INTERNAL_GAS_REQUIREMENT = 100000;
const MIN_EXECUTOR_STAKE = ethers.utils.parseEther("1");
const EXECUTOR_SUCCESS_SHARE = 5;
const SYS_ADMIN_SUCCESS_SHARE = 5;

const GELATO_CORE_CONSTRUCT_PARAMS = {
  gelatoGasPriceOracle: GELATO_GAS_PRICE_ORACLE,
  oracleRequestData: ORACLE_REQUEST_DATA,
  gelatoMaxGas: GELATO_MAX_GAS,
  internalGasRequirement: INTERNAL_GAS_REQUIREMENT,
  minExecutorStake: MIN_EXECUTOR_STAKE,
  executorSuccessShare: EXECUTOR_SUCCESS_SHARE,
  sysAdminSuccessShare: SYS_ADMIN_SUCCESS_SHARE,
  totalSuccessShare: EXECUTOR_SUCCESS_SHARE + SYS_ADMIN_SUCCESS_SHARE,
};

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { agent, gelatoSysAdmin, gelatoExecutor } = await getNamedAccounts();
  const executorSigner = bre.provider.getSigner(gelatoExecutor);
  const { deploy, log } = deployments;

  // === GELATO SETUP - THIS SETUP IS ALREADY DONE ON TEST - AND MAINNETS === \\\

  // 1. Deploy Gelato Gas Price Oracle with gelatoGasPriceOracle => Chainlink on Mainnet
  // @dev Acctoung "gelatoGasPriceOracle" can change gas prices for testing purposes
  const GelatoGasPriceOracle = await deploy("GelatoGasPriceOracle", {
    from: gelatoSysAdmin,
    gas: 4000000,
    args: [STARTING_GAS_PRICE],
  });

  // Update GelatoGasPriceOracle address
  GELATO_CORE_CONSTRUCT_PARAMS.gelatoGasPriceOracle = GelatoGasPriceOracle.address;

  // 2. Deploy Gelato Core with SysAdmin
  const GelatoCore = await deploy("GelatoCore", {
    from: gelatoSysAdmin,
    gas: 4000000,
    args: [GELATO_CORE_CONSTRUCT_PARAMS],
  });

  const gelatoCore = new ethers.Contract(
    GelatoCore.address,
    GelatoCore.abi,
    bre.provider.getSigner(gelatoExecutor)
  );

  // 3. Stake Executor
  await gelatoCore.stakeExecutor({
    value: MIN_EXECUTOR_STAKE,
  });

  // === GELATO SETUP - DONE === \\\

  // 4. PanDAO Agent deploys PanDaoProviderModule
  const EternalStorageDeployment = await deployments.get("EternalStorage");
  const PanDaoProviderModule = await deploy("PanDaoProviderModule", {
    from: agent,
    gas: 4000000,
    args: [EternalStorageDeployment.address],
  });

  // 5. PanDAO Agent deploys ConditionBlockNumber
  const ConditionBlockNumber = await deploy("ConditionBlockNumber", {
    from: agent,
    gas: 4000000,
    args: [],
  });

  // Define what kind of Tasks Insurance Pools can execute and have the GelatoManager (owned by Aragon Agent) pay for the tx fees
  const taskSpec = {
    conditions: [ConditionBlockNumber.address],
    actions: [
      {
        addr: ethers.constants.AddressZero,
        data: ethers.constants.HashZero,
        operation: Gelato.Operation.Call,
        dataFlow: Gelato.DataFlow.None,
        value: 0,
        termsOkCheck: false,
      },
    ],
    gasPriceCeil: 0,
  };

  // 5. PanDAO Agent deploys GelatoManager
  const GelatoManager = await deploy("GelatoManager", {
    from: agent,
    gas: 4000000,
    args: [GelatoCore.address, [PanDaoProviderModule.address], [taskSpec], gelatoExecutor],
    value: ethers.utils.parseEther("10"), // Fund with 10 ETH
  });

  if (
    GelatoGasPriceOracle.newlyDeployed &&
    GelatoCore.newlyDeployed &&
    PanDaoProviderModule.newlyDeployed &&
    GelatoManager.newlyDeployed &&
    ConditionBlockNumber.newlyDeployed
  ) {
    log(`// ==== GelatoGasPriceOracle deployed => ${GelatoGasPriceOracle.address} ====`);
    log(`// ==== GelatoCore deployed => ${GelatoCore.address} ====`);
    log(`// ==== PanDaoProviderModule deployed => ${PanDaoProviderModule.address} ====`);
    log(`// ==== GelatoManager deployed => ${GelatoManager.address} ====`);
    log(`// ==== GelatoManager deployed => ${ConditionBlockNumber.address} ====`);
  }
};

module.exports.tags = [
  "GelatoCore",
  "GelatoGasPriceOracle",
  "PanDaoProviderModule",
  "GelatoManager",
  "ConditionBlockNumber",
];
module.exports.dependencies = ["EternalStorage"];
