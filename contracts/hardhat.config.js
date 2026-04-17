require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.3",
  networks: {
    rinkeby: {
      url: process.env.RINKEBY_URL || "",
      accounts: [process.env.PRIVATE_KEY],
    },
    localhost: {
      url: "http://127.0.0.1:8545",
    },
  },
};