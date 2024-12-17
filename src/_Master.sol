// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.19;
import { IERC20 } from "./interfaces/IERC20.sol";
import { SafeTransferLib } from "lib/solady-main/src/utils/SafeTransferLib.sol";
import { IUniswapV2Router02 } from "./interfaces/IUniswapV2Router02.sol";
import { IUniswapV2Factory } from "./interfaces/IUniswapV2Factory.sol";
import { I_Token } from "./interfaces/I_Token.sol";
import { Ownable } from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import { IBeraswap } from "./interfaces/IBeraswap.sol";

/**
 * @title _Master
 * @notice This contract may be replaced by other strategies in the future.A  protocol graduation strategy for bootstrapping liquidity on uni-v2 AMMs.
 */
contract _Master is Ownable {
    error _Forbidden();
    error _InvalidAmountToken();
    error _InvalidAmountEth();
    error _NoOwner();

    address public bond;
    mapping(address => bool) public isAdmin;
    IUniswapV2Router02 public uniswapV2Router02;

    address public liquidityOwner = address(0x07C0baD65cf9E2063C56382e6c5872d49Eb4099a);

    address[] public addedLiquidityToken;
    string public versions = "0.1.1";
    event ContractDeploy(uint256 indexed flag, string version);

    constructor(address _bond, address _uniswapV2Router02,address factory) Ownable(msg.sender) {
        isAdmin[msg.sender] = true;
        bond = _bond;
        uniswapV2Router02 = IUniswapV2Router02(payable(_uniswapV2Router02));

        emit ContractDeploy(3, versions);
    }

    modifier onlybond() {
        if (msg.sender != bond) revert _Forbidden();
        _;
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

    function setBond(address _bond) external onlyOwner {
        bond = _bond;
    }
    

    //test todo
    function setLiquidityOwner(address _liquidityOwner) external onlyOwner {
        liquidityOwner = _liquidityOwner;
    }
    //test todo
    function rescueETH(address _to, uint256 _value) external onlyOwner {
        SafeTransferLib.safeTransferETH(_to, _value);
    }

    function setUniswapV2Router02(address _uniswapV2Router02) external onlyOwner {
        uniswapV2Router02 = IUniswapV2Router02(payable(_uniswapV2Router02));
    }

    event AddLiquidity(
        address indexed token,
        address indexed pair,
        uint256 amountETH,
        uint256 amountToken,
        uint256 time
    );    

    function execute(
        address token,
        uint256 amountToken,
        uint256 amountEth
    ) external payable  returns (uint256 _amountToken, uint256 _amountETH) {
        if (amountToken == 0) revert _InvalidAmountToken();
        if (amountEth == 0 || msg.value != amountEth) revert _InvalidAmountEth();

        I_Token(token).transferFrom(msg.sender, address(this), amountToken);
        I_Token(token).approve(address(uniswapV2Router02), amountToken);

        address pair = IUniswapV2Factory(uniswapV2Router02.factory()).createPair(
            address(token),
            uniswapV2Router02.WETH()
        );
        (_amountToken, _amountETH, ) = uniswapV2Router02.addLiquidityETH{ value: amountEth }(
            address(token),
            amountToken,
            0,
            0,
            liquidityOwner,
            block.timestamp
        );

        addedLiquidityToken.push(token);

        emit AddLiquidity(token, pair, _amountETH, _amountToken, block.timestamp);
    }

    function pairFor(address tokenA, address tokenB)
        public
        view
        returns (address pair)
    {
        (address token0,address token1) = tokenA <tokenB ? (tokenA,tokenB) : (tokenB,tokenA);
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        pair = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            hex"ff",
                            IUniswapV2Factory(uniswapV2Router02.factory()),
                            salt,
                            hex"f8fb854b80d71035cc709012ce23accad9a804fcf7b90ac0c663e12c58a9c446"
                        )
                    )
                )
            )
        );
    }

    receive() external payable {
    }
    function getToken() external view returns (address[] memory) {
        return addedLiquidityToken;
    }
    
    function withdraw() external payable {
        payable(msg.sender).transfer(address(this).balance);
    }
    function withdrawtoken(address token, uint256 amounts) external {
        IERC20(token).transfer(msg.sender, amounts);
    }


}
