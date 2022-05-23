// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lotto{
    address public owner;
    address payable[] public players;

    constructor() {
        owner = msg.sender;
    }

    modifier ownerOnly() {
        require(msg.sender == owner, "Access Denied!");
        _;
    }
    modifier validAmount() {
        require(msg.value == 1 ether, "Amount should be equal to 1 ether");
        _; 
    }

    modifier minimumPlayersJoined() {
        require(players.length >= 3, "Not enough players");
        _;
    }

    //receive valid amount from players
    receive() external payable validAmount{
        //require(msg.value == 1 ether);
        players.push(payable(msg.sender));
    }

    function getBalance() public view ownerOnly returns(uint) {
        return address(this).balance;
    }

    function randomise() private view returns(uint) {
        return uint(keccak256(
            abi.encodePacked(block.difficulty, block.timestamp, players.length))
            );
    }

    function selectWinner() public ownerOnly minimumPlayersJoined {
        uint rand = randomise();
        uint index = rand % players.length;
        address payable winner = players[index];

        winner.transfer(getBalance());
        players = new address payable[](0);
    }

} 