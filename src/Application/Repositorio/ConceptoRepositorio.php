<?php
include_once  ROOT_PATH.'/app/Conexion.php';
/**
* this class represents a usuario
*/
class ConceptoRepositorio 
{
    protected $atributos = ['id','codigo', 'descripcion', 'observacion', 'usuario', 'fregistro', 'compania', 'saldo', 'cuenta' ];
    protected $tabla="concepto";
    protected $tablaCuenta="cuenta";
    

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

    function findByCompania($idCompania){
        $usuarios = array();               
        $response = array();
        $statusCode=500;
        $mensaje='';	
        try {
            $conn=OpenCon();
            $sql ="select * from ".$this->tabla.' where usuario=? ';
            
            $conn=OpenCon();            
            $stmt = $conn->prepare('select c.id, c.codigo, c.descripcion, c.observacion, c.usuario, c.fregistro,  c.compania, c.saldo, cu.codigo cuenta from '.$this->tabla.' c inner join    '.$this->tablaCuenta.' cu on c.cuenta=cu.id  where c.compania=? ');
            $stmt->bind_param('i', $idCompania); // 's' specifies the variable type => 'string' a las dos variables            
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

    function registrarConcepto($input){        
        $codigo = $input->codigo;
        $descripcion = $input->descripcion;
        $observacion = $input->observacion;
        $usuario = $input->usuario;
        $compania = $input->compania;
       
        $data = array();               
        $response = array();
        $statusCode=500;
        $mensaje='';	
        try {
            $conn=OpenCon();            
            $stmt = $conn->prepare('INSERT INTO '.$this->tabla.' (codigo, descripcion, observacion, usuario, fregistro, compania) values (?,?,?,?,now(),?)  ');
            $stmt->bind_param('sssii', $codigo, $descripcion, $observacion, $usuario, $compania); // 's' specifies the variable type => 'string' a las dos variables            
            $status = $stmt->execute();  
            $idConcepto = $conn->insert_id;
            if ($status === false) {    
                $response["message"]["type"] = "DataBase" ;
                $response["message"]["description"] = $stmt->error;
            }else{
                $statusCode=200; 
                $response["message"]["type"] = "OK"; 
                $response["message"]["description"] = "Concepto ingresado correctamente"; 
                $data = array('id'=>$idConcepto ) ;
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