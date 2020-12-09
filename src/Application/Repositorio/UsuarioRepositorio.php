<?php
include_once  ROOT_PATH.'/app/Conexion.php';
/**
* this class represents a usuario
*/
class UsuarioRepositorio 
{
    
    protected $atributos = ['id','usuario', 'contrasenia','estadousuario','compania' ];
    protected $atributosLogin = ['id','usuario', 'identificacion','nombres', 'apellidos', 'compania' ];
    protected $tabla="usuario";
    protected $tablaUsarioPersona="usuariopersona";
    protected $tablaPersona="persona";
    protected $ESTADO_ACTVO="ACT";

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


    function login($input){
        $usuario = $input->usuario;
        $pass = $input->pass;
        $usuarios = array();               
        $response = array();
        $statusCode=500;
        $mensaje='';	
        try {
            $conn=OpenCon();            
            $stmt = $conn->prepare('select u.id, u.usuario, up.persona, p.identificacion, p.nombres, p.apellidos, u.compania  from '.$this->tabla.' u  left join '.$this->tablaUsarioPersona.' up on up.usuario=u.id  left join '.$this->tablaPersona.' p on up.persona=p.id where u.usuario= ? and u.contrasenia = ?  and u.estadousuario="ACT"  ');
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
            $stmt->close();
            $conn->close();    
        } catch (Exception $e) {
            $response["message"]["type"] = "DataBase"; 
            $response["message"]["description"] = $e->getMessage(); 
        }
        $response["statusCode"] = $statusCode;	   
	    $response["data"] = $usuarios;
        return json_encode($response);
    }


    function registrarUsuario($input){
        $usuario = $input->usuario;
        $pass = $input->pass;
        $compania = $input->compania;
        
        $identificacion = $input->identificacion;
        $nombres = $input->nombres;
        $apellidos = $input->apellidos;
        $fnacimiento = $input->fnacimiento;
        $direccion = $input->direccion;
        $telefono = $input->telefono;
        $correo = $input->correo;
        $tipoidentificacion = $input->tipoidentificacion;
        $data = array();               
        $response = array();
        $statusCode=500;
        $mensaje='';	
        try {
            $conn=OpenCon();            
            $stmt = $conn->prepare('INSERT INTO '.$this->tabla.' (usuario, contrasenia, estadousuario, fregistro, compania) values (?,?,?,now(),?)  ');
            $stmt->bind_param('sssi', $usuario, $pass, $this->ESTADO_ACTVO,$compania); // 's' specifies the variable type => 'string' a las dos variables            
            $stmt->execute();
            $idUsuario = $conn->insert_id;

            $stmt = $conn->prepare('INSERT INTO '.$this->tablaPersona.' (identificacion, nombres, apellidos, fnacimiento, direccion, telefono, correo, tipoidentificacion, fregistro) values (?,?,?,?,?,?,?,?,now())  ');
            $stmt->bind_param('ssssssss', $identificacion, $nombres, $apellidos, $fnacimiento, $direccion, $telefono, $correo, $tipoidentificacion); // 's' specifies the variable type => 'string' a las dos variables            
            $stmt->execute();
            $idPersona = $conn->insert_id;

            $stmt = $conn->prepare('INSERT INTO '.$this->tablaUsarioPersona.' (usuario, persona) values (?,?)  ');
            $stmt->bind_param('ii', $idUsuario, $idPersona); // 'i' specifies the variable type => 'entero' a las dos variables            
            $stmt->execute();
            $idPersona = $conn->insert_id;
                           
            $statusCode=200; 
            $response["message"]["type"] = "OK"; 
            $response["message"]["description"] = "Usuario Registrado correctamente";                                               
                                         
            $stmt->close();
            $conn->close();    
        } catch (Exception $e) {
            $response["message"]["type"] = "DataBase"; 
            $response["message"]["description"] = $e->getMessage(); 
        }
        $response["statusCode"] = $statusCode;	   
	    $response["data"] = $data;
        return json_encode($response);
    }



    function cambiarContrasenia($input){
        $usuario = $input->usuario;
        $pass = $input->pass;
               
        $data = array();               
        $response = array();
        $statusCode=500;
        $mensaje='';	
        try {
            $conn=OpenCon();            
            $stmt = $conn->prepare('UPDATE '.$this->tabla.' SET contrasenia = ? where id= ?  ');
            $stmt->bind_param('si', $pass,  $usuario); // 's' specifies the variable type => 'string' a las dos variables            
            $status = $stmt->execute();        
            if ($status === false) {    
                $response["message"]["type"] = "DataBase" ;
                $response["message"]["description"] = $stmt->error;
            }else{
                $statusCode=200; 
                $response["message"]["type"] = "OK"; 
                $response["message"]["description"] = "Contraseña cambiada correctamente"; 
            }                                                                                                                    
            $stmt->close();
            $conn->close();    
        } catch (Exception $e) {
            $response["message"]["type"] = "DataBase"; 
            $response["message"]["description"] = $e->getMessage(); 
        }
        $response["statusCode"] = $statusCode;	   
	    $response["data"] = $data;
        return json_encode($response);
    }


    


}