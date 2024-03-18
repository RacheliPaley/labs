// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ThreePersonWallet {
    address public owner;
    address private  person1;
    address private  person2;
    address private  person3;
    uint public balance;

    event PersonAdded(address indexed person);
    event PersonRemoved(address indexed person);
    event PersonChanged(address indexed oldPerson, address indexed newPerson);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyAuthorized() {
        require(
            msg.sender == person1 || msg.sender == person2 || msg.sender == person3,
            "You are not authorized to withdraw."
        );
        _;
    }

function setPerson1(address _newPerson) public onlyOwner {
    require(_newPerson != address(0) && _newPerson != owner && _newPerson != person2 && _newPerson != person3, "Invalid address");
    
    person1 = _newPerson;
    emit PersonChanged(person1, _newPerson);
}

function setPerson2(address _newPerson) public onlyOwner {
    require(_newPerson != address(0) && _newPerson != owner && _newPerson != person1 && _newPerson != person3, "Invalid address");
    
    person2 = _newPerson;
    emit PersonChanged(person2, _newPerson);
}

function setPerson3(address _newPerson) public onlyOwner {
    require(_newPerson != address(0) && _newPerson != owner && _newPerson != person1 && _newPerson != person2, "Invalid address");
    
    person3 = _newPerson;
    emit PersonChanged(person3, _newPerson);
}
    function deposit() public payable {
        balance += msg.value;
    }

    function withdraw(uint _amount) public onlyAuthorized {
        require(balance >= _amount, "Insufficient funds");
        balance -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    function getBalance() public view returns (uint) {
        return balance;
    }

    
}
