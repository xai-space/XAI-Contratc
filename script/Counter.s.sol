// SPDX-License-Identifier: UNLICENSED
// 这个 SPDX 许可证标识符表明这个代码没有特定的授权协议（即没有版权）。

pragma solidity ^0.8.13;  
// 声明 Solidity 编译器的版本，要求至少是 0.8.13 版本或更高。

// 引入 forge-std 库中的 Script 和 console 模块
import {Script, console} from "forge-std/Script.sol";
// 引入我们要在脚本中使用的 Counter 合约
import {Counter} from "../src/Counter.sol";

// 定义一个名为 CounterScript 的合约，它继承自 Script 类。
contract CounterScript is Script {
    // 声明一个 public 类型的 Counter 合约实例，用于在脚本中使用。
    Counter public counter;

    // setUp 函数是 Script 合约的生命周期函数之一，通常用来初始化脚本执行前的状态。
    function setUp() public {}

    // run 函数是执行实际操作的函数，通常会在其中编写合约部署等逻辑。
    function run() public {
        // 开始广播交易，意味着接下来会进行合约部署等操作，并广播到区块链网络。
        vm.startBroadcast();

        // 部署一个新的 Counter 合约实例，并将其赋值给 counter 变量。
        counter = new Counter();

        // 停止广播，意味着接下来的操作不再被视为广播的交易。
        vm.stopBroadcast();
    }
}
