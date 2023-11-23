// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {MyCoin} from "../../../src/openzeppelin/token/MyCoin.sol";
import "forge-std/console.sol";

contract MyCoinTest is Test {
    MyCoin myCoin;
    address owner;

    function setUp() public {
        owner = vm.addr(1);
        myCoin = new MyCoin(owner);
        vm.prank(owner);
        myCoin.mint(owner, 1000);
    }

    function test_mint() public {
        vm.prank(owner);
        address other = vm.addr(2);
        myCoin.mint(other, 100);
        assertEq(myCoin.balanceOf(other), 100);

        vm.prank(vm.addr(3));
        vm.expectRevert();
        myCoin.mint(other, 100);
    }

    function test_transfer() public {
        vm.prank(owner);
        address other = vm.addr(2);
        myCoin.transfer(other, 100);
        assertEq(myCoin.balanceOf(other), 100);

        vm.prank(vm.addr(3));
        vm.expectRevert();
        myCoin.transfer(other, 100);
    }

    function test_transferFrom() public {
        vm.prank(owner);
        address other = vm.addr(2);
        myCoin.approve(other, 100);
        vm.prank(other);
        myCoin.transferFrom(owner, other, 100);
        assertEq(myCoin.balanceOf(other), 100);

        vm.prank(vm.addr(3));
        vm.expectRevert();
        myCoin.transferFrom(owner, other, 100);
    }
}
