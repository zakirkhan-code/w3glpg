const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  const W3GLToken = await ethers.getContractFactory("W3GLToken");
  const token = await W3GLToken.deploy(1000000); // 1 million tokens
  await token.deployed();
  console.log("W3GLToken deployed at:", token.address);

  const Roulette = await ethers.getContractFactory("Roulette");
  const roulette = await Roulette.deploy();
  await roulette.deployed();
  console.log("Roulette deployed at:", roulette.address);

  const Blackjack = await ethers.getContractFactory("Blackjack");
  const blackjack = await Blackjack.deploy();
  await blackjack.deployed();
  console.log("Blackjack deployed at:", blackjack.address);

  const SlotMachine = await ethers.getContractFactory("SlotMachine");
  const slot = await SlotMachine.deploy();
  await slot.deployed();
  console.log("Slot Machine deployed at:", slot.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });