// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@oasisprotocol/sapphire-contracts/contracts/Sapphire.sol";

contract Auction {
    // Auction details
    address payable private seller; // Address of the seller
    uint256 private startingPrice; // Starting price of the auction
    uint256 private highestBid; // Highest bid amount
    address private highestBidder; // Address of the highest bidder
    uint256 private auctionEndTime; // Timestamp when the auction ends
    bool private auctionEnded; // Flag to indicate if the auction has ended

    // Mapping to store bids of each address
    mapping(address => bytes) private bids;

    // Events for auction lifecycle
    event Bid(address bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 winningBid);

    // Constructor to initialize auction parameters
    constructor(
        address payable _seller, // Address of the seller
        uint256 _startingPrice, // Starting price of the auction
        uint256 _auctionEndTime // Duration of the auction
    ) {
        seller = _seller;
        startingPrice = _startingPrice;
        highestBid = startingPrice;
        auctionEndTime = block.timestamp + _auctionEndTime; // Set the end time of the auction
    }

    // Function for making a bid
    function bid() public payable {
        // Check if the auction has ended
        require(block.timestamp < auctionEndTime, "Auction has ended");
        // Check if the bid is higher than the current highest bid
        require(
            msg.value > highestBid,
            "Bid must be higher than the current highest bid"
        );

        // Return funds to the previous highest bidder
        if (highestBidder != address(0)) {
            payable(highestBidder).transfer(highestBid);
        }

        // Update highest bidder and bid amount
        highestBid = msg.value;
        bytes memory encrytedBid = encryptBid(highestBid, msg.sender);
        highestBidder = msg.sender;
        bids[msg.sender] = encrytedBid; // Store the bid amount for the bidder

        emit Bid(msg.sender, msg.value); // Emit Bid event
    }

    function checkBid(address _address) external view returns (uint256) {
        require(
            bids[_address].length > 0 || bids[_address][0] > 0,
            "No bid associated with address"
        );
        bytes memory value = bids[_address];
        require(block.timestamp > auctionEndTime, "Auction is still ongoing");
        require(
            msg.sender == highestBidder || msg.sender == seller,
            "Only Highest Bidder and seller can check bids"
        );
        return decryptBid(value, msg.sender);
    }

    function checkAuctionEndTime() external view returns (uint256) {
        return auctionEndTime;
    }

    // Function to end the auction and transfer funds to the seller
    function endAuction() public {
        // Check if the auction has ended
        require(block.timestamp >= auctionEndTime, "Auction is still ongoing");

        // Transfer the highest bid to the seller
        seller.transfer(highestBid);
        // Emit AuctionEnded event
        emit AuctionEnded(highestBidder, highestBid);
        auctionEnded = true; // Update auction status
    }

    // Function to withdraw funds if not the highest bidder
    function withdraw() public {
        require(block.timestamp >= auctionEndTime, "Auction is still ongoing");
        require(
            msg.sender != highestBidder,
            "The highest bidder cannot withdraw until the auction ends"
        );

        // Check if the sender has already withdrawn
        bytes memory withdrawalFlag = bids[msg.sender];
        require(withdrawalFlag.length == 0, "Funds already withdrawn");

        // Get the encrypted bid amount for the sender
        bytes memory encryptedBid = bids[msg.sender];

        // Check if there are funds available for withdrawal
        require(encryptedBid.length > 0, "No funds available for withdrawal");

        // Decrypt the bid amount before processing the withdrawal
        uint256 amount = decryptBid(encryptedBid, msg.sender);

        // Update the withdrawal flag to prevent double withdrawal
        bids[msg.sender] = abi.encodePacked(true);

        // Transfer the funds to the sender
        payable(msg.sender).transfer(amount);
    }

    function encryptBid(
        uint256 _bid,
        address _address
    ) private view returns (bytes memory) {
        bytes memory bidBytes = abi.encodePacked(_bid);
        bytes memory addressBytes = abi.encodePacked(_address);
        bytes32 key = keccak256(abi.encodePacked("Key"));
        // bytes32 nonce = bytes32(Sapphire.randomByte(32, ""));
        bytes32 nonce = keccak256(
            abi.encodePacked(blockhash(block.number - 1), msg.sender, tx.origin)
        );

        return Sapphire.encrypt(key, nonce, bidBytes, addressBytes);
    }

    function decryptBid(
        bytes memory bidByte,
        address _address
    ) private view returns (uint256) {
        bytes memory addressBytes = abi.encodePacked(_address);
        bytes32 key = keccak256(abi.encodePacked("Key"));
        // bytes32 nonce = bytes32(Sapphire.randomByte(32, ""));
        bytes32 nonce = keccak256(
            abi.encodePacked(blockhash(block.number - 1), msg.sender, tx.origin)
        );
        bytes memory decryptedBid = Sapphire.decrypt(
            key,
            nonce,
            bidByte,
            addressBytes
        );

        // Manual byte parsing for uint256 conversion
        uint256 value = 0;
        for (uint i = 0; i < decryptedBid.length; i++) {
            value =
                value +
                uint(uint8(decryptedBid[i])) *
                (2 ** (8 * (decryptedBid.length - (i + 1))));
        }

        return value;
    }

    function testMap(address _address) public view returns (bytes memory) {
        bytes memory mapTest = bids[_address];
        return mapTest;
    }
}
