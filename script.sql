DROP TABLE cocoa.usuariopersona;
DROP TABLE cocoa.persona;
DROP TABLE cocoa.ingresoegreso;
DROP TABLE cocoa.concepto;
DROP TABLE cocoa.usuario;
DROP TABLE cocoa.cuenta;
DROP TABLE cocoa.compania;
DROP TABLE cocoa.detallecatalogo;
DROP TABLE cocoa.catalogo;


CREATE TABLE `catalogo` (
  `codigo` varchar(7) NOT NULL,
  `descripcion` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `detallecatalogo` (
  `codigo` varchar(7) NOT NULL,
  `catalogo` varchar(7) NOT NULL,
  `descripcion` varchar(64) DEFAULT NULL,  
  PRIMARY KEY (`codigo`,`catalogo`),
  KEY `detallecatalogo_catalogo_fk` (`catalogo`),
  CONSTRAINT `detallecatalogo_catalogo_fk` FOREIGN KEY (`catalogo`) REFERENCES `catalogo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compania` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL, 
  `direccion` varchar(128) DEFAULT NULL,
  `ruc` varchar(13) DEFAULT NULL,
  `telefono` varchar(12) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `representantelegal` varchar(100) DEFAULT NULL,
  `fregistro` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8



CREATE TABLE `cuenta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `codigo` varchar(10) DEFAULT NULL,
  `saldo` decimal(15,2) NOT NULL,
  `observacion` varchar(100) DEFAULT NULL,
  `estadocuenta` varchar(7) DEFAULT NULL,
  `fregistro` date DEFAULT NULL,
  `compania` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cuenta_un` (`codigo`),
  KEY `cuenta_detallecatalogo_fk` (`estadocuenta`),
  KEY `cuenta_compania_fk` (`compania`),
  CONSTRAINT `cuenta_compania_fk` FOREIGN KEY (`compania`) REFERENCES `compania` (`id`),
  CONSTRAINT `cuenta_detallecatalogo_fk` FOREIGN KEY (`estadocuenta`) REFERENCES `detallecatalogo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8



CREATE TABLE `usuario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(16) NOT NULL,
  `contrasenia` varchar(128) NOT NULL,
  `estadousuario` varchar(7) NOT NULL,
  `fregistro` datetime NOT NULL,
  `compania` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_usuario_idx` (`usuario`) USING BTREE,
  KEY `usuario_detallecatalogo_fk` (`estadousuario`),
  CONSTRAINT `usuario_compania_fk` FOREIGN KEY (`compania`) REFERENCES `compania` (`id`),
  CONSTRAINT `usuario_detallecatalogo_fk` FOREIGN KEY (`estadousuario`) REFERENCES `detallecatalogo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;



CREATE TABLE `concepto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(16) NOT NULL,
  `descripcion` varchar(64) NOT NULL,
  `observacion` varchar(128) DEFAULT NULL,
  `usuario` int(11) NOT NULL,
  `fregistro` datetime NOT NULL,
  `cuenta` int(11) DEFAULT NULL,
  `compania` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `concepto_codigo_idx` (`codigo`) USING BTREE,
  KEY `concepto_usuario_fk` (`usuario`),
  KEY `concepto_cuenta_fk` (`cuenta`),
  KEY `concepto_compania_fk` (`compania`),
  CONSTRAINT `concepto_compania_fk` FOREIGN KEY (`compania`) REFERENCES `compania` (`id`),
  CONSTRAINT `concepto_cuenta_fk` FOREIGN KEY (`cuenta`) REFERENCES `cuenta` (`id`),
  CONSTRAINT `concepto_usuario_fk` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8



CREATE TABLE `ingresoegreso` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `usuario` int(11) NOT NULL,
  `tipooperacion` varchar(7) NOT NULL,
  `valor` decimal(15,2) NOT NULL DEFAULT '0.00',
  `fecha` datetime NOT NULL,
  `concepto` int(11) NOT NULL,
  `conceptopadre` int(11) DEFAULT NULL,
  `compania` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ingresoegreso_detallecatalogo_fk` (`tipooperacion`),
  KEY `ingresoegreso_usuario_fk` (`usuario`),
  KEY `ingresoegreso_concepto_fk` (`concepto`),
  KEY `ingresoegreso_concepto_fk_1` (`conceptopadre`),
  CONSTRAINT `ingresoegreso_concepto_fk` FOREIGN KEY (`concepto`) REFERENCES `concepto` (`id`),
  CONSTRAINT `ingresoegreso_concepto_fk_1` FOREIGN KEY (`conceptopadre`) REFERENCES `concepto` (`id`),
  CONSTRAINT `ingresoegreso_detallecatalogo_fk` FOREIGN KEY (`tipooperacion`) REFERENCES `detallecatalogo` (`codigo`),
  CONSTRAINT `ingresoegreso_compania_fk` FOREIGN KEY (`compania`) REFERENCES `compania` (`id`),
  CONSTRAINT `ingresoegreso_usuario_fk` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8



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
  `compania` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `persona_identificacion_idx` (`identificacion`) USING BTREE,
  KEY `persona_detallecatalogo_fk` (`tipoidentificacion`),
  CONSTRAINT `persona_compania_fk` FOREIGN KEY (`compania`) REFERENCES `compania` (`id`),
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


INSERT INTO cocoa.compania (nombre, direccion, ruc, telefono, email, representantelegal, fregistro)
VALUES('Familiar', 'AV UnidadNacional y Chimborazo', '0603765058', '0979636583', 'clienteperosnal@gmail.com', NULL, '2020-12-08');



INSERT INTO cocoa.catalogo (codigo, descripcion)
VALUES('EST_CIA', 'Estado de Compania');
INSERT INTO cocoa.catalogo (codigo, descripcion)
VALUES('EST_USU', 'Estado de Usuario');
INSERT INTO cocoa.catalogo (codigo, descripcion)
VALUES('TIP_ID', 'Tipo Identificación');
INSERT INTO cocoa.catalogo (codigo, descripcion)
VALUES('TIP_OPE', 'Tipo de Operación');
INSERT INTO cocoa.catalogo (codigo, descripcion)
VALUES('EST_CTA', 'Estado de Cuenta');



INSERT INTO cocoa.detallecatalogo (codigo,descripcion,catalogo)
VALUES ('ACT','Compania Activa','EST_CIA');
INSERT INTO cocoa.detallecatalogo (codigo,descripcion,catalogo)
VALUES ('INACT','Compania Inactica','EST_CIA');
INSERT INTO cocoa.detallecatalogo (codigo, descripcion, catalogo)
VALUES('ACT', 'Usuario Activo', 'EST_USU');
INSERT INTO cocoa.detallecatalogo (codigo, descripcion, catalogo)
VALUES('INACT', 'Usuario Inactivo', 'EST_USU');
INSERT INTO cocoa.detallecatalogo (codigo, descripcion, catalogo)
VALUES('BLOQ', 'Usuario Bloqueado', 'EST_USU');
INSERT INTO cocoa.detallecatalogo (codigo, descripcion, catalogo)
VALUES('TEMP', 'Con clave Temporal', 'EST_USU');
INSERT INTO cocoa.detallecatalogo (codigo, descripcion, catalogo)
VALUES('CED', 'Cédula', 'TIP_ID');
INSERT INTO cocoa.detallecatalogo (codigo, descripcion, catalogo)
VALUES('DESACT', 'Usuario Desactivado', 'EST_USU');
INSERT INTO cocoa.detallecatalogo (codigo, descripcion, catalogo)
VALUES('EGR', 'Egreso', 'TIP_OPE');
INSERT INTO cocoa.detallecatalogo (codigo, descripcion, catalogo)
VALUES('ING', 'Ingreso', 'TIP_OPE');
INSERT INTO cocoa.detallecatalogo (codigo, descripcion, catalogo)
VALUES('RUC', 'Ruc', 'TIP_ID');
INSERT INTO cocoa.detallecatalogo (codigo,descripcion,catalogo)
VALUES ('ACT','Cuenta Activa','EST_CTA');
INSERT INTO cocoa.detallecatalogo (codigo,descripcion,catalogo)
VALUES ('INACT','Cuenta Inactica','EST_CTA');
INSERT INTO cocoa.detallecatalogo (codigo,descripcion,catalogo)
VALUES ('CERRADA','Cuenta Cerrada','EST_CTA');
INSERT INTO cocoa.detallecatalogo (codigo,descripcion,catalogo)
VALUES ('BLOQ','Cuenta Bloqueada','EST_CTA');


INSERT INTO cocoa.usuario (id, usuario, contrasenia, estadousuario, fregistro, compania)
VALUES(1, 'user', '123', 'ACT', now(), 1);
INSERT INTO cocoa.usuario (id, usuario, contrasenia, estadousuario, fregistro, compania)
VALUES(2, '001', '123', 'ACT', now(), 1);


INSERT INTO cocoa.persona (id, identificacion, nombres, apellidos, fnacimiento, direccion, telefono, correo, tipoidentificacion, fregistro, compania)
VALUES(1, '0603765059', 'Jose', ' de la cuadra', '1991-12-06', 'Av de la prtensa', '032646154', 'jose@gmail.com', 'CED',  now(), 1);
INSERT INTO cocoa.persona (id, identificacion, nombres, apellidos, fnacimiento, direccion, telefono, correo, tipoidentificacion, fregistro, compania)
VALUES(2, '1715452541', 'Miguel ', 'rosales', '1991-12-06', 'Av los shirys', '0976565412', 'miguelito@gmail.co', 'CED',  now(), 1);


INSERT INTO cocoa.usuariopersona (usuario, persona)
VALUES(1, 1);
INSERT INTO cocoa.usuariopersona (usuario, persona)
VALUES(2, 2);


INSERT INTO cocoa.concepto (id, codigo, descripcion, observacion, usuario, fregistro, compania)
VALUES(3, 'Sueldo', 'Sueldo mensual', 'mensual', 1,  now(), 1);
INSERT INTO cocoa.concepto (id, codigo, descripcion, observacion, usuario, fregistro, compania)
VALUES(4, 'Ventas', 'ingreso de ventas', '', 1,  now(), 1);
INSERT INTO cocoa.concepto (id, codigo, descripcion, observacion, usuario, fregistro, compania)
VALUES(5, 'Compras', 'egreso por compras', '', 1,  now(), 1);
INSERT INTO cocoa.concepto (id, codigo, descripcion, observacion, usuario, fregistro, compania)
VALUES(6, 'Arriendo', 'Pago mensual de arriendo', '', 1,  now(), 1);