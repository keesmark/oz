// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";

contract GameItems is ERC1155, Ownable, ERC1155Burnable {
    uint256 public constant GOLD = 0;
    uint256 public constant SILVER = 1;
    uint256 public constant THORS_HAMMER = 2;
    uint256 public constant SWORD = 3;
    uint256 public constant SHIELD = 4;

    constructor(
        address initialOwner
    ) ERC1155("https://example.com/{id}.json") Ownable(initialOwner) {
        _mint(initialOwner, GOLD, 10 ** 18, "");
        _mint(initialOwner, SILVER, 10 ** 27, "");
        _mint(initialOwner, THORS_HAMMER, 1, "");
        _mint(initialOwner, SWORD, 10, "");
        _mint(initialOwner, SHIELD, 10, "");
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        _mint(account, id, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }
}
