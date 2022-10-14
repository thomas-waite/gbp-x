// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {AuthRef} from "./AuthRef.sol";
import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract GBPX is ERC20Burnable, AuthRef {

    event Mint(address _minter, address _receiver, uint256 _amount);
    event Burn(address _burner, uint256 _amount);

    constructor(address _auth) ERC20("British Pound - X", "GBP-X") AuthRef(_auth) {}

    function mint(address account, uint256 amount) external onlyMinter {
        _mint(account, amount);
        emit Mint(msg.sender, account, amount);
    }

    function burn(uint256 amount) public override(ERC20Burnable) {
        super.burn(amount);
        emit Burn(msg.sender, amount);
    }
}