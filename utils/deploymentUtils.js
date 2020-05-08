const ethers = require("ethers");
const { defaultAbiCoder, keccak256, formatBytes32String } = ethers.utils;

module.exports = {
  storageFormat: (storageTypes, storageLocation) => {
    return keccak256(defaultAbiCoder.encode(storageTypes, storageLocation));
  },
};
