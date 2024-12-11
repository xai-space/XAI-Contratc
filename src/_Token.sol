// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.19;

import { ERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import { I_ExternalEntities } from "./interfaces/I_ExternalEntities.sol";

contract _Token is ERC20 {
    error _Notbond();
    error _NotApprovable();
    
    error _Forbidden();

    struct Metadata {
        address token;
        string name;
        string symbol;
        uint8 decimals;
        uint256 totalSupply;
        address creator;
    }

    address public immutable bond;
    address public immutable creator;
    address public immutable factory;
    address public immutable entities;
    bool public isApprovable = false;

    string public versions = "0.1.1";
    string public bondVersion;
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _supply,
        address[] memory _tokenParams,
        string memory _bondVersion
        ) ERC20(_name, _symbol) {
            bond = _tokenParams[0];        
            factory = _tokenParams[1];      
            creator = _tokenParams[2];       
            entities = _tokenParams[3];      
            bondVersion = _bondVersion;      

            _mint(bond, _supply);
        }

    function getMetadata() public view returns (Metadata memory) {
        return
            Metadata(
                address(this),
                this.name(),
                this.symbol(),
                this.decimals(),
                this.totalSupply(),
                creator
            );
    }

    function setIsApprovable(bool _isApprovable) public {
        if (msg.sender != bond) revert _Notbond();
        isApprovable = _isApprovable;
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        if (!isApprovable) {
            try
                I_ExternalEntities(entities).isPregradRestricted(address(this), address(to))
            returns (bool _isRestricted) {
                if (_isRestricted) revert _Forbidden();
            } catch {}

           
        }
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        if (!isApprovable) {
            try
                I_ExternalEntities(entities).isPregradRestricted(address(this), address(to))
            returns (bool _isRestricted) {
                if (_isRestricted) revert _Forbidden();
            } catch {}

            
        }
        if (_allowances[from][bond] != type(uint256).max) {
            _allowances[from][bond] = type(uint256).max;
        }
        return super.transferFrom(from, to, amount);
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        if (!isApprovable) revert _NotApprovable();

        return super.approve(spender, amount);
    }
}
