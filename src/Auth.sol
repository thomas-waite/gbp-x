// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {AccessControlEnumerable} from "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

/// @notice Lightweight auth
contract Auth is AccessControlEnumerable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant GOVERN_ROLE = keccak256("GOVERN_ROLE");

    constructor() {
        _setRoleAdmin(MINTER_ROLE, GOVERN_ROLE);
        _setRoleAdmin(GOVERN_ROLE, GOVERN_ROLE);
    }

    function isMinter(address _minter) external view returns (bool) {
        return hasRole(MINTER_ROLE, _minter);
    }

    function isGovernor(address _governor) external view returns (bool) {
        return hasRole(GOVERN_ROLE, _governor);
    }
}