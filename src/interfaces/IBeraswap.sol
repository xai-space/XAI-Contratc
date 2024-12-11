// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;
interface IBeraswap {
    function userCmd(uint16 callpath, bytes calldata cmd)
        external
        payable
        returns (bytes memory);
    function deposit() external  payable returns (uint256) ;
    function addLiquidity(
        address tokenA,
        address tokenB,
        bool stable,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);

}
