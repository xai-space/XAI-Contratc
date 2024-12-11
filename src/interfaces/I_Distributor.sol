// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

interface I_Distributor {
    struct DistributionParams {
        bool isDistribution;
        uint40 distributionRatioKol;
        uint40 distributionRatioCommunity;
        uint40 walletCountKol;
        uint40 walletCountCommunity;
        bytes32 merkleRootKol;
        bytes32 merkleRootCommunity;
    }

    struct TokenParam {
        address token;
        uint176 supply;
        uint64 startTime;
        bool isKol;
        bool isCommunity;
    }

    function createDistribution(DistributionParams memory dp, TokenParam memory tp) external;
        function recommendAmount() external view returns (uint256);

}