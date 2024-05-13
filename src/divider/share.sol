// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Wallet {
    event Deposit(address indexed sender, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);
    
    address private owner;

address[] public addresses = [
    0x5C3B01156A4029D1050Cd35bBB00CE3007B077eB
];
    constructor() {
        owner = msg.sender;
    }
    
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function distribute( uint amount) public payable {
        require(msg.sender == owner, "Only the owner can distribute funds");
        require(addresses.length > 0, "Please specify recipients");
        uint256 amountPerRecipient = amount / addresses.length;
        require(amountPerRecipient > 0, "The amount per recipient is too low");
        
        for (uint i = 0; i < addresses.length; i++) {
            payable(address(addresses[i])).transfer(amountPerRecipient);
        }
    }
}