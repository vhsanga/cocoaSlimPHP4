<?php
include_once  ROOT_PATH.'/app/Conexion.php';
/**
* this class represents a usuario
*/
class IngresoEgresoRepositorio 
{
    protected $atributos = ['id','usuario', 'tipooperacion', 'signo', 'valor', 'fecha', 'concepto' ];
    protected $tabla="ingresoegreso";
    protected $tablaConcepto="concepto";

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

    function findByUsuario($idUsuario){
        $usuarios = array();               
        $response = array();
        $statusCode=500;
        $mensaje='';	
        try {            
            $conn=OpenCon();            
            $stmt = $conn->prepare('select ie.id, ie.usuario, ie.tipooperacion, case when ie.tipooperacion =\'ING\' then \'+\'  else  \'-\' end as signo,    ie.valor, ie.fecha, c.codigo as concepto from '.$this->tabla.' ie inner join '.$this->tablaConcepto.' c where ie.usuario=? ');
            $stmt->bind_param('i', $idUsuario); // 's' specifies the variable type => 'string' a las dos variables            
            $stmt->execute();
            $result = $stmt->get_result();
            if ( $result) {
                $usuarios = $this->leerResultado($result, $this->atributos); 
                $statusCode=200; 
                $response["message"]["type"] = "OK"; 
                $response["message"]["description"] = "Consulta Correcta";                                               
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

    function registrarGasto($input){  
        $usuario = $input->usuario;      
        $concepto = $input->concepto;
        $valor = $input->valor;
        $tipooperacion = $input->tipooperacion;
       
        $data = array();               
        $response = array();
        $statusCode=500;
        $mensaje='';	
        try {
            $conn=OpenCon();            
            $stmt = $conn->prepare('INSERT INTO '.$this->tabla.' (usuario, tipooperacion, concepto, valor,  fecha) values (?,?,?,?,now())  ');
            $stmt->bind_param('isid', $usuario, $tipooperacion, $concepto, $valor); // 's' specifies the variable type => 'string' a las dos variables            
            $status = $stmt->execute();  
            $id = $conn->insert_id;
            if ($status === false) {    
                $response["message"]["type"] = "DataBase" ;
                $response["message"]["description"] = $stmt->error;
            }else{
                $statusCode=200; 
                $response["message"]["type"] = "OK"; 
                $response["message"]["description"] = "Valor ingresado correctamente"; 
                $data = array('id'=>$id ) ;
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