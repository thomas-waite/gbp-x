// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {Auth} from "./Auth.sol";

/// @notice Pass through to an auth permissioning contract
contract AuthRef {
    Auth public auth;
    
    event UpdateAuth(address _oldAuth, address _newAuth);

    modifier onlyMinter() {
        require(auth.isMinter(msg.sender), "NOT_MINTER");
        _;
    }

    modifier onlyGovernor() {
        require(auth.isGovernor(msg.sender), "NOT_GOVERNOR");
        _;
    }

    constructor(address _auth) {
        auth = Auth(_auth);
    }

    function setAuth(address _newAuth) external {
        emit UpdateAuth(address(auth), _newAuth);
        auth = Auth(_newAuth);
    }
}