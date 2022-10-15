// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {Test} from "./libs/Test.sol";
import {Vm} from "./libs/Vm.sol";
import {Auth} from "../src/auth/Auth.sol";
import {GBPX} from "../src/token/GBPX.sol";

contract GBPXTest is Test {
    GBPX public gbpx;

    address public minter = address(1);
    address public user = address(2);
    address public user2 = address(3);

    Vm public constant vm = Vm(HEVM_ADDRESS);

    function setUp() public {
        Auth auth = new Auth();
        gbpx = new GBPX(address(auth));

        // Grant MINTER to address
        auth.grantMinter(minter);
    }

    function testInitialState() public {
        assertEq(gbpx.name(), "British Pound - X");
        assertEq(gbpx.symbol(), "GBP-X");
    }

    function testMint() public {
        assertEq(gbpx.balanceOf(user), 0);

        vm.prank(minter);
        gbpx.mint(user, 5);

        assertEq(gbpx.balanceOf(user), 5);
    }

    function testTransfer() public {
        assertEq(gbpx.balanceOf(user), 0);

        vm.prank(minter);
        gbpx.mint(user, 10);

        vm.prank(user);
        gbpx.transfer(user2, 5);

        assertEq(gbpx.balanceOf(user), 5);
        assertEq(gbpx.balanceOf(user2), 5);
    }
}