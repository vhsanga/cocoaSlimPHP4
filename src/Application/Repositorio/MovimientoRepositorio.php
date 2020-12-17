<?php
include_once  ROOT_PATH.'/app/Conexion.php';
/**
* this class represents a usuario
*/
class MovimientoRepositorio 
{
    protected $atributos = ['id','usuario', 'tipooperacion', 'signo', 'valor', 'fecha', 'concepto' ];
    protected $atributosResumen = ['anio','mes', 'registros', 'valor' ];
    protected $atributosConceptos = ['id','concepto', 'registros', 'valor' ];
    protected $tabla="movimiento";
    protected $tablaConcepto="concepto";
    protected $tablaCta="cuenta";
    protected $tablaAsientoContable="asientocontable";

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
            $stmt = $conn->prepare('select ie.id, ie.usuario, ie.tipooperacion, case when ie.tipooperacion =\'ING\' then \'+\' end as signo,    ie.valor, ie.fecha, c.codigo as concepto from '.$this->tabla.' ie inner join '.$this->tablaConcepto.' c  on ie.concepto=c.id   where ie.usuario=? and  ie.fecha between ? and ? ');
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
            $stmt = $conn->prepare('select year(fecha) as anio,'. 
            ' case when  month(fecha) =1 then \'Enero\'  '.
            '  when  month(fecha) =2 then \'Febrero\'  '.
            '  when  month(fecha) =3 then \'Marzo\'  '.
            '  when  month(fecha) =4 then \'Abril\'  '.
            '  when  month(fecha) =5 then \'Mayo\'  '.
            '  when  month(fecha) =6 then \'Junio\'  '.
            '  when  month(fecha) =7 then \'Julio\'  '.
            '  when  month(fecha) =8 then \'Agosto\'  '.
            '  when  month(fecha) =9 then \'Septiembre\'  '.
            '  when  month(fecha) =10 then \'Octubre\'  '.
            '  when  month(fecha) =11 then \'Noviembre\'  '.
            '  when  month(fecha) =12 then \'Diciembre\'  '.
            '  end as   mes, month(fecha) as _mes,'.
            ' count(id) as registros, sum(valor) as valor from ingresoegreso where usuario=? GROUP BY 1,2,3  ORDER by _mes asc');
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




