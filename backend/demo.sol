// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SynVote {
    // Structure to hold details of a candidate
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    // Structure to hold details of a voting room
    struct VotingRoom {
        string name;
        mapping(uint256 => Candidate) candidates;
        uint256 candidateCount;
        mapping(address => bool) hasVoted;
    }

    // Mapping to store all voting rooms by their ID
    mapping(uint256 => VotingRoom) public votingRooms;
    uint256 public votingRoomCount;

    // Address of the contract owner
    address public owner;

    // Event to emit when a new voting room is created
    event VotingRoomCreated(uint256 roomId, string name);

    // Event to emit when a new candidate is added
    event CandidateAdded(uint256 roomId, uint256 candidateId, string name);

    // Event to emit when a vote is cast
    event VoteCast(address voter, uint256 roomId, uint256 candidateId);

    // Modifier to restrict certain functions to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        // Set the contract deployer as the owner
        owner = msg.sender;
    }

    // Function to create a new voting room
    function createVotingRoom(string memory name) public onlyOwner {
        votingRoomCount++;
        votingRooms[votingRoomCount].name = name;

        emit VotingRoomCreated(votingRoomCount, name);
    }

    // Function to add a candidate to a voting room
    function addCandidate(uint256 roomId, string memory name) public onlyOwner {
        // Require valid Room ID
        require(roomId > 0 && roomId <= votingRoomCount, "Invalid voting room ID");

        VotingRoom storage room = votingRooms[roomId];
        room.candidateCount++;
        room.candidates[room.candidateCount] = Candidate({name: name, voteCount: 0});

        emit CandidateAdded(roomId, room.candidateCount, name);
    }

    // Function to vote for a candidate in a voting room
    function vote(uint256 roomId, uint256 candidateId) public {
        require(roomId > 0 && roomId <= votingRoomCount, "Invalid voting room ID");

        VotingRoom storage room = votingRooms[roomId];

        require(candidateId > 0 && candidateId <= room.candidateCount, "Invalid candidate ID");
        require(!room.hasVoted[msg.sender], "You have already voted in this room");

        room.candidates[candidateId].voteCount++;
        room.hasVoted[msg.sender] = true;

        emit VoteCast(msg.sender, roomId, candidateId);
    }

    // Function to get the details of a candidate in a voting room
    function getCandidate(uint256 roomId, uint256 candidateId) public view returns (string memory name, uint256 voteCount) {
        require(roomId > 0 && roomId <= votingRoomCount, "Invalid voting room ID");

        VotingRoom storage room = votingRooms[roomId];
        require(candidateId > 0 && candidateId <= room.candidateCount, "Invalid candidate ID");

        Candidate storage candidate = room.candidates[candidateId];
        return (candidate.name, candidate.voteCount);
    }

    // Function to get the details of a voting room
    function getVotingRoom(uint256 roomId) public view returns (string memory name, uint256 candidateCount) {
        require(roomId > 0 && roomId <= votingRoomCount, "Invalid voting room ID");

        VotingRoom storage room = votingRooms[roomId];
        return (room.name, room.candidateCount);
    }
}
