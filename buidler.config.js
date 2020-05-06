require('dotenv').config();

usePlugin("@nomiclabs/buidler-waffle");
usePlugin("@nomiclabs/buidler-ethers");
usePlugin("@nomiclabs/buidler-etherscan");
usePlugin("@nomiclabs/buidler-deploy");
usePlugin("solidity-coverage");

const ETHERSCAN_API_KEY = process.env.ETHERSCAN || "";

module.exports = {
  defaultNetwork: "buidlerevm",
  solc: {
    version: "0.6.6",
    optimizer: {
      runs: 200,
      enabled: true,
    }
  },
  networks: {
    buidlerevm: {
      gasPrice: 0,
      blockGasLimit: 100000000,
    },
    coverage: {
      url: 'http://127.0.0.1:8555' // Coverage launches its own ganache-cli client
    }
  },
  etherscan: {
    url: "https://api.etherscan.io/api",
    apiKey: ETHERSCAN_API_KEY
  },
  namedAccounts: {
    agent: {
      default: 0,
      1: 'mainnetAgentAddress',
      4: 'rinkebyAgentAddress',
      42: 'kovanAgentAddress'
    }
  },
  paths: {
    deploy: 'deploy',
    deployments: 'deployments'
  }
};