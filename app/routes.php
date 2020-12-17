<?php
declare(strict_types=1);

use App\Application\Actions\User\ListUsersAction;
use App\Application\Actions\User\ViewUserAction;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\App;
use Slim\Interfaces\RouteCollectorProxyInterface as Group;
define('ROOT_PATH', dirname(__DIR__) );


require_once  ROOT_PATH.'/src/Application/Repositorio/UsuarioRepositorio.php';
require_once  ROOT_PATH.'/src/Application/Repositorio/CatalogoRepositorio.php';
require_once  ROOT_PATH.'/src/Application/Repositorio/ConceptoRepositorio.php';
require_once  ROOT_PATH.'/src/Application/Repositorio/MovimientoRepositorio.php';

return function (App $app) {
    $app->options('/{routes:.*}', function (Request $request, Response $response) {
        // CORS Pre-Flight OPTIONS Request Handler
        return $response;
    });

    $app->get('/', function (Request $request, Response $response) {
        $response->getBody()->write('Hello world!');
        return $response;
    });

    $app->group('/users', function (Group $group) {
        $group->get('', ListUsersAction::class);
        $group->get('/{id}', ViewUserAction::class);
    });

    /**
     * catalogo y detallecatalogo  *************************************************************
     */

    $app->get('/catalogos', function (Request $request, Response $response) use($app) {               
        $catalogoRepo = new CatalogoRepositorio;
        $catalogos = $catalogoRepo->findAll();        
        $response->getBody()->write($catalogos);        
        return $response
                ->withHeader('Content-Type', 'application/json');
    });

    /**
     * usuario  ********************************************************************************
     */

    $app->get('/usuarios', function (Request $request, Response $response) use($app) {               
        $usuarioRepo = new UsuarioRepositorio;
        $usuarios = $usuarioRepo->findAll([1,2]);        
        $response->getBody()->write($usuarios);        
        return $response
                ->withHeader('Content-Type', 'application/json');
    });

    $app->get('/usuarioscompania/{idCompania}', function (Request $request, Response $response) use($app) {               
        $usuarioRepo = new UsuarioRepositorio;
        $idCompania = $request->getAttribute('idCompania');
        $usuarios = $usuarioRepo->findAllByCompania($idCompania);        
        $response->getBody()->write($usuarios);        
        return $response
                ->withHeader('Content-Type', 'application/json');
    });

    $app->post('/login', function (Request $request, Response $response) use($app) {               
        $usuarioRepo = new UsuarioRepositorio;
        $params = (array)$request->getParsedBody();    
        $input = json_decode(file_get_contents('php://input'));
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new HttpBadRequestException($this->request, 'Malformed JSON input.');
        }        
        $usuarios = $usuarioRepo->login($input);        
        $response->getBody()->write($usuarios);        
        return $response->withHeader('Content-Type', 'application/json');;
    });

    $app->post('/usuario/registrar', function (Request $request, Response $response) use($app) {               
        $usuarioRepo = new UsuarioRepositorio;
        $params = (array)$request->getParsedBody();    
        $input = json_decode(file_get_contents('php://input'));
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new HttpBadRequestException($this->request, 'Malformed JSON input.');
        }        
        $usuarios = $usuarioRepo->registrarUsuario($input);        
        $response->getBody()->write($usuarios);        
        return $response->withHeader('Content-Type', 'application/json');;
    });

    $app->post('/usuario/cambiarcontrasenia', function (Request $request, Response $response) use($app) {               
        $usuarioRepo = new UsuarioRepositorio;
        $params = (array)$request->getParsedBody();    
        $input = json_decode(file_get_contents('php://input'));
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new HttpBadRequestException($this->request, 'Malformed JSON input.');
        }        
        $usuarios = $usuarioRepo->cambiarContrasenia($input);        
        $response->getBody()->write($usuarios);        
        return $response->withHeader('Content-Type', 'application/json');;
    });


    /**
     * concepto  *******************************************************************************
     */

    $app->post('/concepto/registrar', function (Request $request, Response $response) use($app) {               
        $conceptoRepo = new ConceptoRepositorio;
        $params = (array)$request->getParsedBody();    
        $input = json_decode(file_get_contents('php://input'));
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new HttpBadRequestException($this->request, 'Malformed JSON input.');
        }        
        $data = $conceptoRepo->registrarConcepto($input);        
        $response->getBody()->write($data);        
        return $response->withHeader('Content-Type', 'application/json');;
    });

    $app->get('/conceptos/{idCompania}', function (Request $request, Response $response) use($app) {               
        $conceptoRepo = new ConceptoRepositorio;
        $idCompania = $request->getAttribute('idCompania');
        $data = $conceptoRepo->findByCompania( $idCompania);        
        $response->getBody()->write($data);        
        return $response
                ->withHeader('Content-Type', 'application/json');
    });


    /**
     * Movimiento *************************************************************************
     */

    $app->post('/movimiento/registraringreso', function (Request $request, Response $response) use($app) {               
        $repo = new MovimientoRepositorio;
        $params = (array)$request->getParsedBody();    
        $input = json_decode(file_get_contents('php://input'));
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new HttpBadRequestException($this->request, 'Malformed JSON input.');
        }        
        $data = $repo->registrarIngreso($input);        
        $response->getBody()->write($data);        
        return $response->withHeader('Content-Type', 'application/json');;
    });

    $app->post('/movimiento/registraregreso', function (Request $request, Response $response) use($app) {               
        $repo = new MovimientoRepositorio;
        $params = (array)$request->getParsedBody();    
        $input = json_decode(file_get_contents('php://input'));
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new HttpBadRequestException($this->request, 'Malformed JSON input.');
        }        
        $data = $repo->registrarEgreso($input);        
        $response->getBody()->write($data);        
        return $response->withHeader('Content-Type', 'application/json');;
    });

    $app->get('/movimiento/resumen/{idUsuario}', function (Request $request, Response $response) use($app) {               
        $repo = new MovimientoRepositorio;
        $idUsuario = $request->getAttribute('idUsuario');
        $data = $repo->findByUsuarioResumen( $idUsuario);        
        $response->getBody()->write($data);        
        return $response
                ->withHeader('Content-Type', 'application/json');
    });

    $app->get('/movimiento/{idUsuario}/{fInicio}/{fFin}', function (Request $request, Response $response) use($app) {               
        $repo = new MovimientoRepositorio;
        $idUsuario = $request->getAttribute('idUsuario');
        $fInicio = $request->getAttribute('fInicio');
        $fFin = $request->getAttribute('fFin');
        $data = $repo->findByUsuarioAndFecha( $idUsuario, $fInicio, $fFin);        
        $response->getBody()->write($data);        
        return $response
                ->withHeader('Content-Type', 'application/json');
    });

    $app->get('/movimiento/conceptoresumen/{idUsuario}', function (Request $request, Response $response) use($app) {               
        $repo = new MovimientoRepositorio;
        $idUsuario = $request->getAttribute('idUsuario');
        $fInicio = $request->getAttribute('fInicio');
        $fFin = $request->getAttribute('fFin');
        $data = $repo->findResumenConceptoByUsuario( $idUsuario, $fInicio, $fFin);        
        $response->getBody()->write($data);        
        return $response
                ->withHeader('Content-Type', 'application/json');
    });


};

