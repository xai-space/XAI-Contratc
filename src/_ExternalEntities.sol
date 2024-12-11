// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { ERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import { IUniswapV2Factory } from "./interfaces/IUniswapV2Factory.sol";
import { Ownable } from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import { I_Master } from "./interfaces/I_Master.sol";

contract _ExternalEntities is Ownable {
    error _NoOwner();

    address public weth;
    address public Master;

    IUniswapV2Factory[] public knownFactories;
    mapping(address => bool) public pregradRestricted;
    mapping(address => bool) public isAdmin;

    constructor(address _weth, address _factory,address _Master) Ownable(msg.sender) {
        weth = _weth;
        knownFactories.push(IUniswapV2Factory(_factory));
        Master = _Master;
    }

    function _checkOwner() internal view virtual override {
        address sender = _msgSender();
        if (owner() != sender && !isAdmin[sender]) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    function setAdmin(address _admin, bool _status) external {
        if (msg.sender != owner()) revert _NoOwner();
        isAdmin[_admin] = _status;
    }

    function addFactory(address factory) external onlyOwner {
        knownFactories.push(IUniswapV2Factory(factory));
    }

    function removeFactory(address factory) external onlyOwner {
        for (uint256 i = 0; i < knownFactories.length; i++) {
            if (address(knownFactories[i]) == factory) {
                knownFactories[i] = knownFactories[knownFactories.length - 1];
                knownFactories.pop();
                break;
            }
        }
    }

    function addPregradRestricted(address to) external onlyOwner {
        pregradRestricted[to] = true;
    }

    function removePregradRestricted(address to) external onlyOwner {
        pregradRestricted[to] = false;
    }

    function setWeth(address _weth) external onlyOwner {
        weth = _weth;
    }

    function isPregradRestricted(address token, address to) external view returns (bool) {
        for (uint256 i = 0; i < knownFactories.length; i++) {
            address pair = I_Master(Master).pairFor(token, weth);
            if (pair == to) {
                return true;
            }
        }

        return pregradRestricted[to];
    }
}
