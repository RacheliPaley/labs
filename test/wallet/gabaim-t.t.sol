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
        payable(address(gabaim)).transfer(1000);
     
    }
    
    // function testAddAuthorizedPerson() public {
    //     // Arrange
      
    //     address newPerson2 = address(0x124);
    //     address newPerson3 = address(0x125);
        
    //     // Act
     
    //     gabaim.addAuthorizedPerson(newPerson2);
     
        
    //     // Assert
    //     vm.expectRevert('you can add only 3 gabaim');
    //     gabaim.addAuthorizedPerson(newPerson2);
    // }

    function testDeposit() public {
      
      address addr =vm.addr(12345);
      uint ammount =200;
    
      uint balanceBeforeDeposit = address(gabaim).balance;
     vm.prank(addr);
      vm.deal(address(addr), ammount);
      
      payable(address(gabaim)).transfer(ammount);
    uint  balanceAfterDeposit = address(gabaim).balance;
    console.log(balanceBeforeDeposit + ammount);
    console.log(balanceAfterDeposit);
      assertEq(balanceAfterDeposit, balanceBeforeDeposit + ammount, "Deposit not added to wallet");
      vm.stopPrank();

    }
    

    function testWithdraw() external {
        uint sum = 100;
      
        address adr1= address(1234);
        
        // payable(address(gabaim)).transfer(balance);
    
        vm.prank(adr1);
        uint before = address(gabaim).balance;
        gabaim.withdraw(sum);
        console.log(before);
      
       uint afterwithdraw = address(gabaim).balance;
       console.log(afterwithdraw);
       assertEq(afterwithdraw, before - sum);
        vm.stopPrank();
    }

    function testWithdrawNotMoney() external {
       uint sum = 2000;
      
        address adr1= address(1234);
        
        // payable(address(gabaim)).transfer(balance);
    
        vm.prank(adr1);
        uint before = address(gabaim).balance;
        
        if (before >= sum) {
        gabaim.withdraw(sum);
        uint afterwithdraw = address(gabaim).balance;
        assertEq(afterwithdraw, before - sum);
        }
        vm.stopPrank();
       
    }
      function testNotOwnerWithdraw() public {
        payable(address(gabaim)).transfer(100);
       
        gabaim.withdraw(100);
    }
}
