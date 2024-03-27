// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Gabaim {
    address public owner;
    address public auth1;
    address public auth2;
    address public auth3;
   

    event PersonAdded(address indexed person);
    event PersonRemoved(address indexed person);
    event Deposit(address indexed sender, uint256 amount);
    event Withdraw(address indexed recipient, uint256 amount);
    event AuthChanged(address indexed oldAuth, address indexed newAuth);

    constructor() {
        owner = msg.sender;
        auth1= address(1234);
        
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyAuthorized() {
        require(
            msg.sender == auth1 || msg.sender == auth2 || msg.sender == auth3,
            "No authorization"
        );
        _;
    }

    function addAuthorizedPerson(address _newPerson) public onlyOwner {
        require(_newPerson != address(0) && _newPerson != owner, "Invalid address");
        require(_newPerson != auth1 && _newPerson != auth2 && _newPerson != auth3, "Already authorized");
        
        if (auth1 == address(0)) {
            auth1 = _newPerson;
        } else if (auth2 == address(0)) {
            auth2 = _newPerson;
        } else if (auth3 == address(0)) {
            auth3 = _newPerson;
        } else {
            revert("All already set");
        }
        
        emit PersonAdded(_newPerson);
    }

    function removeAuthorizedPerson(address _personToRemove) public onlyOwner {
        require(_personToRemove != address(0) && _personToRemove != owner, "Invalid address");

        if (auth1 == _personToRemove) {
            auth1 = address(0);
        } else if (auth2 == _personToRemove) {
            auth2 = address(0);
        } else if (auth3 == _personToRemove) {
            auth3 = address(0);
        } else {
            revert("Address not found");
        }

        emit PersonRemoved(_personToRemove);
    }

    function changeAuthorizedPerson(address _oldPerson, address _newPerson) public onlyOwner {
        require(_oldPerson != address(0) && _oldPerson != owner, "Invalid old address");
        require(_newPerson != address(0) && _newPerson != owner, "Invalid new address");

        if (auth1 == _oldPerson) {
            auth1 = _newPerson;
        } else if (auth2 == _oldPerson) {
            auth2 = _newPerson;
        } else if (auth3 == _oldPerson) {
            auth3 = _newPerson;
        } else {
            revert("Address not found");
        }

        emit AuthChanged(_oldPerson, _newPerson);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint _amount) public payable onlyAuthorized {
        require(address(this).balance >= _amount, "Insufficient balance");
      
        payable(msg.sender).transfer(_amount);
        emit Withdraw(msg.sender, _amount);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
