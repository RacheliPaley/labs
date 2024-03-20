// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Gabaim {
    address public owner;
    address public authorizedPerson1;
    address public authorizedPerson2;
    address public authorizedPerson3;
    uint public balance;

    event PersonAdded(address indexed person);
    event PersonRemoved(address indexed person);
    event Deposit(address indexed sender, uint256 amount);
    event Withdraw(address indexed recipient, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyAuthorized() {
        require(
            msg.sender == authorizedPerson1 || msg.sender == authorizedPerson2 || msg.sender == authorizedPerson3,
            "You are not authorized to withdraw."
        );
        _;
    }

    function addAuthorizedPerson(address _newPerson) public onlyOwner {
        require(_newPerson != address(0) && _newPerson != owner, "Invalid address");
        require(_newPerson != authorizedPerson1 && _newPerson != authorizedPerson2 && _newPerson != authorizedPerson3, "Address already authorized");
        
        if (authorizedPerson1 == address(0)) {
            authorizedPerson1 = _newPerson;
        } else if (authorizedPerson2 == address(0)) {
            authorizedPerson2 = _newPerson;
        } else if (authorizedPerson3 == address(0)) {
            authorizedPerson3 = _newPerson;
        } else {
            revert("All authorized persons are already set");
        }
        
        emit PersonAdded(_newPerson);
    }

    receive() external payable {
        balance += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint _amount) public payable onlyAuthorized {
        require(balance >= _amount, "Insufficient funds");
        balance -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Withdraw(msg.sender, _amount);
    }

    function getBalance() public view returns (uint) {
        return balance;
    }
}
