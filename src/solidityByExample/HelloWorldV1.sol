pragma solidity ^0.8.13;

contract HelloWorldV1 {
    string public text = "hello world";

    function setText(string memory _text) public {
        text = _text;
    }
}
