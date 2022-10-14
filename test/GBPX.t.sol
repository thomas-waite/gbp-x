// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {Test} from "./libs/Test.sol";
import {Auth} from "../src/Auth.sol";
import {GBPX} from "../src/GBPX.sol";

contract GBPXTest is Test {
    GBPX public gbpx;

    function setUp() public {
        Auth auth = new Auth();

        gbpx = new GBPX(address(auth));
    }

    function testInitialState() public {
        assertEq(gbpx.name(), "British Pound - X");
        assertEq(gbpx.symbol(), "GBP-X");
    }

    function testTransfer() public {

    }

    function testMint() public {
        
    }
}