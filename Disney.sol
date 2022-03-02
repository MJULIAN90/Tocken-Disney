// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 < 0.9.0;
import "./ERC20.sol";

contract Disney{

    //Instancia del contrato token
    MyTockenIRC20Basic private token;

    //Direccion de Disney (owner)
    address payable public immutable owner;
    

    //Construtor
    constructor (){
        token = new MyTockenIRC20Basic(1000);
        owner = payable(msg.sender);
    }

    //Estructura de datos para almancenar a los clientes de disney
    struct cliente{
        uint tokensComprados;
        string [] atraccionesDisfrutadas;
    }

    //Mapping para el registro de clientes
    mapping (address => cliente) public clientes;

    //--------------------------------- Gestion de tokens ---------------------------------

    //Funcion para establecer el precio de un token
    function precioTokens (uint _numTokens) internal pure returns (uint) {
        //Conversion my token a ethers 1 a 1
        return _numTokens * (1 ether);
    }

    //Funcion para comprar tockens
    function compraTokens (uint _numTokens)public payable {
        //Establecer el precio de los tockens
        uint coste = precioTokens (_numTokens);

        require (msg.value >= coste , "Compra menos tokens o paga con mas ethers.");

        //Diferencia de lo que paga 
         uint returnValue =  msg.value - coste ;

         //Disney retorna devuelta
         owner.transfer (returnValue);

         //Revisando tokens en el contrato
         uint balance = balanceOf();

         require (_numTokens <= balance, "Compra un numero menor de tokens");

         //Se transfiere el numero de tokens al cliente
         token.transfer(msg.sender , _numTokens);

         //Registro de tokens comprados
         clientes[msg.sender].tokensComprados += _numTokens;
    }

    //Balance de tokens del contrato disney
    function balanceOf()public view returns (uint ){
        return token.balanceOf(address(this));
    }

    //Visualizar tokens cliente
    function misTokens () public view returns (uint ){
        return token.balanceOf(msg.sender);
    }

    //funcion para generar mas tokens
    function generarTokens (uint _numTokens) public onlyAdmin(msg.sender){
        token.incrementTotalSupply(_numTokens);
    }

    //Modificador para controlar funciones
    modifier onlyAdmin (address _direccion){
        require (_direccion == owner , "No tienes permiso para ejecutar la funcion");
        _;
    }

    //--------------------------------- Gestion de Disney ---------------------------------

    //Eventos
    event disfrutaAtraccion(string);
    event nuevaAtraccion(string , uint);
    event bajaAtraccion(string);

    //Estructura de la atraccion
    struct atraccion{
        string nombreAtraccion;
        uint precioAtraccion;
        bool estadoAtraccion;
    }

    // Mapping para relacionar atracion con estructura de datos  
    mapping (string => atraccion) public mappingAtracciones;

    //Array para almacenar el nombre de las atracciones
    string [] atracciones;

    //mapping para relacionar un cliente con su historial en disney
    mapping (address => string[]) historialAtracciones;

    //Dar de alta atracciones
    function nuevaAtraccionDisney(string memory _nombreAtraccion, uint _precio) public onlyAdmin(msg.sender){
        // creacion de una atraccion 
        mappingAtracciones [_nombreAtraccion] = atraccion(_nombreAtraccion , _precio , true);

        //Almacenar la atraccion en un array
        atracciones.push(_nombreAtraccion);

        //Emision del evento para la nueva atraccion
        emit nuevaAtraccion(_nombreAtraccion , _precio);
    }

    //Dar de baja atracciones
    function bajaAtraccionesDisney (string memory _nombreAtraccion ) public onlyAdmin(msg.sender){
        //El estado de la atraccion pasa a false
        mappingAtracciones [_nombreAtraccion].estadoAtraccion = false;
        emit bajaAtraccion(_nombreAtraccion); 
    }

    //visualizar las atracciones de disney
    function atraccionesDisponiblesDisney()public view returns (string[] memory){
        return atracciones;
    }

    //Funcion para subirse a las atracciones y pagar
    function subirseAtraccionesDisney (string memory _nombreAtraccion) public {
        //Precio atraccion
        uint tokenAtraccion = mappingAtracciones[_nombreAtraccion].precioAtraccion;

        //Verificar estado atraccion sea disponible
        require (mappingAtracciones[_nombreAtraccion].estadoAtraccion == true,
        "La atraccion no esta disponible en estos momentos");
        
        //Verifica tokens del usuario
        require (tokenAtraccion <= misTokens(), 
        "Necesitas mas tokens para subirte a la atraccion");

        //El cliente paga la atraccion al contrato
        token.transferenciaDisney (msg.sender , address(this), tokenAtraccion);

        //Almacenar las atracciones del cliente usadas
        historialAtracciones[msg.sender].push(_nombreAtraccion);

        //Emitimos el evento
        emit disfrutaAtraccion(_nombreAtraccion);
    }

    //Visualizar historial de cada cliente en las atracciones
    function historialCliente ()public view returns (string [] memory){
        return historialAtracciones[msg.sender];
    }

    //Funcion para que disney devuelva el dinero a los usuarios
    function devolverTokens ( uint _numTokens) public payable {
        //El numero de token debe ser positivo
        require (_numTokens > 0, "Necesitas devolver un valor positivo");

        //El usuario debe tener el numero de tokens que quiere devolver
        require (_numTokens <= misTokens() , "No tienes los tokens que deseas devolver");

        //El cliente devuelve los tokens
        token.transferenciaDisney(msg.sender , address(this) , _numTokens);

        //Devolucion de los etheres al cliente
        owner.transfer(precioTokens(_numTokens));
    }
}