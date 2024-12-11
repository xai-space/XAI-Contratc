// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

interface I_Factory {
    function create(
        string[] calldata _infos,
        uint256[] calldata _paras,
        address _creator,
        uint256 _totalSupply,
        address _bond
    ) external returns (address token);

    function versions() external view returns (string memory);
}
