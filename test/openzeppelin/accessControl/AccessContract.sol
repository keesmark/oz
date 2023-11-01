// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {AccessContract} from "../../../src/openzeppelin/accessControl/AccessContract.sol";
import "forge-std/console.sol";

contract AccessContractTest is Test {
    AccessContract accessContract;
    address owner;
    address writer;
    address member;

    function setUp() public {
        owner = vm.addr(1);
        writer = vm.addr(2);
        member = vm.addr(3);
        accessContract = new AccessContract(owner, writer);
        vm.prank(owner);
        accessContract.addMember(member);
    }

    function test_Increment() public {
        vm.prank(member);
        accessContract.increment();
        assertEq(accessContract.value(), 1);

        vm.prank(writer);
        vm.expectRevert();
        accessContract.increment();
    }

    function test_Decrement() public {
        // make it two
        vm.prank(member);
        accessContract.increment();
        vm.prank(member);
        accessContract.increment();
        // decrement it
        vm.prank(member);
        vm.expectRevert();
        accessContract.decrement();
        assertEq(accessContract.value(), 2);

        vm.prank(writer);
        accessContract.decrement();
        assertEq(accessContract.value(), 1);
    }

    function test_SetValue_OnlyOwner() public {
        // try to set value as non-owner
        vm.prank(writer);
        vm.expectRevert();
        accessContract.setValue(10);
        assertEq(accessContract.value(), 0);

        vm.prank(vm.addr(4));
        vm.expectRevert();
        accessContract.setValue(10);
        assertEq(accessContract.value(), 0);

        // set value as owner
        vm.prank(owner);
        accessContract.setValue(10);
        assertEq(accessContract.value(), 10);
    }

    function test_Grand_Role() public {
        address newMember = vm.addr(4);
        vm.prank(owner);
        accessContract.grantRole(keccak256("MEMBER_ROLE"), newMember);
        assertTrue(accessContract.hasRole(keccak256("MEMBER_ROLE"), newMember));

        vm.prank(newMember);
        accessContract.increment();
        assertEq(accessContract.value(), 1);
    }

    function test_addMember() public {
        address newMember = vm.addr(4);
        vm.prank(owner);
        accessContract.addMember(newMember);
        assertTrue(accessContract.hasRole(keccak256("MEMBER_ROLE"), newMember));

        vm.prank(newMember);
        accessContract.increment();
        assertEq(accessContract.value(), 1);
    }
}
