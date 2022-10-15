// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {Test} from "../libs/Test.sol";
import {Auth} from "../../src/auth/Auth.sol";

contract AuthTest is Test {
    Auth public auth;

    function setUp() public {
        auth = new Auth();
    }

    function testInitialState() public {
        assertTrue(auth.hasRole(auth.GOVERN_ROLE(), address(this)));
    }

    function testIsMinterFails() public {
        assertFalse(auth.hasRole(auth.MINTER_ROLE(), address(1)));
    }

    function testGrantMinter() public {
        auth.grantRole(auth.MINTER_ROLE(), address(1));
        assertTrue(auth.hasRole(auth.MINTER_ROLE(), address(1)));
    }
}