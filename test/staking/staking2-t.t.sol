// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// import "src/staking/staking2.sol";
// import "foundry-huff/HuffDeployer.sol";
// import "forge-std/Test.sol";
// import "forge-std/console.sol";

// contract TestStakingRewards is Test {
//     StakingRewards rewardsContract;
//     MyToken stakingToken;
//     MyToken rewardsToken;
//     function setUp() public {
//         stakingToken = new MyToken();
//         rewardsToken = new MyToken();
//         rewardsContract = new StakingRewards(address(stakingToken), address(rewardsToken));
//     }
//     function testStake() public {
//         console.log(rewardsContract.staked());
//         stakingToken.mint(600);
//         stakingToken.approve(address(rewardsContract), 1000);
//         rewardsContract.stake(500);
//         console.log("bbb :",stakingToken.balanceOf(address(rewardsContract)));

//         assertEq(
//             rewardsContract.balances(address(this)),
//             500,
//             "Staking should increase user balance"
//         );
//         assertEq(
//             rewardsContract.staked(),
//             500,
//             "Total staked amount should increase"
//         );
//     }
//     function testWithdrawStaking() public {
//         stakingToken.mint(3000);
//         stakingToken.approve(address(rewardsContract), 3000);
//         uint amount = 900;
//         rewardsContract.stake(amount);
//         uint pullAmount = 400;
//         console.log("bbb :",stakingToken.balanceOf(address(rewardsContract)));

//         vm.warp(block.timestamp + 14 days);
//          rewardsContract.stake(300);
//         rewardsContract.getReward();
//         rewardsContract.withdraw(pullAmount);
//           console.log("bbb :",stakingToken.balanceOf(address(rewardsContract)));
//         assertEq(
//             rewardsContract.balances(address(this)),
//             amount+300-pullAmount,
//             "Withdrawal should decrease user balance"
//         );
//         assertEq(
//             rewardsContract.staked(),
//              amount+300-pullAmount,
//             "Total staked amount should decrease"
//         );
//     }
//        function testSetRewardsDuration() public {
//         rewardsContract.setRewardsDuration(14 days);
//         assertEq(
//             rewardsContract.duration(),
//             14 days,
//             "Rewards duration should be updated"
//         );
//     }
//     function testUpdateRate() public {
//         rewardsContract.updateRate(block.timestamp);
//           rewardsContract.updateRate(block.timestamp + 8 days);
//         assertEq(
//             rewardsContract.rate(),
//          (1000/rewardsContract.duration()),
//             "Reward rate should be updated"
//         );
//     }
//       function testLastTime() public {
//         uint256 currentTime = block.timestamp;
//         rewardsContract.setRewardsDuration(7 days);
//         rewardsContract.updateRate(100); // Just to make sure lastTime() considers the finish time
//         uint256 finishTime = currentTime + 7 days;
//         vm.warp(finishTime + 1); // Move time past finish time
//         assertEq(rewardsContract.lastTime(), finishTime, "Last time should be finish time");
//     }
//     function testAccumulated() public {
//         stakingToken.mint(1000);
//         stakingToken.approve(address(rewardsContract), 1000);
//         rewardsContract.stake(500);
//         rewardsContract.setRewardsDuration(7 days);
//         rewardsContract.updateRate(100);
//         uint256 initialAccumulated = rewardsContract.accumulated();

//         console.log("before",rewardsContract.accumulated());
//         vm.warp(block.timestamp + 1 days);
//         uint256 afterOneDay = rewardsContract.accumulated();
//        console.log("afterOneDay",afterOneDay);
//         assertEq(afterOneDay, initialAccumulated + 100 * 1 days, "Accumulated should increase based on rate and time");
//     }
//     function testEarned() public {
//         stakingToken.mint(1000);
//         stakingToken.approve(address(rewardsContract), 1000);
//         rewardsContract.stake(500);
//         rewardsContract.updateRate(100);
//         rewardsContract.setRewardsDuration(7 days);
//         vm.warp(block.timestamp + 1 days);
//         uint256 earnedAfterOneDay = rewardsContract.earned(address(this));
//         assertEq(earnedAfterOneDay, 100 * 1 days, "Earned should be accurate based on staked amount and accumulated rewards");
//     }
// }
