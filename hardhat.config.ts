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
        "7cf14cea97ee9ace52e647f282686ef9bd32c5fd686272190520289905885293",
      ],
      chainId: 0x5aff,
    },
    sepolia: {
      url: process.env.ALCHEMY_API_KEY_URL,
      accounts: [
        "7cf14cea97ee9ace52e647f282686ef9bd32c5fd686272190520289905885293",
      ],
    },
  },
};

export default config;
