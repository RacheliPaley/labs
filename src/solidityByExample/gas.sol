// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Gas {
    uint256 i = 1;

    function forever() public {
        while (true) {
            i++;
        }
    }
}
