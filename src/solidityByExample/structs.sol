// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Struct {
    struct Todo {
        string text;
        bool complete;
    }

    Todo[] public todos;

    function add(string calldata _text) public {
        todos.push(Todo(_text, false));
        todos.push(Todo({text: _text, complete: false}));

        Todo memory t;
        t.text = _text;
        todos.push(t);
    }

    function get(uint256 index) public view returns (Todo memory) {
        return todos[index];
    }

    function update(uint256 index, string memory _text) public {
        todos[index].text = _text;
    }

    function updateComleted(uint256 index) public {
        bool b = todos[index].complete;
        todos[index].complete = !b;
    }
}
