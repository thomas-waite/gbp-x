// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {AuthRef} from "../auth/AuthRef.sol";
import {GBPX} from "../token/GBPX.sol";
import {ChainlinkOracleWrapper} from "../oracle/ChainlinkOracleWrapper.sol";
import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


/// @notice Peg stability module which allows minting of GBP-X and redemptions
///         for underlying, at price given by oracle
/// @dev Assumes DAI is 1:1 with USD
contract PegStabilityModule is AuthRef {
    using SafeERC20 for IERC20;
    using SafeERC20 for GBPX;

    event WithdrawERC20(address indexed _to, address _token, uint256 _amount);
    event Mint(address indexed from, address indexed to, uint256 amountIn, uint256 amountOut);
    event Redeem(address indexed from, address indexed to, uint256 amountIn, uint256 amountOut);

    /// @notice Underlying token which collaterises the GBP-X stablecoin
    IERC20 public immutable underlying;

    /// @notice GBPX stablecoin
    GBPX public immutable gbpx;

    /// @notice Chainlink Oracle, providing price of gbpx in terms of underlying
    ChainlinkOracleWrapper public oracle;

    /// @param _underlying Underlying token which collaterises the GBP-X stablecoin
    /// @param _gbpx GBP stablecoin
    /// @param _chainlinkOracle Chainlink oracle which provides price of gbpx in terms of underlying
    constructor(
        address _auth,
        address _underlying,
        address _gbpx,
        address _chainlinkOracle
    ) AuthRef(_auth) {
        underlying = IERC20(_underlying);
        gbpx = GBPX(_gbpx);
        oracle = ChainlinkOracleWrapper(_chainlinkOracle);
    }

    /// @notice Preview underling redeem amount out
    function previewRedeemAmountOut(uint256 amountGBPXIn) view public returns (uint256) {
        uint256 gbpInUsdPrice = oracle.getPrice();
        return (amountGBPXIn * gbpInUsdPrice) / 1e18;
    }

    /// @notice Preview GBP-X mint amount out
    function previewMintAmountOut(uint256 amountUnderlyingIn) view public returns (uint256) {
        uint256 gbpInUsdPrice = oracle.getPrice();
        return (amountUnderlyingIn * 1e18) / gbpInUsdPrice;
    }

    /// @notice Mint GBP-X, by providing underlying 
    function mint(address to, uint256 amountUnderlyingIn) external {
        uint256 amountGBPXOut = previewMintAmountOut(amountUnderlyingIn);
        underlying.safeTransferFrom(msg.sender, address(this), amountUnderlyingIn);
        gbpx.mint(to, amountGBPXOut);
        emit Mint(msg.sender, to, amountUnderlyingIn, amountGBPXOut);
    }

    /// @notice Redeem GBP-X for underlying
    function redeem(address to, uint256 amountGBPXIn) external {
        uint256 amountUnderlyingOut = previewRedeemAmountOut(amountGBPXIn);
        gbpx.safeTransferFrom(msg.sender, address(this), amountGBPXIn);
        underlying.transfer(to, amountUnderlyingOut);
        emit Redeem(msg.sender, to, amountGBPXIn, amountUnderlyingOut);
    }

    /// @notice Emergency onlyGovernor withdraw function
    function withdrawERC20(
        address token,
        address to,
        uint256 amount
    ) onlyGovernor external {
        IERC20(token).safeTransfer(to, amount);
        emit WithdrawERC20(to, token, amount);
    }
}