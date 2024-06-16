// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract If_Else {
    function foo(uint256 x) public pure returns (uint256) {
        if (x < 0) {
            return 0;
        } else if (x < 20) {
            return 1;
        } else {
            return 2;
        }
    }

    function foo2(uint256 x) public pure returns (uint256) {
        x < 20 ? 0 : 1;
    }
}
