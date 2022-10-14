// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {Test} from "./Test.sol";
import {GBPX} from "../src/GBPX.sol";

contract GBPXTest is Test {

    GBPX public gbpx;

    function setUp() {
        gbpx = new GBPX();
    }

    function testTransfer() {
        

    }

    function testMint() {

    }
}