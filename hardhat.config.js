require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
const { ALCHEMY_API_KEY, PRIVATE_KEY } = process.env;
module.exports = {
  solidity: "0.8.9",
  networks: {
    matic: {
      url: "https://polygon-mainnet.g.alchemy.com/v2/" + ALCHEMY_API_KEY, 
      //Alchemy url with projectID(of matic)
      accounts: [PRIVATE_KEY]
      //add the account that will deploy the contract
    },
  }
};
