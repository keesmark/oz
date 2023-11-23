// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {MyNFT} from "../../../src/openzeppelin/token/MyNFT.sol";
import "forge-std/console.sol";

contract MyNFTTest is Test {
    MyNFT myNFT;
    address owner;

    function setUp() public {
        owner = vm.addr(1);
        myNFT = new MyNFT(owner);
    }

    function test_SafeMint() public {
        vm.prank(owner);
        address other = vm.addr(2);
        myNFT.safeMint(other);
        assertEq(myNFT.balanceOf(other), 1);

        vm.prank(vm.addr(3));
        vm.expectRevert();
        myNFT.safeMint(other);
    }

    function test_burn() public {
        vm.prank(owner);
        address other = vm.addr(2);
        myNFT.safeMint(other);
        assertEq(myNFT.balanceOf(other), 1);

        vm.prank(vm.addr(3));
        vm.expectRevert();
        myNFT.burn(0);

        vm.prank(owner);
        myNFT.burn(0);
    }
}
