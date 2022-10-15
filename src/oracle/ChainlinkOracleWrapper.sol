// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/// @notice Wrapper around the Chainlink GBP/USD price feed
contract ChainlinkOracleWrapper {

    /// @notice Chainlink aggregator contract which assimilates various price feeds
    AggregatorV3Interface public chainlinkOracle;    

    uint256 public immutable decimals;
    
    constructor(address _chainlinkOracle) {
        chainlinkOracle = AggregatorV3Interface(_chainlinkOracle);
        decimals = chainlinkOracle.decimals();
    }

    /// @notice Get latest round oracle price
    function getPrice() view external returns (uint256) {
        (, int256 price, , , ) = chainlinkOracle.latestRoundData();
        return uint256(price);
    }
}