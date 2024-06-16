// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Raed_Wtite {
    uint256 public num;

    function set(uint256 _num) public {
        num = _num;
    }

    function get() public view returns (uint256) {
        return num;
    }
}
