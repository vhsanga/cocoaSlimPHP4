 DROP TABLE cocoa.usuariopersona;
DROP TABLE cocoa.persona;
DROP TABLE cocoa.movimiento;
DROP TABLE cocoa.concepto;
DROP TABLE cocoa.usuario;
DROP TABLE cocoa.cuenta;
DROP TABLE cocoa.compania;
DROP TABLE cocoa.detallecatalogo;
DROP TABLE cocoa.catalogo;


CREATE TABLE `catalogo` (
  `codigo` varchar(9) NOT NULL,
  `descripcion` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `detallecatalogo` (
  `codigo` varchar(9) NOT NULL,
  `catalogo` varchar(9) NOT NULL,
  `descripcion` varchar(64) DEFAULT NULL,  
  PRIMARY KEY (`codigo`),
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
  `estadocuenta` varchar(9) DEFAULT NULL,
  `fregistro` date DEFAULT NULL,
  `compania` int(11) DEFAULT NULL,
  `grupocontable` varchar(9) DEFAULT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cuenta_un` (`codigo`),
  KEY `cuenta_detallecatalogo_fk` (`estadocuenta`),
  KEY `cuenta_compania_fk` (`compania`),
  KEY `cuenta_FK` (`grupocontable`),
  CONSTRAINT `cuenta_FK` FOREIGN KEY (`grupocontable`) REFERENCES `detallecatalogo` (`codigo`),
  CONSTRAINT `cuenta_compania_fk` FOREIGN KEY (`compania`) REFERENCES `compania` (`id`),
  CONSTRAINT `cuenta_detallecatalogo_fk` FOREIGN KEY (`estadocuenta`) REFERENCES `detallecatalogo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8


CREATE TABLE `usuario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(16) NOT NULL,
  `contrasenia` varchar(128) NOT NULL,
  `estadousuario` varchar(9) NOT NULL,
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
  `saldo` decimal(15,2) DEFAULT NULL,
  `esingreso` tinyint(1) DEFAULT NULL,
  `fregistro` datetime NOT NULL,
  `usuario` int(11) NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8


CREATE TABLE `movimiento` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `usuario` int(11) NOT NULL,
  `tipooperacion` varchar(9) NOT NULL,
  `valor` decimal(15,2) NOT NULL DEFAULT '0.00',
  `detalle` varchar(128) DEFAULT NULL, 
  `conceptoprincipal` int(11) NOT NULL,
  `fecha` datetime NOT NULL,
  `compania` int(11) DEFAULT NULL,   
  PRIMARY KEY (`id`),
  KEY `ingresoegreso_detallecatalogo_fk` (`tipooperacion`),
  KEY `ingresoegreso_usuario_fk` (`usuario`),
  KEY `ingresoegreso_compania_fk` (`compania`),
  CONSTRAINT `ingresoegreso_compania_fk` FOREIGN KEY (`compania`) REFERENCES `compania` (`id`),
  CONSTRAINT `ingresoegreso_detallecatalogo_fk` FOREIGN KEY (`tipooperacion`) REFERENCES `detallecatalogo` (`codigo`),
  CONSTRAINT `ingresoegreso_usuario_fk` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8



CREATE TABLE `asientocontable` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `movimiento` int(11) NOT NULL,
  `concepto` int(11) NOT NULL,
  `debe` decimal(15,2) DEFAULT NULL,
  `haber` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `asientocontable_FK` (`concepto`),
  CONSTRAINT `asientocontable_FK` FOREIGN KEY (`concepto`) REFERENCES `concepto` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8


CREATE TABLE `persona` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identificacion` varchar(13) NOT NULL,
  `nombres` varchar(64) NOT NULL,
  `apellidos` varchar(64) DEFAULT NULL,
  `fnacimiento` date DEFAULT NULL,
  `direccion` varchar(128) DEFAULT NULL,
  `telefono` varchar(10) DEFAULT NULL,
  `correo` varchar(64) DEFAULT NULL,
  `tipoidentificacion` varchar(9) DEFAULT NULL,
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


INSERT INTO cocoa.compania (id,nombre, direccion, ruc, telefono, email, representantelegal, fregistro)
VALUES(1,'Familiar', 'AV UnidadNacional y Chimborazo', '0603765058', '0979636583', 'clienteperosnal@gmail.com', NULL, '2020-12-08');



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
INSERT INTO cocoa.catalogo (codigo, descripcion)
VALUES('GRP_CTA', 'Grupo Contable');



INSERT INTO cocoa.detallecatalogo (codigo,descripcion,catalogo)
VALUES ('CIA_ACT','Compania Activa','EST_CIA');
INSERT INTO cocoa.detallecatalogo (codigo,descripcion,catalogo)
VALUES ('CIA_INACT','Compania Inactica','EST_CIA');
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
VALUES ('CTA_ACT','Cuenta Activa','EST_CTA');
INSERT INTO cocoa.detallecatalogo (codigo,descripcion,catalogo)
VALUES ('CTA_INACT','Cuenta Inactica','EST_CTA');
INSERT INTO cocoa.detallecatalogo (codigo,descripcion,catalogo)
VALUES ('CTA_CERR','Cuenta Cerrada','EST_CTA');
INSERT INTO cocoa.detallecatalogo (codigo,descripcion,catalogo)
VALUES ('CTA_BLOQ','Cuenta Bloqueada','EST_CTA');

INSERT INTO cocoa.detallecatalogo (codigo,descripcion,catalogo)
VALUES ('ACTIVO','Activo','GRP_CTA');
INSERT INTO cocoa.detallecatalogo (codigo,descripcion,catalogo)
VALUES ('PASIVO','Pasivo','GRP_CTA');


INSERT INTO cocoa.usuario ( id, usuario, contrasenia, estadousuario, fregistro, compania)
VALUES(1, 'user', '123', 'ACT', now(), 1);
INSERT INTO cocoa.usuario ( usuario, contrasenia, estadousuario, fregistro, compania)
VALUES(2, '001', '123', 'ACT', now(), 1);


INSERT INTO cocoa.persona (id, identificacion, nombres, apellidos, fnacimiento, direccion, telefono, correo, tipoidentificacion, fregistro, compania)
VALUES( 1'0603765059', 'Jose', ' de la cuadra', '1991-12-06', 'Av de la prtensa', '032646154', 'jose@gmail.com', 'CED',  now(), 1);
INSERT INTO cocoa.persona ( identificacion, nombres, apellidos, fnacimiento, direccion, telefono, correo, tipoidentificacion, fregistro, compania)
VALUES( 2 '1715452541', 'Miguel ', 'rosales', '1991-12-06', 'Av los shirys', '0976565412', 'miguelito@gmail.co', 'CED',  now(), 1);


INSERT INTO cocoa.usuariopersona (usuario, persona)
VALUES(1, 1);
INSERT INTO cocoa.usuariopersona (usuario, persona)
VALUES(2, 2);

INSERT INTO cocoa.cuenta (id, nombre, codigo, saldo, observacion, estadocuenta, fregistro, compania, grupocontable)
VALUES(1, 'Caja', 'Caja', 0.00, 'Movimiento de efectivo', 'CTA_ACT', '2020-12-09', 1, 'ACTIVO');
INSERT INTO cocoa.cuenta (id, nombre, codigo, saldo, observacion, estadocuenta, fregistro, compania, grupocontable)
VALUES(2, 'Cuentas por Cobrar', 'C x Cobrar', 0.00, 'Cobros de prestamos', 'CTA_ACT', '2020-12-09', 1, 'ACTIVO');
INSERT INTO cocoa.cuenta (id, nombre, codigo, saldo, observacion, estadocuenta, fregistro, compania, grupocontable)
VALUES(3, 'Cuentas por Pagar', 'C x Pagar', 0.00, 'Deudas  por pagar', 'CTA_ACT', '2020-12-09', 1, 'PASIVO');
INSERT INTO cocoa.cuenta (id, nombre, codigo, saldo, observacion, estadocuenta, fregistro, compania, grupocontable)
VALUES(4, 'Bancos', 'Bancos', 0.00, 'Efectivo en Bancos', 'CTA_ACT', '2020-12-09', 1, 'ACTIVO');

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------********************************************************-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
INSERT INTO cocoa.concepto(id, codigo, descripcion, observacion, usuario, fregistro, cuenta, compania, saldo, esingreso)
VALUES(1, 'Sueldo', 'Sueldo mensual', 'mensual', 1, '2020-12-10 00:05:30.0', 4, 1, 0.00, 0);
INSERT INTO cocoa.concepto(id, codigo, descripcion, observacion, usuario, fregistro, cuenta, compania, saldo, esingreso)
VALUES(2, 'Caja', 'ingreso de efectivo por ventas', 'Registro diario', 1, '2020-12-10 00:06:07.0', 1, 1, 0.00, 0);
INSERT INTO cocoa.concepto(id, codigo, descripcion, observacion, usuario, fregistro, cuenta, compania, saldo, esingreso)
VALUES(3, 'Compras', 'egreso por compras', 'Registro diario', 1, '2020-12-10 00:06:10.0', 1, 1, 0.00, 0);
INSERT INTO cocoa.concepto(id, codigo, descripcion, observacion, usuario, fregistro, cuenta, compania, saldo, esingreso)
VALUES(4, 'Arriendo', 'Pago mensual de arriendo', 'Pago mensual', 1, '2020-12-10 00:06:12.0', 3, 1, 0.00, 0);
INSERT INTO cocoa.concepto(id, codigo, descripcion, observacion, usuario, fregistro, cuenta, compania, saldo, esingreso)
VALUES(5, 'Contrato laboral', 'Contrato laboral ', 'Pago mensual', 1, '2020-12-10 00:06:12.0', NULL, 1, 0.00, 1);
INSERT INTO cocoa.concepto(id, codigo, descripcion, observacion, usuario, fregistro, cuenta, compania, saldo, esingreso)
VALUES(6, 'Tienda', 'Ventas de productos abarrotes', 'registro diario', 1, '2020-12-10 00:06:12.0', NULL, 1, 0.00, 1);


select ac.id, c.descripcion, ac.debe, ac.haber  from asientocontable ac inner join concepto c on ac.concepto=c.id