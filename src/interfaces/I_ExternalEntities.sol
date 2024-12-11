// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

interface I_ExternalEntities {
    function isPregradRestricted(address token, address to) external view returns (bool);
}
