require('dotenv').config();

usePlugin("@nomiclabs/buidler-waffle");
usePlugin("@nomiclabs/buidler-ethers");
usePlugin("@nomiclabs/buidler-etherscan");
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
    }
  },
  etherscan: {
    url: "https://api.etherscan.io/api",
    apiKey: ETHERSCAN_API_KEY
  },
};