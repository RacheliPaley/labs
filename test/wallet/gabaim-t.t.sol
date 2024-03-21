pragma solidity ^0.8.20;

import "@hack/wallet/gabaim.sol";
import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract GabaimTest is Test {
    Gabaim public gabaim;

    /// @dev Setup the testing environment.
    function setUp() public {
        gabaim = new Gabaim();
       
     
    }

    function testDepositAndWithdraw() public {
        // Deposit 100
        uint256 initialBalance = address(gabaim).balance;
        uint256 depositAmount = 100 wei;
        payable(address(gabaim)).transfer(depositAmount);
        assertEq(address(gabaim).balance, initialBalance + depositAmount, "Contract balance should increase by deposit amount");

        // Withdraw 50
        uint256 withdrawAmount = 50 wei;
        uint256 balanceBeforeWithdraw = gabaim.getBalance();
        gabaim.withdraw(withdrawAmount);
        uint256 balanceAfterWithdraw = gabaim.getBalance();
        assertEq(balanceBeforeWithdraw - withdrawAmount, balanceAfterWithdraw, "Balance should decrease after withdrawal");

        // Attempt to withdraw more than the balance
        withdrawAmount = balanceAfterWithdraw + 100 wei;
        (bool success, ) = address(gabaim).call{value: withdrawAmount}("");
        assertEq(success, false, "Withdrawal should fail if trying to withdraw more than the balance");
    }

    function testOnlyAuthorized() public {
        // Add an authorized person
        address auth = address(0x123);
        gabaim.addAuthorizedPerson(auth);

        // Attempt to withdraw by an unauthorized user
        (bool success, ) = auth.call{value: 50 wei}("");
        assertEq(success, false, "Unauthorized user should not be able to withdraw");
    }
}
