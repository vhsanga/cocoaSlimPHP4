<?php
declare(strict_types=1);

use App\Application\Actions\User\ListUsersAction;
use App\Application\Actions\User\ViewUserAction;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\App;
use Slim\Interfaces\RouteCollectorProxyInterface as Group;
define('ROOT_PATH', dirname(__DIR__) );


require  ROOT_PATH.'/src/Application/Repositorio/UsuarioRepositorio.php';

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

    $app->get('/usuarios', function (Request $request, Response $response) use($app) {               
        $usuarioRepo = new UsuarioRepositorio;
        $usuarios = $usuarioRepo->findAll([1,2]);        
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
        $usuario = $input->usuario;
        $pass = $input->pass;
        $usuarios = $usuarioRepo->login($usuario, $pass);        
        $response->getBody()->write($usuarios);        
        return $response->withHeader('Content-Type', 'application/json');;
    });



};

