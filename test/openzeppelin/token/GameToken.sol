// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test} from "forge-std/Test.sol";
import {GameItems} from "../../../src/openzeppelin/token/GameItems.sol";

contract GameItemsTest is Test {
    GameItems gameItems;
    address owner;
    uint256 GOLD;
    uint256 SILVER;

    function setUp() public {
        owner = vm.addr(1);
        gameItems = new GameItems(owner);
        GOLD = gameItems.GOLD();
        SILVER = gameItems.SILVER();
    }

    function test_mint() public {
        vm.prank(owner);
        address other = vm.addr(2);
        gameItems.mint(other, GOLD, 100, "");
        assertEq(gameItems.balanceOf(other, GOLD), 100);

        vm.prank(vm.addr(3));
        vm.expectRevert();
        gameItems.mint(other, GOLD, 100, "");
    }

    function test_mint_batch() public {
        vm.prank(owner);
        address other = vm.addr(2);
        uint256[] memory ids = new uint256[](2);
        ids[0] = GOLD;
        ids[1] = SILVER;
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 100;
        amounts[1] = 200;
        gameItems.mintBatch(other, ids, amounts, "");
        assertEq(gameItems.balanceOf(other, GOLD), 100);
        assertEq(gameItems.balanceOf(other, SILVER), 200);

        vm.prank(vm.addr(3));
        vm.expectRevert();
        gameItems.mintBatch(other, ids, amounts, "");
    }

    function test_transfer() public {
        vm.prank(owner);
        address alice = vm.addr(2);
        address bob = vm.addr(3);
        gameItems.mint(alice, GOLD, 1000, "");
        assertEq(gameItems.balanceOf(alice, GOLD), 1000);

        vm.prank(alice);
        gameItems.setApprovalForAll(owner, true);

        vm.prank(owner);
        gameItems.safeTransferFrom(alice, bob, GOLD, 500, "");
        assertEq(gameItems.balanceOf(alice, GOLD), 500);
        assertEq(gameItems.balanceOf(bob, GOLD), 500);

        vm.prank(bob);
        vm.expectRevert();
        gameItems.safeTransferFrom(alice, bob, GOLD, 100, "");
    }
}
