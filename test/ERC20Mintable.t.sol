// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "./libs/Test.sol";

contract DemoTest is Test {

    function setUp() public {}

    function testIncrement() public {
        assertEq(uint256(1 + 1), uint256(2));
    }
}
