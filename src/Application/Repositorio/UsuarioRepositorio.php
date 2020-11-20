<?php
include  ROOT_PATH.'/app/Conexion.php';
/**
* this class represents a person
*/
class UsuarioRepositorio 
{
    
    protected $atributos = ['id','usuario', 'contrasenia','estadousuario' ];
    protected $atributosLogin = ['id','usuario', 'identificacion','nombres', 'apellidos' ];
    protected $tabla="usuario";
    protected $tablaUsarioPersona="usuariopersona";
    protected $tablaPersona="persona";

    private function leerResultado($result, $arrAtrib){  
        $usuarios = array();       
        while($row = $result->fetch_assoc()) {
            $fila = array(); 
            foreach ($arrAtrib as $columna)  {
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
                $usuarios = $this->leerResultado($result,$this->atributos ); 
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
                $statusCode=201; 
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
            $stmt = $conn->prepare('select u.id, u.usuario, up.persona, p.identificacion, p.nombres, p.apellidos  from '.$this->tabla.' u  left join '.$this->tablaUsarioPersona.' up on up.usuario=u.id  left join '.$this->tablaPersona.' p on up.persona=p.id where u.usuario= ? and u.contrasenia = ?  and u.estadousuario="ACT"  ');
            $stmt->bind_param('ss', $usuario, $pass); // 's' specifies the variable type => 'string' a las dos variables            
            $stmt->execute();
            $result = $stmt->get_result();
            if ( $result) {
                if ($result->num_rows > 0) {
                    $usuarios = $this->leerResultado($result, $this->atributosLogin); 
                    $statusCode=200; 
                    $response["message"]["type"] = "OK"; 
                    $response["message"]["description"] = "Ingreso Correcto"; 
                }else{
                    $statusCode=403; 
                    $response["message"]["type"] = "ERR"; 
                    $response["message"]["description"] = "Credenciales Incorrectas";
                }                                
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