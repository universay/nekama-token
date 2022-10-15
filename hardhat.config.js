require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();

/** @type import('hardhat/config').HardhatUserConfig */
const { ALCHEMY_API_KEY, PRIVATE_KEY } = process.env;
module.exports = {
  solidity: "0.8.9",
  defaultNetwork: "polygon",
  networks: {
    hardhat: {
    },
    polygon: {
      url: "https://polygon-mainnet.g.alchemy.com/v2/" + ALCHEMY_API_KEY, 
      accounts: [PRIVATE_KEY]
    }
  }
};
