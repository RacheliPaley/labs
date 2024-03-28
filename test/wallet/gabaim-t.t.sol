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
        payable(address(gabaim)).transfer(10000);
    }
    
    function testAddAuthorizedPerson(address newGabai) external {
       
        if (gabaim.auth1() == newGabai || gabaim.auth2() == newGabai || gabaim.auth3() == newGabai) {
            vm.expectRevert("The gabai already exists");
        } else if (gabaim.auth1() == address(0)) {
            gabaim.addAuthorizedPerson(newGabai);
        } else if (gabaim.auth2() == address(0)) {
            gabaim.addAuthorizedPerson(newGabai);
        } else if (gabaim.auth3() == address(0)) {
            gabaim.addAuthorizedPerson(newGabai);
        } else {
            vm.expectRevert("There are already 3 gabaiim");
        }
    }

    function testChangeAuthSuccess() external {
        address newPerson = address(0x123);
        gabaim.changeAuthorizedPerson(address(1234), newPerson);
        console.log(gabaim.auth1());
        assertEq(gabaim.auth1(), newPerson, "Auth1 was not changed successfully");
    }

    function testChangeAuthFail() external {
        address wrong = address(11111);
        address newPerson = address(0x123);
        vm.expectRevert();
        gabaim.changeAuthorizedPerson(wrong, newPerson);
        assertEq(gabaim.auth1(), newPerson, "Auth1 was not changed successfully");
    }

    function testDeposit(uint32 amount) public {
         vm.assume(amount > 0); 
        address addr = vm.addr(12345);
       
        console.log(amount);
        uint balanceBeforeDeposit = address(gabaim).balance;
        vm.prank(addr);
        vm.deal(address(addr), amount);
        payable(address(gabaim)).transfer(amount);
        uint balanceAfterDeposit = address(gabaim).balance;
        console.log(balanceBeforeDeposit + amount);
        console.log(balanceAfterDeposit);
        assertEq(balanceAfterDeposit, balanceBeforeDeposit + amount, "Deposit not added to wallet");
        vm.stopPrank();
    }

    // function testWithdraw(uint32 amount) external {
    //     console.log(amount);
    //     vm.assume(amount < 10000); 

    //     console.log(amount);
    //     address adr1 = address(1234);
    //     vm.prank(adr1);
    //     uint before = address(gabaim).balance;
    //     gabaim.withdraw(amount);
    //     console.log(before);
    //     uint afterwithdraw = address(gabaim).balance;
    //     console.log(afterwithdraw);
    //     assertEq(afterwithdraw, before - amount, "opps");
    //     vm.stopPrank();
    // }
    function testWithdrawConditions(uint256 _amount) external {
    // Mock an authorized address using vm.Prank
   
      address adr1 = address(1234);
      console.log(msg.sender);
    vm.startPrank(adr1); // Replace auth1 with the appropriate authorized address


console.log(msg.sender);
console.log(_amount);

   if(adr1 == gabaim.auth1()||adr1 == gabaim.auth2() ||adr1 == gabaim.auth3())
   {
    assertLt(_amount ,address(gabaim).balance, "Withdrawal amount exceeds contract balance");

    // Check if the withdrawal amount is greater than zero
    assertGt(_amount , 0, "Withdrawal amount must be greater than zero");

    uint before = address(gabaim).balance;
        gabaim.withdraw(_amount);
        console.log(before);
        uint afterwithdraw = address(gabaim).balance;
        console.log(afterwithdraw);
        assertEq(afterwithdraw, before - _amount, "opps");
   }
   else
   {
    vm.expectRevert();
      uint before = address(gabaim).balance;
        gabaim.withdraw(_amount);
        console.log(before);
        uint afterwithdraw = address(gabaim).balance;
        console.log(afterwithdraw);
        assertEq(afterwithdraw, before - _amount, "opps");
   }
        vm.stopPrank();
}

    // function testWithdrawNotMoney(uint32 amount) external {
      
    //     address adr1 = address(1234);
    //     vm.prank(adr1);
    //     uint before = address(gabaim).balance;
    //     if (before >= amount) {
    //         gabaim.withdraw(amount);
    //         uint afterwithdraw = address(gabaim).balance;
    //         assertEq(afterwithdraw, before - amount);
    //     }
    //     vm.stopPrank();
    // }

    // function testNotOwnerWithdraw() public {
    //     uint sum = 100;
    //     address adr1 = address(1234666);
    //     vm.expectRevert();
    //     vm.prank(adr1);
    //     uint before = address(gabaim).balance;
    //     console.log(before);
    //     gabaim.withdraw(sum);
    //     uint afterwithdraw = address(gabaim).balance;
    //     console.log(afterwithdraw);
    //     assertEq(afterwithdraw, before - sum);
    //     vm.stopPrank();
    // }
}
