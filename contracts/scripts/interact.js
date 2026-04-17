// scripts/interact.js
const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  const rinkebyRpc = process.env.RINKEBY_URL;
  const privateKey = process.env.PRIVATE_KEY;

  // Replace with your deployed contract addresses
  const rouletteAddress = "YOUR_ROULETTE_CONTRACT_ADDRESS";
  const blackjackAddress = "YOUR_BLACKJACK_CONTRACT_ADDRESS";
  const slotMachineAddress = "YOUR_SLOT_MACHINE_CONTRACT_ADDRESS";

  const roulette = await ethers.getContractAt("Roulette", rouletteAddress);
  const blackjack = await ethers.getContractAt("Blackjack", blackjackAddress);
  const slotMachine = await ethers.getContractAt("SlotMachine", slotMachineAddress);

  // Example interaction: Place a bet on roulette
  await roulette.placeBet(5, 7, { value: ethers.utils.parseEther("0.01") });
  console.log("Placed roulette bet");

  // Spin roulette (owner only)
  // await roulette.spinWheel();
  // console.log("Spun the roulette wheel");

  // Withdraw winnings
  // await roulette.cashOut();
  // console.log("Withdrew roulette winnings");

  // Similar interactions for blackjack and slot machine
  // e.g.,
  // await blackjack.placeBet(50);
  // await blackjack.hit();
  // await blackjack.stand();

  // For slot machine, implement similar functions
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });