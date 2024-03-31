
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
    
    function testAddAuthorizedPerson(address newGabai) external {
        console.log(newGabai);
       
        if (gabaim.auth1() == newGabai || gabaim.auth2() == newGabai || gabaim.auth3() == newGabai) {
            vm.expectRevert("The gabai already exists");
        } else if (gabaim.auth1() == address(0)) {
            gabaim.addAuthorizedPerson(newGabai);
        } else if (gabaim.auth2() == address(0)) {
            gabaim.addAuthorizedPerson(newGabai);
        } else if (gabaim.auth3() == address(0)) {
            gabaim.addAuthorizedPerson(newGabai);
        } else {
            vm.expectRevert("There are already 3 gabaim");
        }
    }

   

    function testDeposit(uint8 amount) public {
     
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

    function testWithdraw(uint8 _amount) external {
        
        // Mock an authorized address using vm.Prank
        address adr1 = address(1234);
        console.log(_amount);
    
        vm.startPrank(adr1); 

        if(adr1 == gabaim.auth1()||adr1 == gabaim.auth2() ||adr1 == gabaim.auth3())
        {
            assertLt(_amount ,address(gabaim).balance, "Withdrawal amount exceeds contract balance");

        
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
}



