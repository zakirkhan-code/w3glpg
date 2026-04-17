const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Blackjack", function () {
  let blackjack, owner, player;

  before(async () => {
    const Blackjack = await ethers.getContractFactory("Blackjack");
    blackjack = await Blackjack.deploy();
    await blackjack.deployed();

    [owner, player] = await ethers.getSigners();
  });

  it("Should place bet and deal", async () => {
    await blackjack.connect(player).placeBet(50, { value: ethers.utils.parseEther("1") });
    // Test hitting
    await blackjack.connect(player).hit();
    // Test standing
    await blackjack.connect(player).stand();
  });

  it("Should cash out", async () => {
    await blackjack.connect(player).cashOut();
  });
});