// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;


interface I_BondingCurve {
    struct TokenParam {
        address token;
        uint176 supply;
        uint64 startTime;
    }

    function createToken(
        uint256 initAmountIn,
        address[] memory referrers,
        string[] calldata _infos,
        uint256[] calldata _params
        // I_Distributor.DistributionParams calldata dp
    ) external payable returns (address token);

    function mint(
        address token,
        uint256 amountIn,
        uint256 amountOutMin,
        address to,
        uint256 deadline,
        address[] memory referrers
    ) external payable returns (uint256 amountOut);

    function versions() external view returns (string memory);
    function creationFee_() external view returns (uint256);
}
