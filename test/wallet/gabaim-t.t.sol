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
        uint depositAmount = 10000000 ;

        // Act
        (bool success, ) = address(gabaim).call{value: depositAmount}("");
        require(success, "Deposit failed: Insufficient funds");

        // Assert
        uint balanceAfterDeposit = gabaim.getBalance();
        assertEq(balanceAfterDeposit, balanceBeforeDeposit + depositAmount, "Deposit amount not added to balance");
    }

    function testWithdraw() public {
        uint sum = 100;
        uint balance = 150;
        payable(address(gabaim)).transfer(balance);
        gabaim.addAuthorizedPerson(vm.addr(1));
        vm.prank(vm.addr(1));
        gabaim.withdraw(sum);
        assertEq(gabaim.getBalance(), balance - sum);
        vm.stopPrank();
    }

    function testWithdrawNotMoney() public {
        // Arrange
        uint sum = 100;
        uint balance = 50;
        payable(address(gabaim)).transfer(balance);
        gabaim.addAuthorizedPerson(vm.addr(1));
        vm.prank(vm.addr(1));

        // Act
        bool successBeforeWithdraw;
        uint balanceBeforeWithdraw = gabaim.getBalance();
        (successBeforeWithdraw, ) = address(gabaim).call{value: balance}("");
        bool successWithdraw;
        (successWithdraw, ) = address(gabaim).call{value: sum}("");
        uint balanceAfterWithdraw = gabaim.getBalance();

        // Assert
        require(successBeforeWithdraw, "Deposit failed: Insufficient funds");
        require(!successWithdraw, "Withdrawal should fail if trying to withdraw more than the balance");
        assertEq(balanceAfterWithdraw, balance, "Balance should remain unchanged after failed withdrawal attempt");
    }
      function testNotOwner() public {
        payable(address(gabaim)).transfer(100);
        vm.expectRevert('Wallet not mainOwner');
        vm.prank(vm.addr(1));
        gabaim.withdraw(100);
    }
}
