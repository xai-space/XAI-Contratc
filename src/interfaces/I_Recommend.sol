// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

interface I_Recommend {
    function recommendAmount() external returns (uint256);  
    function setClaimableTokens(address referrer, uint256 amount) external payable;  
    function versions() external view returns (string memory);
}
