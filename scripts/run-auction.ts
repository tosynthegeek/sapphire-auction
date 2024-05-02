import { ethers } from "hardhat";

async function main(value: number) {
  const address = "0xDA01D79Ca36b493C7906F3C032D2365Fb3470aEC";
  const Auction = await ethers.getContractFactory("Auction");
  const auction = await Auction.deploy(
    "0xd109e8c395741b4b3130e3d84041f8f62af765ef",
    100000,
    60 // 10 minutes for the auction duration
  );
  console.log("Auction contract deployed to: ", await auction.getAddress());

  try {
    console.log("Bidding....");
    const tx = await auction.bid({
      value: value.toString(),
    });
    await tx.wait();
    console.log("Bid successful!");
  } catch (e) {
    console.error("Error making bid:");
  }

  // Trying to get the bid of an associated address
  try {
    console.log("Checking bid for address: ", address);
    await auction.checkBid(address);
    // await auction.connect(ethers.provider).checkBid(address);
  } catch (error) {
    console.error("Failed to check bid:");
  }

  console.log("Waiting....");

  const endTime = await auction.checkAuctionEndTime();
  console.log("Auction endtime is: ", endTime);

  console.log("Still waiting....");

  try {
    await new Promise((resolve) => setTimeout(resolve, 100_000));
    console.log("Checking bid again");
    const _bid = await auction.checkBid(address);
    console.log("Bid:", _bid);
  } catch (error) {
    console.log("Omooo wetin be this?", error);
  }
}

main(120000).catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
