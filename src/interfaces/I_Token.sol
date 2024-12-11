// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

interface I_Token {
    function setIsApprovable(bool _isApprovable) external;
    function versions() external view returns (string memory);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);

}
