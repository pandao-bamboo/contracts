require('dotenv').config();

usePlugin("@nomiclabs/buidler-waffle");
usePlugin("@nomiclabs/buidler-ethers");
usePlugin("@nomiclabs/buidler-etherscan");
usePlugin("solidity-coverage");

const ETHERSCAN_API_KEY = process.env.ETHERSCAN || "";

module.exports = {
  defaultNetwork: "buidlerevm",
  solc: {
    version: "0.6.4",
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

// This is a sample Buidler task. To learn how to create your own go to
// https://buidler.dev/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(await account.getAddress());
  }
});
