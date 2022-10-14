// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract GBPX is ERC20Burnable {
    constructor() ERC20("British Pound - X", "GBP-X") {}

    function mint(address account, uint256 amount) external override onlyMinter whenNotPaused {
        _mint(account, amount);
        emit Minting(account, msg.sender, amount);
    }

    function burn(uint256 amount) public override(ERC20Burnable) {
        super.burn(amount);
        emit Burning(msg.sender, msg.sender, amount);
    }
}