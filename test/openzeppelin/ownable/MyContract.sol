// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {MyContract} from "../../../src/openzeppelin/ownable/MyContract.sol";
import "forge-std/console.sol";

contract MyContractTest is Test {
    MyContract myContract;
    address owner;

    // ownable errors
    error OwnableUnauthorizedAccount(address account);

    function setUp() public {
        owner = vm.addr(1);
        myContract = new MyContract(owner);
    }

    function test_Increment() public {
        myContract.increment();
        assertEq(myContract.value(), 1);
    }

    function test_Decrement() public {
        // make it two
        myContract.increment();
        myContract.increment();

        // decrement it
        myContract.decrement();
        assertEq(myContract.value(), 1);
    }

    function test_SetValue_OnlyOwner() public {
        // try to set value as non-owner
        vm.prank(vm.addr(2));
        vm.expectRevert();
        myContract.setValue(10);

        // set value as owner
        vm.prank(owner);
        myContract.setValue(10);
        assertEq(myContract.value(), 10);
    }
}
