// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Auction {
    // Auction details
    address payable public seller; // Address of the seller
    uint256 public startingPrice; // Starting price of the auction
    uint256 public highestBid; // Highest bid amount
    address public highestBidder; // Address of the highest bidder
    uint256 public auctionEndTime; // Timestamp when the auction ends
    bool public auctionEnded; // Flag to indicate if the auction has ended

    // Mapping to store bids of each address
    mapping(address => uint256) private bids;

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
            payable(highestBidder).transfer(bids[highestBidder]);
        }

        // Update highest bidder and bid amount
        highestBid = msg.value;
        highestBidder = msg.sender;
        bids[msg.sender] = msg.value; // Store the bid amount for the bidder

        emit Bid(msg.sender, msg.value); // Emit Bid event
    }

    function checkBid(address _address) external view returns (uint256) {
        require(bids[_address] > 0, "No bid associated with address");
        uint256 value = bids[_address];
        require(block.timestamp > auctionEndTime, "Auction is still ongoing");
        return value;
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
        // Check if the auction has ended
        require(block.timestamp >= auctionEndTime, "Auction is still ongoing");
        // Check if the sender is not the highest bidder
        require(
            msg.sender != highestBidder,
            "The highest bidder cannot withdraw until the auction ends"
        );

        // Get the bid amount of the sender
        uint256 amount = bids[msg.sender];
        // Check if there are funds available for withdrawal
        require(amount > 0, "No funds available for withdrawal");

        // Reset the bid amount of the sender to prevent double withdrawal
        bids[msg.sender] = 0;
        // Transfer the funds to the sender
        payable(msg.sender).transfer(amount);
    }
}
