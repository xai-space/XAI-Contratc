// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

interface I_Master {
    function execute(
        address token,
        uint256 amountToken,
        uint256 amountEth
    ) external payable returns (uint256 _amountToken, uint256 _amountETH);

    function versions() external view returns (string memory);
    function pairFor(address tokenA, address tokenB)external view returns(address);
}
