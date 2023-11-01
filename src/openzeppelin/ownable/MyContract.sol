// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MyContract is Ownable {
    uint256 public value;

    constructor(address initialOwner) Ownable(initialOwner) {
        value = 0;
    }

    function increment() external {
        value++;
    }

    function decrement() external {
        require(value > 0, "Value cannot be negative");
        value--;
    }

    function setValue(uint256 _value) external onlyOwner {
        value = _value;
    }
}
