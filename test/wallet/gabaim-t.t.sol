pragma solidity ^0.8.20;

import "@hack/wallet/gabaim.sol";
import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract GabaimTest is Test {
    Gabaim public gabaim;

    // Setup the testing environment.
    function setUp() public {
        gabaim = new Gabaim();
    }
    
    function testAddAuthorizedPerson() public {
        // Arrange
        address newPerson1 = address(0x123);
        address newPerson2 = address(0x124);
        address newPerson3 = address(0x125);
        
        // Act
        gabaim.addAuthorizedPerson(newPerson1);
        gabaim.addAuthorizedPerson(newPerson2);
        gabaim.addAuthorizedPerson(newPerson3);
        
        // Assert
        vm.expectRevert('you can add only 3 gabaim');
        gabaim.addAuthorizedPerson(newPerson1);
    }

    function testDeposit() public {
        // Arrange
        uint balanceBeforeDeposit = gabaim.getBalance();
        uint depositAmount = 10000000;

        // Act
        (bool success, ) = address(gabaim).call{value: depositAmount}("");
        require(success, "Deposit failed: Insufficient funds");

        // Assert
        uint balanceAfterDeposit = gabaim.getBalance();
        assertEq(balanceAfterDepos
