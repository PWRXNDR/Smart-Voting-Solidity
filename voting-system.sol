// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract VotingSystem {
    address public owner;
    uint256 public startTime;
    uint256 public endTime;
    bool public votingCompleted;

    enum Choice { ParliamentA, ParliamentB }
    mapping(address => bool) public hasVoted;
    mapping(Choice => uint256) public votes;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier withinVotingPeriod() {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Voting not active");
        _;
    }

    modifier afterVotingPeriod() {
        require(block.timestamp > endTime, "Voting still active");
        _;
    }

    constructor(uint256 _votingDuration) {
        owner = msg.sender;
        startTime = block.timestamp;
        endTime = block.timestamp + _votingDuration;
    }

    function vote(Choice _choice) external withinVotingPeriod {
        require(!hasVoted[msg.sender], "Already voted");
        hasVoted[msg.sender] = true;
        votes[_choice]++;
    }

    function getResults() external view afterVotingPeriod returns (uint256 parliamentAVotes, uint256 parliamentBVotes) {
        require(votingCompleted, "Voting not completed");
        parliamentAVotes = votes[Choice.ParliamentA];
        parliamentBVotes = votes[Choice.ParliamentB];
    }

    function endVoting() external onlyOwner afterVotingPeriod {
        votingCompleted = true;
    }
}
