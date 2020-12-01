<?php
include_once  ROOT_PATH.'/app/Conexion.php';
/**
* this class represents a usuario
*/
class IngresoEgresoRepositorio 
{
    protected $atributos = ['id','usuario', 'tipooperacion', 'signo', 'valor', 'fecha', 'concepto' ];
    protected $atributosResumen = ['anio','mes', 'registros', 'valor' ];
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

    function findByUsuarioAndFecha($idUsuario, $fInicio, $fFin){
        $usuarios = array();               
        $response = array();
        $statusCode=500;
        $mensaje='';	
        try {            
            $conn=OpenCon();            
            $stmt = $conn->prepare('select ie.id, ie.usuario, ie.tipooperacion, case when ie.tipooperacion =\'ING\' then \'+\'  else  \'-\' end as signo,    ie.valor, ie.fecha, c.codigo as concepto from '.$this->tabla.' ie inner join '.$this->tablaConcepto.' c  on ie.concepto=c.id   where ie.usuario=? and  ie.fecha between ? and ? ');
            $stmt->bind_param('iss', $idUsuario,$fInicio, $fFin); // 's' specifies the variable type => 'string' a las dos variables            
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



    /**
     * Listar un resumen de ingresos-egresos  agrupados por meses
     */
    function findByUsuarioResumen($idUsuario){
        $usuarios = array();               
        $response = array();
        $statusCode=500;
        $mensaje='';	
        try {            
            $conn=OpenCon();            
            $stmt = $conn->prepare('select year(fecha) as anio, month(fecha) as mes, count(id) as registros, sum(valor) as valor from ingresoegreso where usuario=? GROUP BY YEAR(fecha),month(fecha)            ');
            $stmt->bind_param('i', $idUsuario); // 's' specifies the variable type => 'string' a las dos variables            
            $stmt->execute();
            $result = $stmt->get_result();
            if ( $result) {
                $usuarios = $this->leerResultado($result, $this->atributosResumen); 
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