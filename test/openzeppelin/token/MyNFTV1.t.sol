// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {MyNFTV1} from "../../../src/openzeppelin/token/MyNFTV1.sol";
import {MyNFTV2} from "../../../src/openzeppelin/token/MyNFTV2.sol";
import {UUPSProxy} from "../../../src/openzeppelin/proxy/UUPSProxy.sol";
import "forge-std/console.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";

contract MyNFTTest is Test {
    MyNFTV1 myNFTV1;
    address owner;
    UUPSProxy uupsProxy;

    function setUp() public {
        owner = vm.addr(1);
        bytes memory initData = abi.encodeCall(MyNFTV1.initialize, owner);
        uupsProxy = new UUPSProxy(address(new MyNFTV1()), initData);
        myNFTV1 = MyNFTV1(address(uupsProxy));
    }

    function test_SafeMint() public {
        vm.prank(owner);
        address other = vm.addr(2);
        myNFTV1.safeMint(other);
        assertEq(myNFTV1.balanceOf(other), 1);

        vm.prank(vm.addr(3));
        vm.expectRevert();
        myNFTV1.safeMint(other);
    }

    function test_burn() public {
        vm.prank(owner);
        address other = vm.addr(2);
        myNFTV1.safeMint(other);
        assertEq(myNFTV1.balanceOf(other), 1);

        vm.prank(vm.addr(3));
        vm.expectRevert();
        myNFTV1.burn(0);

        vm.prank(owner);
        myNFTV1.burn(0);
    }

    function test_upgrade() public {
        vm.startPrank(owner);
        address other = vm.addr(2);
        myNFTV1.safeMint(other);
        assertEq(myNFTV1.balanceOf(other), 1);

        myNFTV1.upgradeToAndCall(address(new MyNFTV2()), "");

        address proxy = address(uupsProxy);
        MyNFTV2 myNFTV2 = MyNFTV2(proxy);

        assertEq(myNFTV2.balanceOf(other), 1);
        assertEq(owner, myNFTV2.owner());

        myNFTV2.safeMint(other);
        assertEq(myNFTV2.balanceOf(other), 2);
    }
}
