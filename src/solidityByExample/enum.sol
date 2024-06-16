// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Enum {
    enum Status {
        Aaa,
        Bbb,
        Ccc
    }

    Status public status;

    function get() public view returns (Status) {
        return status;
    }

    function set(Status s) public {
        status = s;
    }

    function cancel() public {
        //   status = Status.Canceled;
    }

    function reset() public {
        delete status;
    }
}
