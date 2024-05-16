import { HardhatUserConfig } from "hardhat/config";
import "@oasisprotocol/sapphire-hardhat";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config();

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    "sapphire-testnet": {
      url: "https://testnet.sapphire.oasis.io",
      accounts: [
        process.env.PRIVATE_KEY,
      ],
      chainId: 0x5aff,
    },
    sepolia: {
      url: process.env.ALCHEMY_API_KEY_URL,
      accounts: [
        process.env.PRIVATE_KEY,
      ],
    },
  },
};

export default config;
