// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

interface IPoolFactory {
    function master() external view returns (address);

    function getDeployData() external view returns (bytes memory);

    function createPool(bytes calldata data) external returns (address pool);
}