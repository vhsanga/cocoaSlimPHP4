DROP TABLE cocoa.usuariopersona;
DROP TABLE cocoa.persona;
DROP TABLE cocoa.ingresoegreso;
DROP TABLE cocoa.gasto;
DROP TABLE cocoa.concepto;
DROP TABLE cocoa.usuario;
DROP TABLE cocoa.detallecatalogo;
DROP TABLE cocoa.catalogo;



CREATE TABLE `catalogo` (
  `codigo` varchar(7) NOT NULL,
  `descripcion` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `detallecatalogo` (
  `codigo` varchar(7) NOT NULL,
  `descripcion` varchar(64) DEFAULT NULL,
  `catalogo` varchar(7) NOT NULL,
  PRIMARY KEY (`codigo`),
  KEY `detallecatalogo_catalogo_fk` (`catalogo`),
  CONSTRAINT `detallecatalogo_catalogo_fk` FOREIGN KEY (`catalogo`) REFERENCES `catalogo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `usuario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(16) NOT NULL,
  `contrasenia` varchar(128) NOT NULL,
  `estadousuario` varchar(7) NOT NULL,
  `fregistro` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_usuario_idx` (`usuario`) USING BTREE,
  KEY `usuario_detallecatalogo_fk` (`estadousuario`),
  CONSTRAINT `usuario_detallecatalogo_fk` FOREIGN KEY (`estadousuario`) REFERENCES `detallecatalogo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;



CREATE TABLE `concepto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(16) NOT NULL,
  `descripcion` varchar(64) NOT NULL,
  `observacion` varchar(128) DEFAULT NULL,
  `usuario` int(11) NOT NULL,
  `fregistro` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `concepto_codigo_idx` (`codigo`) USING BTREE,
  KEY `concepto_usuario_fk` (`usuario`),
  CONSTRAINT `concepto_usuario_fk` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;



CREATE TABLE `gasto` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `usuario` int(11) NOT NULL,
  `concepto` int(11) NOT NULL,
  `valor` decimal(15,2) NOT NULL,
  `fecha` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gasto_concepto_fk` (`concepto`),
  KEY `gasto_usuario_fk` (`usuario`),
  CONSTRAINT `gasto_concepto_fk` FOREIGN KEY (`concepto`) REFERENCES `concepto` (`id`),
  CONSTRAINT `gasto_usuario_fk` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `ingresoegreso` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `usuario` int(11) NOT NULL,
  `tipooperacion` varchar(7) NOT NULL,
  `valor` decimal(15,2) NOT NULL DEFAULT '0.00',
  `fecha` datetime NOT NULL,
  `concepto` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ingresoegreso_detallecatalogo_fk` (`tipooperacion`),
  KEY `ingresoegreso_usuario_fk` (`usuario`),
  KEY `ingresoegreso_concepto_fk` (`concepto`),
  CONSTRAINT `ingresoegreso_concepto_fk` FOREIGN KEY (`concepto`) REFERENCES `concepto` (`id`),
  CONSTRAINT `ingresoegreso_detallecatalogo_fk` FOREIGN KEY (`tipooperacion`) REFERENCES `detallecatalogo` (`codigo`),
  CONSTRAINT `ingresoegreso_usuario_fk` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `persona` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identificacion` varchar(13) NOT NULL,
  `nombres` varchar(64) NOT NULL,
  `apellidos` varchar(64) DEFAULT NULL,
  `fnacimiento` date DEFAULT NULL,
  `direccion` varchar(128) DEFAULT NULL,
  `telefono` varchar(10) DEFAULT NULL,
  `correo` varchar(64) DEFAULT NULL,
  `tipoidentificacion` varchar(7) DEFAULT NULL,
  `fregistro` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `persona_identificacion_idx` (`identificacion`) USING BTREE,
  KEY `persona_detallecatalogo_fk` (`tipoidentificacion`),
  CONSTRAINT `persona_detallecatalogo_fk` FOREIGN KEY (`tipoidentificacion`) REFERENCES `detallecatalogo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;



CREATE TABLE `usuariopersona` (
  `usuario` int(11) NOT NULL,
  `persona` int(11) NOT NULL,
  PRIMARY KEY (`usuario`,`persona`),
  UNIQUE KEY `usuariopersona_usuario_idx` (`usuario`) USING BTREE,
  UNIQUE KEY `usuariopersona_persona_idx` (`persona`) USING BTREE,
  KEY `usuariopersona_persona_fk` (`persona`),
  CONSTRAINT `usuariopersona_persona_fk` FOREIGN KEY (`persona`) REFERENCES `persona` (`id`),
  CONSTRAINT `usuariopersona_usuario_fk` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;





-----------------------------------------

INSERT INTO cocoa.catalogo
(codigo, descripcion)
VALUES('EST_USU', 'Estado de Usuario');
INSERT INTO cocoa.catalogo
(codigo, descripcion)
VALUES('TIP_ID', 'Tipo Identificación');
INSERT INTO cocoa.catalogo
(codigo, descripcion)
VALUES('TIP_OPE', 'Tipo de Operación');



INSERT INTO cocoa.detallecatalogo
(codigo, descripcion, catalogo)
VALUES('ACT', 'Usuario Activo', 'EST_USU');
INSERT INTO cocoa.detallecatalogo
(codigo, descripcion, catalogo)
VALUES('CED', 'Cédula', 'TIP_ID');
INSERT INTO cocoa.detallecatalogo
(codigo, descripcion, catalogo)
VALUES('DESACT', 'Usuario Desactivado', 'EST_USU');
INSERT INTO cocoa.detallecatalogo
(codigo, descripcion, catalogo)
VALUES('EGR', 'Egreso', 'TIP_OPE');
INSERT INTO cocoa.detallecatalogo
(codigo, descripcion, catalogo)
VALUES('ING', 'Ingreso', 'TIP_OPE');
INSERT INTO cocoa.detallecatalogo
(codigo, descripcion, catalogo)
VALUES('RUC', 'Ruc', 'TIP_ID');


INSERT INTO cocoa.usuario
(id, usuario, contrasenia, estadousuario)
VALUES(1, 'user', '123', 'ACT');
INSERT INTO cocoa.usuario
(id, usuario, contrasenia, estadousuario)
VALUES(2, '001', '123', 'ACT');


INSERT INTO cocoa.persona
(id, identificacion, nombres, apellidos, fnacimiento, direccion, telefono, correo, tipoidentificacion)
VALUES(1, '0603765059', 'Jose', ' de la cuadra', '1991-12-06', 'Av de la prtensa', '032646154', 'jose@gmail.com', 'CED');
INSERT INTO cocoa.persona
(id, identificacion, nombres, apellidos, fnacimiento, direccion, telefono, correo, tipoidentificacion)
VALUES(2, '1715452541', 'Miguel ', 'rosales', '1991-12-06', 'Av los shirys', '0976565412', 'miguelito@gmail.co', 'CED');


INSERT INTO cocoa.usuariopersona
(usuario, persona)
VALUES(1, 1);
INSERT INTO cocoa.usuariopersona
(usuario, persona)
VALUES(2, 2);


INSERT INTO cocoa.concepto
(id, codigo, descripcion, observacion, usuario)
VALUES(3, 'Sueldo', 'Sueldo mensual', 'mensual', 1);
INSERT INTO cocoa.concepto
(id, codigo, descripcion, observacion, usuario)
VALUES(4, 'Ventas', 'ingreso de ventas', '', 1);
INSERT INTO cocoa.concepto
(id, codigo, descripcion, observacion, usuario)
VALUES(5, 'Compras', 'egreso por compras', '', 1);
INSERT INTO cocoa.concepto
(id, codigo, descripcion, observacion, usuario)
VALUES(6, 'Arriendo', 'Pago mensual de arriendo', '', 1);