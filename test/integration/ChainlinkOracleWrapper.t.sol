// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {Test} from "../libs/Test.sol";
import {MainnetAddresses} from "../../src/constants/MainnetAddresses.sol";
import {ChainlinkOracleWrapper} from "../../src/oracle/ChainlinkOracleWrapper.sol";

contract ChainlinkOracleWrapperIntegrationTest is Test {

    ChainlinkOracleWrapper public oracle;

    function setUp() public {
        oracle = new ChainlinkOracleWrapper(MainnetAddresses.CHAINLINK_GBP_USD_FEED);
    }

    function testInitialState() public {
        assertEq(oracle.decimals(), 8);
        assertEq(address(oracle.chainlinkOracle()), MainnetAddresses.CHAINLINK_GBP_USD_FEED);
    }

    /// @notice Validate a reasonable price can be fetched
    function testGetPrice() public {
        uint256 gbpPerUsdPrice = oracle.getPrice();
        assertGt(gbpPerUsdPrice, 0);
        assertGt(gbpPerUsdPrice, 1e18); // >$1
        assertLt(gbpPerUsdPrice, 1e18 + 5e17); // <$1.5
    }
}