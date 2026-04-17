const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SlotMachine", function () {
  let slot, owner, addr1;

  before(async () => {
    const SlotMachine = await ethers.getContractFactory("SlotMachine");
    slot = await SlotMachine.deploy();
    await slot.deployed();

    [owner, addr1] = await ethers.getSigners();
  });

  it("Should spin and possibly win", async () => {
    await slot.connect(addr1).spin({ value: ethers.utils.parseEther("0.01") });
  });
});