const { expect } = require("chai");

describe("TokenFactory", () => {
  it("should create 2 tokens", async () => {
    const TokenFactory = await ethers.getContractFactory("TokenFactory");
    const tokenFactory = await TokenFactory.deploy();

    await tokenFactory.deployed();
    const tokensCreated = await tokenFactory.createTokens("BTC++");


    console.log("*******", tokensCreated);
    expect(tokensCreated).to.eq("1");
  });
});