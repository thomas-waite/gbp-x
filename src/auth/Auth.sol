// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {AccessControlEnumerable} from "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

/// @notice Lightweight auth. Grants GOVERN to msg.sender
contract Auth is AccessControlEnumerable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant GOVERN_ROLE = keccak256("GOVERN_ROLE");

    modifier onlyMinter() {
        require(isMinter(msg.sender), "NOT_MINTER");
        _;
    }

    modifier onlyGovernor() {
        require(isGovernor(msg.sender), "NOT_GOVERNOR");
        _;
    }

    constructor() {
        // Setup GOVERN_ROLE to self and grant to deployer
        _setupRole(GOVERN_ROLE, address(this));
        _setupRole(GOVERN_ROLE, msg.sender);

        _setRoleAdmin(MINTER_ROLE, GOVERN_ROLE);
        _setRoleAdmin(GOVERN_ROLE, GOVERN_ROLE);        
    }

    function isMinter(address _minter) public view returns (bool) {
        return hasRole(MINTER_ROLE, _minter);
    }

    function isGovernor(address _governor) public view returns (bool) {
        return hasRole(GOVERN_ROLE, _governor);
    }

    function grantMinter(address _minter) external onlyGovernor() {
        grantRole(MINTER_ROLE, _minter);
    }
}