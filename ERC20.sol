// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 < 0.9.0;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Interface.sol";

//Implementacion de las funciones del token
contract MyTockenIRC20Basic is InterfaceIRC20{

    using SafeMath for uint256;

    string public constant name= 'RocketERC20';
    string public constant symbol= 'Roc';
    string public constant creator = 'Julian Ruiz';
    uint8 public constant decimals= 2;
    uint256 totalSupply_;
    mapping (address => uint) balances;
    mapping (address => mapping (address=>uint)) allowed;
    address owner;

    constructor (uint256 initialSupply) {
        totalSupply_ = initialSupply;
        balances[msg.sender] = totalSupply_;
        owner = msg.sender;
    }

    function incrementTotalSupply (uint newTokens)  public  {
            totalSupply_+= newTokens;
            balances[owner]+= newTokens;
    }

    function totalSupply() public override view returns (uint256){
        return totalSupply_;
    }

    function balanceOf(address addresOwner) public override view returns (uint256){
        return balances[addresOwner];
    }

    function allowance(address ownerToken, address spender) public override view returns (uint256){
        return allowed[ownerToken][spender];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool){
        require (amount <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[recipient] = balances[recipient].add(amount);
        emit transferEvent(msg.sender , recipient , amount);
        return true;
    }

    function transferenciaDisney(address _cliente, address recipient, uint256 amount) public override returns (bool){
        require (amount <= balances[_cliente]);
        balances[_cliente] = balances[_cliente].sub(amount);
        balances[recipient] = balances[recipient].add(amount);
        emit transferEvent(_cliente , recipient , amount);
        return true;
    }

    function approve(address delegate, uint256 amount) public override returns (bool){
        allowed[msg.sender][delegate] = amount;
        emit approvalEvent(msg.sender, delegate , amount);
        return true;
    }

    function transferFrom(address ownerToken, address recipient, uint256 amount) public override returns (bool){
        require (amount <= balances[ownerToken]);
        require(amount <= allowed[ownerToken][msg.sender]);

        balances[ownerToken] = balances[ownerToken].sub(amount);
        allowed[ownerToken][msg.sender] =  allowed[ownerToken][msg.sender].sub(amount);
        balances[recipient] = balances[recipient].add(amount);
        emit transferEvent(ownerToken , recipient , amount);
        return true;
    }

}