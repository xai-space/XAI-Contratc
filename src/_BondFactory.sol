pragma solidity 0.8.19;

import { _Token } from "./_Token.sol";
import { Ownable } from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import { I_BondingCurve } from "./interfaces/I_BondingCurve.sol";

contract _BondFactory is Ownable {
    error _Forbidden();
    error _NoTrue(string);
    error _NoOwner();

    address public bond;
    address public entities;
    mapping(address => bool) public isAdmin;
    mapping(address => uint256) public tokenToId;

    string public versions = "0.9.1";

    event ContractDeploy(uint256 indexed flag, string version);

    constructor(address _bond) Ownable(msg.sender) {
        bond = _bond;
        isAdmin[msg.sender] = true;
        emit ContractDeploy(8, versions);
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

    function setEntities(address _entities) external onlyOwner {
        entities = _entities;
    }

    function create(
        string[] calldata _infos,
        uint256[] calldata _params,
        address _creator,
        uint256 _totalSupply,
        address _bond
    ) external onlybond returns (_Token token) {
        if (_params[0] == 0) revert _NoTrue("_params");

        string memory bondVersion = _getBondVersion();

        address[] memory _tokenParams = _initializeParams(_bond, _creator);
        
        token = new _Token{ salt: keccak256(abi.encodePacked(_params[0])) }(
            _infos[0],
            _infos[1],
            _totalSupply,
            _tokenParams,
            bondVersion
                    );

        tokenToId[address(token)] = _params[0];
    }

    function _initializeParams(address _bond, address _creator) private view returns (address[] memory _tokenParams) {
        _tokenParams = new address[](4); 
        _tokenParams[0] = _bond;
        _tokenParams[1] = address(this);
        _tokenParams[2] = _creator;
        _tokenParams[3] = entities;
    }

    function _getBondVersion() internal view returns (string memory bondVersion) {
        try I_BondingCurve(bond).versions() returns (string memory _bondVersion) {
            bondVersion = _bondVersion;
        } catch {}
    }
}
