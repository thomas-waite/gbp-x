// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Test} from "../libs/Test.sol";
import {Vm} from "../libs/Vm.sol";
import {Auth} from "../../src/auth/Auth.sol";
import {PegStabilityModule} from "../../src/peg/PegStabilityModule.sol";
import {MainnetAddresses} from "../../src/constants/MainnetAddresses.sol";
import {ChainlinkOracleWrapper} from "../../src/oracle/ChainlinkOracleWrapper.sol";
import {GBPX} from "../../src/token/GBPX.sol";

contract PegStabilityModuleIntegrationTest is Test {
    PegStabilityModule public psm;
    GBPX public gbpx;
    ChainlinkOracleWrapper public oracle;

    address public minter = address(1);
    address public user = address(2);
    address public DAI_WHALE = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;

    ERC20 public dai = ERC20(MainnetAddresses.DAI);

    Vm public constant vm = Vm(HEVM_ADDRESS);

    function setUp() public {
        // 1. Deploy auth, GBP-X token and Chainlink token
        Auth auth = new Auth();
        oracle = new ChainlinkOracleWrapper(MainnetAddresses.CHAINLINK_GBP_USD_FEED);
        gbpx = new GBPX(address(auth));

        // 2. Deploy PSM
        psm = new PegStabilityModule(
            address(auth),
            MainnetAddresses.DAI,
            address(gbpx),
            address(oracle)
        );

        // 3. Grant minter role
        auth.grantMinter(minter);
        auth.grantMinter(address(psm));
    }

    function testInitialState() public {
        assertEq(address(psm.underlying()), MainnetAddresses.DAI);
        assertEq(address(psm.gbpx()), address(gbpx));
        assertEq(address(psm.oracle()), address(oracle));
    }

    /// @notice Mint some GBP-X, by providing underlying DAI to the PSM
    function testMint() public {
        uint256 amountDAIIn = 10e18;

        vm.startPrank(DAI_WHALE);
        dai.approve(address(psm), amountDAIIn);
        psm.mint(user, amountDAIIn);
        vm.stopPrank();

        uint256 gbpInUsdPrice = oracle.getPrice();
        uint256 expectedGBPXOut = (amountDAIIn * 1e18) / gbpInUsdPrice;

        assertEq(dai.balanceOf(address(psm)), amountDAIIn);
        assertEq(gbpx.balanceOf(user), expectedGBPXOut);
    }

    /// @notice Redeem DAI from PSM for GBP-X
    function testRedeem() public {
        // Mint some GBPX to user
        uint256 amountGBPXIn = 10e18;
        vm.prank(minter);
        gbpx.mint(user, amountGBPXIn);

        // Initialise PSM with some DAI
        vm.prank(DAI_WHALE);
        dai.transfer(address(psm), 100e18);

        // Redeem GBPX for DAI from PSM
        vm.startPrank(user);
        gbpx.approve(address(psm), amountGBPXIn);
        psm.redeem(user, amountGBPXIn);
        vm.stopPrank();

        uint256 gbpInUsdPrice = oracle.getPrice();
        uint256 expectedDAIOut = (gbpInUsdPrice * amountGBPXIn) / 1e18;

        assertEq(gbpx.balanceOf(user), 0);
        assertEq(dai.balanceOf(user), expectedDAIOut);
    }
}