// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 < 0.9.0;

interface InterfaceIRC20{
    //Retorna la cantidad de tokens en existencia
    function totalSupply() external view returns (uint256);

    //Retorna la cantidad de rokens para una dirección indicada por parámetro
    function balanceOf(address account) external view returns (uint256);

    //Retorna el número de token que el spender podrá gastar en nombre del propietario (owner)
    function allowance(address ownerToken, address spender) external view returns (uint256);

    //Retorna un valor booleano resultado de la operación indicada
    function transfer(address recipient, uint256 amount) external returns (bool);

    //Cliente paga la atraccion
    function transferenciaDisney(address _cliente,  address recipient, uint256 amount) external returns (bool);

    //Retorna un valor booleano con el resultado de la operación de gasto
    function approve(address delegate, uint256 amount) external returns (bool);

    //Retorna un valor booleano con el resultado de la operación de paso de una cantidad de tokens usando el método allowance()
    function transferFrom(address owner, address recipient, uint256 amount) external returns (bool);

    //Events

    //Evento que se debe emitir cuando una cantidad de tokens pase de un origen a un destino
    event transferEvent(address indexed from, address indexed to, uint256 value);

    //Evento que se debe emitir cuando se establece una asignación con el mmétodo allowance()
    event approvalEvent(address indexed owner, address indexed spender, uint256 value);
}