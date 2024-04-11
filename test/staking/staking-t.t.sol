//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "src/staking/staking.sol";
import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
// /root/labs/src/staking/staking.sol
contract TestReward is Test {
    Reward_4_7 reward;
    function setUp() public {
        reward = new Reward_4_7();
    }
    function testOwnerInitiallySet() public {
        console.log(reward.balanceOf(address(reward)));
    }
    function testInitialBalance() public {
        console.log(address(reward).balance);
        assertEq(
            reward.balanceOf(address(reward)),
            1000000,
            "Initial balance should be 1 million tokens"
        );
    }
    function testDeposit() public {
        uint initialBalance = reward.balanceOf(address(reward));
        address adr1 = address(1234);
        vm.startPrank(adr1);
        reward.mint(200);
        reward.approve(adr1, 100);
        reward.deposit(100);
        uint newBalance = reward.balanceOf(address(reward));
        assertEq(
            newBalance - initialBalance,
            100,
            "Deposit should increase balance by 100 tokens"
        );
        vm.stopPrank();
    }
    // function testCalcRewards() public {
    //     uint rewards = reward.calcRewards(100);
    //     assertEq(rewards, 2000, "Rewards calculation should be accurate");
    // }
    function testwithdrawFromBalance() public {
        address adr1 = address(1234);
        vm.startPrank(adr1);
        reward.approve(adr1, 50);
        reward.mint(200);
        reward.withdraw(50);
        vm.expectRevert(
            "Insufficient available amount for withdrawal with rewards"
        );
           vm.stopPrank();
    }
        // uint initialBalance = reward.balanceOf(address(reward));
        // reward.deposit(100);
        // uint balanceWithDeposit = reward.balanceOf(address(reward));
        // uint amountToWithdraw = 50;
        // reward.withdraw(amountToWithdraw);
        // uint finalBalance = reward.balanceOf(address(reward));
        // assertEq(
        //     finalBalance - initialBalance,
        //     100,
        //     "Withdrawal should not affect the initial balance"
        // );
        // assertEq(
        //     finalBalance - balanceWithDeposit,
        //     -50,
        //     "Withdrawal should reduce the balance by 50 tokens"
        // );
    // }
        function testGetBalanceWithReward() public {
          address adr2 = address(1234);
        vm.startPrank(adr2);
        reward.mint(200);
        reward.approve(adr2, 100);
        reward.deposit(100);
            uint balanceWithReward = reward.getBalanceWithReward(adr2);
           assertEq(balanceWithReward, 0, "Balance with reward should be accurate");
        }
    //     function testGetTotalBalance() public {
    //         reward.deposit(100);
    //         uint totalBalance = reward.getTotalBalance(address(this));
    //       assertEq(totalBalance, 100, "Total balance should include deposited amount");
    //     }
}