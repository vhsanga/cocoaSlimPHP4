<?php
include  ROOT_PATH.'/app/Conexion.php';
/**
* this class represents a person
*/
class UsuarioRepositorio 
{
    
    protected $atributos = ['id','usuario', 'contrasenia','estadousuario' ];
    protected $tabla="usuario";

    private function leerResultado($result){  
        $usuarios = array();       
        while($row = $result->fetch_assoc()) {
            $fila = array(); 
            foreach ($this->atributos as $columna)  {
                $fila[$columna]=$row[$columna];
            }
            array_push($usuarios , $fila );                
        }              
        return $usuarios;
    }

  
    private function leerResultadoAttr($result, $arrayAttr){  
        $usuarios = array();       
        while($row = $result->fetch_assoc()) {
            $fila = array(); 
            foreach ($arrayAttr as $columna)  {
                $fila[$this->atributos[($columna-1)]]=$row[$this->atributos[($columna-1)]];
            }
            array_push($usuarios , $fila );                
        }              
        return $usuarios;
    }
   
    function findAll(){
        $usuarios = array();               
        $response = array();
        $statusCode=500;
        $mensaje='';	
        try {
            $conn=OpenCon();
            $sql ="select * from ".$this->tabla;
            $result = $conn->query($sql);
            if ( $result) {
                $usuarios = $this->leerResultado($result); 
                $statusCode=200; 
                $response["message"]["type"] = "OK"; 
                $response["message"]["description"] = "Consulta Correcta"; 
            }else {
                $statusCode=200; 
                $response["message"]["type"] = "DataBase"; 
                $response["message"]["description"] = $conn->error; 
            }                             
            CloseCon($conn);    
        } catch (Exception $e) {
            $response["message"]["type"] = "DataBase"; 
            $response["message"]["description"] = $e->getMessage(); 
        }
        $response["statusCode"] = $statusCode;	   
	    $response["data"] = $usuarios;
        return json_encode($response);
    }


    function findAllAttr($arrayAttr){
        $usuarios = array();               
        $response = array();
        $statusCode=500;
        $mensaje='';	
        try {
            $conn=OpenCon();
            $sql ="select * from ".$this->tabla;
            $result = $conn->query($sql);
            if ( $result) {
                $usuarios = $this->leerResultadoAttr($result, $arrayAttr); 
                $statusCode=200; 
                $response["message"]["type"] = "OK"; 
                $response["message"]["description"] = "Consulta Correcta"; 
            }else {
                $statusCode=200; 
                $response["message"]["type"] = "DataBase"; 
                $response["message"]["description"] = $conn->error; 
            }                             
            CloseCon($conn);    
        } catch (Exception $e) {
            $response["message"]["type"] = "DataBase"; 
            $response["message"]["description"] = $e->getMessage(); 
        }
        $response["statusCode"] = $statusCode;	   
	    $response["data"] = $usuarios;
        return json_encode($response);
    }


    function login($usuario, $pass){
        $usuarios = array();               
        $response = array();
        $statusCode=500;
        $mensaje='';	
        try {
            $conn=OpenCon();
            $sql ="select * from ".$this->tabla." where usuario = ".$usuario." and  contrasenia = ".$pass;
            $result = $conn->query($sql);
            if ( $result) {
                if ($result->num_rows > 0) {
                    $usuarios = $this->leerResultadoAttr($result, [1,2]); 
                }else{
                    $statusCode=403; 
                    $response["message"]["type"] = "ERR"; 
                    $response["message"]["description"] = "Credenciales Incorrectas";
                }

                
                $statusCode=200; 
                $response["message"]["type"] = "OK"; 
                $response["message"]["description"] = "Ingreso Correcto"; 
            }else {
                $response["message"]["type"] = "DataBase"; 
                $response["message"]["description"] = $conn->error; 
            }                             
            CloseCon($conn);    
        } catch (Exception $e) {
            $response["message"]["type"] = "DataBase"; 
            $response["message"]["description"] = $e->getMessage(); 
        }
        $response["statusCode"] = $statusCode;	   
	    $response["data"] = $usuarios;
        return json_encode($response);
    }


}