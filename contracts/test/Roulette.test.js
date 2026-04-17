const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Roulette", function () {
  let roulette, owner, addr1;

  before(async () => {
    const Roulette = await ethers.getContractFactory("Roulette");
    roulette = await Roulette.deploy();
    await roulette.deployed();

    [owner, addr1] = await ethers.getSigners();
  });

  it("Should allow betting and spin", async () => {
    await roulette.connect(addr1).placeBet(5, 10, { value: ethers.utils.parseEther("0.01") });
    await expect(roulette.spinWheel()).to.emit(roulette, "RandomNumber");
  });

  it("Should allow withdrawal", async () => {
    await roulette.connect(addr1).cashOut();
  });
});