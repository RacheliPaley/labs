// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Variables {
    // State
    string public text = "Hello";
    uint256 public num = 123;

    function doSomething() public {
        // Local
        uint256 i = 456;

        //Global
        uint256 timestamp = block.timestamp;
        address sender = msg.sender;
    }
}
