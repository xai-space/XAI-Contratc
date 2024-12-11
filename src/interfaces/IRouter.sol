// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

interface IRouter{
    struct TokenInput {
        address token;
        uint amount;
        bool useVault;
    }

    function addLiquidity(
        address pool,
        TokenInput[] calldata inputs,
        bytes calldata data,
        uint minLiquidity,
        address callback,
        bytes calldata callbackData,
        address staking
    ) external payable returns (uint liquidity);

    function addLiquidity2(
        address pool,
        TokenInput[] calldata inputs,
        bytes calldata data,
        uint minLiquidity,
        address callback,
        bytes calldata callbackData,
        address staking
    ) external payable returns (uint liquidity);
}
