// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrowdFund {
    address public owner;
    uint public goalAmount;
    uint public totalRaised;
    uint public deadline;
    mapping(address => uint) public contributions;

    constructor(uint _goalAmount, uint _durationInDays) {
        owner = msg.sender;
        goalAmount = _goalAmount;
        deadline = block.timestamp + (_durationInDays * 1 days);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    modifier beforeDeadline() {
        require(block.timestamp <= deadline, "Deadline passed");
        _;
    }

    function contribute() public payable beforeDeadline {
        require(msg.value > 0, "Contribution must be greater than 0");
        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function withdraw() public onlyOwner {
        require(block.timestamp > deadline, "Crowdfunding still active");
        require(totalRaised >= goalAmount, "Funding goal not met");
        payable(owner).transfer(address(this).balance);
    }
}

