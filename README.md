
# Sapphire Confidentiality Implementation

This project demonstrates a simple auction dApp built with Solidity and deployed on the Sepolia and Sapphire testnets. It leverages the confidential computing features of the Sapphire network to showcase how sensitive bid information can be protected while maintaining transparency and fairness in the auction process.

## Overview
- Confidential Bidding: Bid amounts are stored on the Sapphire network using confidential computing, preventing unauthorized parties from accessing them directly.

- Secure Bid Verification: Only the highest bidder and the seller can access bid details after the auction ends, ensuring privacy while maintaining transparency for authorized parties.

- Transparent Auction Flow: The contract manages the auction lifecycle, including tracking bids, determining the winner, and finalizing the sale.

Overall, this auction project showcases Sapphire's Confidential Computing and how it can be used to safeguard sensitive data. You can compare the output of running the script on Sepolia and Sapphire, you would see that transaction data and state data are kept private on Sapphire unlike Sepolia where it's all transparent and easily accessible.

Running this command: 
```
npx hardhat run scripts/run-auction.ts --network sapphire-testnet
```
Output would be:

``` javascript
Auction contract deployed to:  0x17a8FdB2526bd5d2049EF5D7A57ff9b54628b67f
Bidding....
Bid successful!
Checking bid at Index:  0
Failed to check bid: Auction is still ongoing
Waiting....
Auction endtime is:  1714987471n
Still waiting....
Checking bid again
Bid: Result(2) [ '0xDA01D79Ca36b493C7906F3C032D2365Fb3470aEC', 120n ]
Decoded data input:  undefined
State data at slot 0x0 is:  0x0
```
Running this for Sepolia: 
```
npx hardhat run scripts/run-auction.ts --network sepolia
```
You would get: 
```javascript 
Auction contract deployed to:  0xf1D32C3e2a084aE8694151D66DA647416ed54871
Bidding....
Bid successful!
Checking bid at Index:  0
Failed to check bid: Auction is still ongoing
Waiting....
Auction endtime is:  1714989132n
Still waiting....
Checking bid again
Bid: Result(2) [ '0xDA01D79Ca36b493C7906F3C032D2365Fb3470aEC', 120n ]
Decoded data input:  Result(0) []
State data at slot 0x0 is:  0x000000000000000000000000d109e8c395741b4b3130e3d84041f8f62af765ef
```
This is quite an interesting feature and has the potential to pave way for more real world applications and strike a balance between confidentiality and transparency in the blockchain.

## Demo 
For a more indepth explanation of this, check out my article on [Confidential Smart Contracts & Building w/Oasis Sapphire](https://dev.to/tosynthegeek/confidential-smart-contracts-building-woasis-sapphire-2kkg)
## Contributing

Contributions are always welcome!

See `contributing.md` for ways to get started.

Please adhere to this project's `code of conduct`.

