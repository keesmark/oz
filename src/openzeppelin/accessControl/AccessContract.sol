// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract AccessContract is AccessControl {
    // 書き込みができるロールとしてWRITER_ROLEを定義
    bytes32 public constant WRITER_ROLE = keccak256("WRITER_ROLE");
    bytes32 public constant MEMBER_ROLE = keccak256("MEMBER_ROLE");
    uint256 public value;

    constructor(address defaultAdmin, address writer) {
        // adminとしてdefaultAdminを設定
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        // WRITER_ROLEのadminとしてDEFAULT_ADMIN_ROLEを設定
        _setRoleAdmin(WRITER_ROLE, DEFAULT_ADMIN_ROLE);
        // MEMBER_ROLEのadminとしてDEFAULT_ADMIN_ROLEを設定
        _setRoleAdmin(MEMBER_ROLE, DEFAULT_ADMIN_ROLE);
        // writerとしてwriterを設定
        _grantRole(WRITER_ROLE, writer);
    }

    // Memberのみがincrementを実行できる
    function increment() external {
        require(hasRole(MEMBER_ROLE, msg.sender), "Caller is not a member");
        value++;
    }

    // WRITER_ROLEを持っているアカウントのみがdecrementを実行できる
    function decrement() external onlyRole(WRITER_ROLE) {
        require(value > 0, "Value cannot be negative");
        value--;
    }

    // Default adminのみがsetValueを実行できる
    function setValue(uint256 _value) external onlyRole(DEFAULT_ADMIN_ROLE) {
        value = _value;
    }

    // Memberを追加する
    // Default adminのみが実行できる
    function addMember(address member) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(member != address(0), "member is the zero address");
        _grantRole(MEMBER_ROLE, member);
    }
}
