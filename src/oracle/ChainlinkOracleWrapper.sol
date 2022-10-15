// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/// @notice Wrapper around the Chainlink GBP/USD price feed
contract ChainlinkOracleWrapper {

    /// @notice Chainlink aggregator contract which assimilates various price feeds
    AggregatorV3Interface public chainlinkOracle;    

    /// @notice Number of decimals Chainlink reports price in
    uint256 public immutable decimals;

    /// @notice Base number of decimals this wrapper price in
    uint256 public constant BASE_DECIMALS = 10**18;
    
    constructor(address _chainlinkOracle) {
        chainlinkOracle = AggregatorV3Interface(_chainlinkOracle);
        decimals = chainlinkOracle.decimals();
    }

    /// @notice Get latest round oracle price. Return as 18 decimals
    function getPrice() view external returns (uint256) {
        (, int256 price, , , ) = chainlinkOracle.latestRoundData();
        return (uint256(price) * BASE_DECIMALS) / 10**decimals;
    }
}