    /**
     * Listar un resumen de ingresos-egresos  agrupados por meses
     */
    function findResumenConceptoByUsuario($idUsuario){
        $usuarios = array();               
        $response = array();
        $statusCode=500;
        $mensaje='';	
        try {            
            $conn=OpenCon();            
            $stmt = $conn->prepare('select ie.concepto as id, c.codigo  as concepto, '.
                'count(ie.id) as registros, sum(ie.valor) as valor '.
                'from ingresoegreso ie inner join concepto c on ie.concepto = c.id where ie.usuario=? '.
                'GROUP BY 1 '.
                'ORDER by valor asc');
            $stmt->bind_param('i', $idUsuario); // 's' specifies the variable type => 'string' a las dos variables            
            $stmt->execute();
            $result = $stmt->get_result();
            if ( $result) {
                $usuarios = $this->leerResultado($result, $this->atributosConceptos); 
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

    function registrarIngreso($input){  
        $usuario = $input->usuario;      
        $conceptocredito = $input->conceptocredito;
        $conceptodebito = $input->conceptodebito;
        $valor = $input->valor;
        $tipooperacion = $input->tipooperacion;
        $compania = $input->compania;
        $cuentacredito = $input->cuentacredito;

       
        $data = array();               
        $response = array();
        $statusCode=500;
        $mensaje='';	
        try {
            $conn=OpenCon();            
            $stmt = $conn->prepare('INSERT INTO '.$this->tabla.' (usuario, tipooperacion, valor,  fecha, compania) values (?,?,?,now(),?)  ');
            $stmt->bind_param('isdi', $usuario, $tipooperacion, $valor, $compania); // 's' specifies the variable type => 'string' a las dos variables            
            $status = $stmt->execute();  
            $idMovimiento = $conn->insert_id;
            if ($status === false) {    
                $response["message"]["type"] = "DataBase" ;
                $response["message"]["description"] = $stmt->error;
            }else{

                $stmt = $conn->prepare('INSERT INTO '.$this->tablaAsientoContable.' (movimiento, concepto, debe) values (?,?,?)  ');
                $stmt->bind_param('iid', $idMovimiento,  $conceptocredito, $valor); // 's' specifies the variable type => 'string' a las dos variables            
                $status = $stmt->execute();       
                
                $stmt = $conn->prepare('INSERT INTO '.$this->tablaAsientoContable.' (movimiento, concepto, haber) values (?,?,?)  ');
                $stmt->bind_param('iid', $idMovimiento,  $conceptodebito, $valor); // 's' specifies the variable type => 'string' a las dos variables            
                $status = $stmt->execute();  


                $stmt = $conn->prepare('UPDATE '.$this->tablaConcepto.' SET saldo = saldo + ? where id= ?  ');
                $stmt->bind_param('di', $valor,  $concepto); // 's' specifies the variable type => 'string' a las dos variables            
                $status = $stmt->execute();        
                if ($status === false) {    
                    $response["message"]["type"] = "DataBase" ;
                    $response["message"]["description"] = $stmt->error;
                }else{
                    $stmt = $conn->prepare('UPDATE '.$this->tablaCta.' SET saldo = saldo + ? where id= ?  ');
                    $stmt->bind_param('di', $valor,  $cuentacredito); // 's' specifies the variable type => 'string' a las dos variables            
                    $status = $stmt->execute();        
                    if ($status === false) {    
                        $response["message"]["type"] = "DataBase" ;
                        $response["message"]["description"] = $stmt->error;
                    }else{
                        $statusCode=200; 
                        $response["message"]["type"] = "OK"; 
                        $response["message"]["description"] = "Valor ingresado correctamente"; 
                    } 
                }    
                
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


    function registrarEgreso($input){  
        $usuario = $input->usuario;      
        $concepto = $input->concepto;
        $valor = $input->valor;
        $tipooperacion = $input->tipooperacion;
        $compania = $input->compania;
        $conceptopadre = $input->conceptopadre;
        $idcuenta = $input->idcuenta;
        $idcuentapadre = $input->idcuentapadre;

        $data = array();               
        $response = array();
        $statusCode=500;
        $mensaje='';	
        try {
            $conn=OpenCon();            
            $stmt = $conn->prepare('INSERT INTO '.$this->tabla.' (usuario, tipooperacion, concepto, valor,  fecha, compania, conceptopadre) values (?,?,?,?,now(),?,?)  ');
            $stmt->bind_param('isidii', $usuario, $tipooperacion, $concepto, $valor, $compania, $conceptopadre); // 's' specifies the variable type => 'string' a las dos variables            
            $status = $stmt->execute();  
            $id = $conn->insert_id;
            if ($status === false) {    
                $response["message"]["type"] = "DataBase" ;
                $response["message"]["description"] = $stmt->error;
            }else{

                $stmt = $conn->prepare('UPDATE '.$this->tablaConcepto.' SET saldo = saldo + ? where id= ?  ');
                $stmt->bind_param('di', $valor,  $conceptopadre); // 's' specifies the variable type => 'string' a las dos variables            
                $status = $stmt->execute();        
                if ($status === false) {    
                    $response["message"]["type"] = "DataBase" ;
                    $response["message"]["description"] = $stmt->error;
                }else{
                    $stmt = $conn->prepare('UPDATE '.$this->tablaConcepto.' SET saldo = saldo + ? where id= ?  ');
                    $val_=$valor*(-1);
                    $stmt->bind_param('di', $val_,  $concepto); // 's' specifies the variable type => 'string' a las dos variables            
                    $status = $stmt->execute();        
                    if ($status === false) {    
                        $response["message"]["type"] = "DataBase" ;
                        $response["message"]["description"] = $stmt->error;
                    }else{
                        $stmt = $conn->prepare('UPDATE '.$this->tablaCta.' SET saldo = saldo + ? where id= ?  ');
                        $stmt->bind_param('di', $valor,  $idcuentapadre); // 's' specifies the variable type => 'string' a las dos variables            
                        $status = $stmt->execute();        
                        if ($status === false) {    
                            $response["message"]["type"] = "DataBase" ;
                            $response["message"]["description"] = $stmt->error;
                        }else{
                            $stmt = $conn->prepare('UPDATE '.$this->tablaCta.' SET saldo = saldo + ? where id= ?  ');
                            $val_=$valor*(-1);
                            $stmt->bind_param('di', $val_,  $idcuenta); // 's' specifies the variable type => 'string' a las dos variables            
                            $status = $stmt->execute();        
                            if ($status === false) {    
                                $response["message"]["type"] = "DataBase" ;
                                $response["message"]["description"] = $stmt->error;
                            }else{
                                $statusCode=200; 
                                $response["message"]["type"] = "OK"; 
                                $response["message"]["description"] = "Valor ingresado correctamente"; 
                                $data = array('id'=>$id ) ;
                            }
                        } 
                    }
                }    
                
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