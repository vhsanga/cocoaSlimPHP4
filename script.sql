DROP TABLE cocoa.usuariopersona;
DROP TABLE cocoa.persona;
DROP TABLE cocoa.movimiento;
DROP TABLE cocoa.asientocontable ;
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
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;



CREATE TABLE `cuenta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `codigo` varchar(10) DEFAULT NULL,
  `saldo` decimal(15,2) NOT NULL,
  `observacion` varchar(100) DEFAULT NULL,
  `estadocuenta` varchar(9) DEFAULT NULL,
  `grupocontable` varchar(9) NOT NULL,
  `fregistro` date DEFAULT NULL,
  `compania` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cuenta_codigo_idx` (`codigo`,`compania`) USING BTREE,
  KEY `cuenta_detallecatalogo_fk` (`estadocuenta`),
  KEY `cuenta_compania_fk` (`compania`),
  KEY `cuenta_FK` (`grupocontable`),
  CONSTRAINT `cuenta_FK` FOREIGN KEY (`grupocontable`) REFERENCES `detallecatalogo` (`codigo`),
  CONSTRAINT `cuenta_compania_fk` FOREIGN KEY (`compania`) REFERENCES `compania` (`id`),
  CONSTRAINT `cuenta_detallecatalogo_fk` FOREIGN KEY (`estadocuenta`) REFERENCES `detallecatalogo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;


CREATE TABLE `usuario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(16) NOT NULL,
  `contrasenia` varchar(128) NOT NULL,
  `estadousuario` varchar(9) NOT NULL,
  `fregistro` datetime NOT NULL,
  `compania` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `usuario_detallecatalogo_fk` (`estadousuario`),
  KEY `usuario_compania_fk` (`compania`),
  UNIQUE KEY `usuario_usuario_IDX` (`usuario`) USING BTREE,
  CONSTRAINT `usuario_compania_fk` FOREIGN KEY (`compania`) REFERENCES `compania` (`id`),
  CONSTRAINT `usuario_detallecatalogo_fk` FOREIGN KEY (`estadousuario`) REFERENCES `detallecatalogo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;



CREATE TABLE `concepto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(16) NOT NULL,
  `descripcion` varchar(64) NOT NULL,
  `observacion` varchar(128) DEFAULT NULL,
  `saldo` decimal(15,2) DEFAULT NULL,
  `esingreso` tinyint(1) DEFAULT NULL,
  `fregistro` datetime NOT NULL,
  `cuenta` int(11) DEFAULT NULL,
  `usuario` int(11) NOT NULL,
  `compania` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `concepto_codigo_idx` (`codigo`,`compania`) USING BTREE,
  KEY `concepto_usuario_fk` (`usuario`),
  KEY `concepto_cuenta_fk` (`cuenta`),
  KEY `concepto_compania_fk` (`compania`),
  CONSTRAINT `concepto_compania_fk` FOREIGN KEY (`compania`) REFERENCES `compania` (`id`),
  CONSTRAINT `concepto_cuenta_fk` FOREIGN KEY (`cuenta`) REFERENCES `cuenta` (`id`),
  CONSTRAINT `concepto_usuario_fk` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;


CREATE TABLE `asientocontable` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `movimiento` int(11) NOT NULL,
  `concepto` int(11) NOT NULL,
  `debe` decimal(15,2) DEFAULT NULL,
  `haber` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `asientocontable_FK` (`concepto`),
  CONSTRAINT `asientocontable_FK` FOREIGN KEY (`concepto`) REFERENCES `concepto` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;


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
  UNIQUE KEY `persona_identificacion_idx` (`identificacion`,`compania`) USING BTREE,
  KEY `persona_detallecatalogo_fk` (`tipoidentificacion`),
  KEY `persona_compania_fk` (`compania`),
  CONSTRAINT `persona_compania_fk` FOREIGN KEY (`compania`) REFERENCES `compania` (`id`),
  CONSTRAINT `persona_detallecatalogo_fk` FOREIGN KEY (`tipoidentificacion`) REFERENCES `detallecatalogo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;


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


INSERT INTO `compania` VALUES 
(1,'Familiar','AV UnidadNacional y Chimborazo','0603765058','0979636583','clienteperosnal@gmail.com',NULL,'2020-12-08'),
(2,'Familiar 2 ','AV UnidadNacional y Chimborazo','0603765058','0979636583','clienteperosnal@gmail.com',NULL,'2020-12-08');


INSERT INTO `catalogo` VALUES 
('EST_CIA','Estado de Compania'),
('EST_CTA','Estado de Cuenta'),
('EST_USU','Estado de Usuario'),
('GRP_CTA','Grupo Contable'),
('TIP_ID','Tipo Identificación'),
('TIP_OPE','Tipo de Operación');


INSERT INTO `detallecatalogo` VALUES 
('ACT','EST_USU','Usuario Activo'),
('ACTIVO','GRP_CTA','Activo'),
('BLOQ','EST_USU','Usuario Bloqueado'),
('CED','TIP_ID','Cédula'),
('CIA_ACT','EST_CIA','Compania Activa'),
('CIA_INACT','EST_CIA','Compania Inactica'),
('CTA_ACT','EST_CTA','Cuenta Activa'),
('CTA_BLOQ','EST_CTA','Cuenta Bloqueada'),
('CTA_CERR','EST_CTA','Cuenta Cerrada'),
('CTA_INACT','EST_CTA','Cuenta Inactica'),
('DESACT','EST_USU','Usuario Desactivado'),
('EGR','TIP_OPE','Egreso'),
('INACT','EST_USU','Usuario Inactivo'),
('ING','TIP_OPE','Ingreso'),
('PASIVO','GRP_CTA','Pasivo'),
('RUC','TIP_ID','Ruc'),
('TEMP','EST_USU','Con clave Temporal');



INSERT INTO `usuario` VALUES 
(1,'user','123','ACT','2020-12-24 11:06:31',1),
(2,'001','123','ACT','2020-12-24 11:06:58',1),
(3,'1','123','ACT','2020-12-24 12:36:25',2);


INSERT INTO `persona` VALUES 
(1,'0603765059','Jose',' de la cuadra','1991-12-06','Av de la prtensa','032646154','jose@gmail.com','CED','2020-12-24 11:07:36',1),
(2,'1715452541','Miguel ','rosales','1991-12-06','Av los shirys','0976565412','miguelito@gmail.co','CED','2020-12-24 11:07:40',1),
(3,'1715452541','MAria ','mendoza','1991-12-06','Av los shirys','0976565412','miguelito@gmail.co','CED','2020-12-24 12:42:28',2);


INSERT INTO `usuariopersona` VALUES 
(1,1),
(2,2),
(3,3);

-----------------------------------------------------------------------------

INSERT INTO `cuenta` VALUES 
(2,'Ofrendas','Ofrenda',148.85,'Cuenta para el registro de ofrendas','CTA_ACT','ACTIVO','2020-12-24',1),
(3,'Diezmos','Diezmos',345.00,'Cuenta para el registro de diezmos','CTA_ACT','ACTIVO','2020-12-24',1),
(4,'Cuentas por Pagas','C x P',36.55,'Cuentas que se deben pagar para egresos','CTA_ACT','PASIVO','2020-12-24',1),
(5,'Ventas','Ventas',0.00,'Ventas ocacionales','CTA_ACT','ACTIVO','2020-12-24',1),
(6,'Sueldos','Sueldos',605.00,'','CTA_ACT','ACTIVO','2020-12-24',2),
(8,'Ventas','Ventas',604.70,'','CTA_ACT','ACTIVO','2020-12-24',2),
(9,'Proveedores','Proveedore',0.00,'','CTA_ACT','PASIVO','2020-12-24',2),
(10,'Cuentas por Pagar','C x P',180.00,'','CTA_ACT','PASIVO','2020-12-24',2),
(11,'Caja','Caja',0.00,'','CTA_ACT','ACTIVO','2020-12-24',2),
(12,'Bancos','Bancos',0.00,'','CTA_ACT','ACTIVO','2020-12-24',2),
(13,'Construccion de Techo','TECHO',2050.00,'Cuenta creada para arreglos del techo de la iglesia','CTA_ACT','ACTIVO','2020-12-24',1);




INSERT INTO `concepto` VALUES 
(27,'Ingreso Ofrenda','Ingresa efectivo','',0.00,1,'2020-12-24 11:24:22',NULL,1,1),
(28,'Ingreso Diezmo','Ingresa efectivo','',0.00,1,'2020-12-24 11:25:15',NULL,1,1),
(29,'Luz electrica','Pago de luz electrica','',36.55,0,'2020-12-24 11:25:48',4,1,1),
(30,'Agua','Pago de Agua','',0.00,0,'2020-12-24 11:26:05',4,1,1),
(31,'Internet','Pago de internet CNT','Mensual',0.00,0,'2020-12-24 11:27:22',4,1,1),
(32,'Venta maiz','Venta maiz','',0.00,0,'2020-12-24 11:28:08',5,1,1),
(33,'OFRENDAS','','',148.85,0,'2020-12-24 11:55:57',2,1,1),
(34,'DIEZMOS','','',345.00,0,'2020-12-24 11:56:39',3,1,1),
(35,'Ingreso Sueldo','Ingreso directo de sueldos','',0.00,1,'2020-12-24 12:54:11',NULL,3,2),
(36,'Ingreso Ventas','Ingreso por ventas','',0.00,1,'2020-12-24 12:54:45',NULL,3,2),
(37,'Sueldos','','',605.00,0,'2020-12-24 12:55:58',6,3,2),
(38,'Ventas','','',604.70,0,'2020-12-24 12:56:58',8,3,2),
(39,'Arriendo','Pago mensual de arriendo','',180.00,0,'2020-12-24 12:57:54',10,3,2),
(40,'Luz','Servicio Basico Luz','',0.00,0,'2020-12-24 12:58:14',10,3,2),
(41,'Internet','Pago mensual Internet','',0.00,0,'2020-12-24 12:58:36',10,3,2),
(42,'Caja','Caja','',0.00,0,'2020-12-24 12:59:24',11,3,2),
(44,'Ing Venta Maiz','Ingresa efectivo','',0.00,1,'2020-12-24 15:54:08',NULL,1,1),
(45,'Ingreso Techo','Ingreso Efectivo','',0.00,1,'2020-12-24 16:09:19',NULL,1,1),
(46,'Techo','Colaboracion para techo','',2050.00,0,'2020-12-24 16:15:33',13,1,1);


INSERT INTO `movimiento` VALUES 
(15,1,'ING',185.40,'Ofrenda domingo 15 Julio',33,'2020-12-24 11:58:22',1),
(16,1,'ING',345.00,'Diezmos Familia Sanga',34,'2020-12-24 12:00:52',1),
(17,1,'EGR',-18.55,'Pago de luz de Julio',33,'2020-12-24 12:05:24',1),
(18,3,'ING',785.00,'Sueldo de julio',37,'2020-12-24 13:01:01',2),
(19,3,'ING',354.20,'Ventas de lunes ',38,'2020-12-24 13:01:38',2),
(20,1,'EGR',-18.00,'PAgo luz de junio',33,'2020-12-24 15:58:48',1),
(21,1,'ING',250.00,'Colabroacion familia Roldan',46,'2020-12-24 16:17:13',1),
(22,1,'ING',1800.00,'Colaboracion de santo domingo',46,'2020-12-24 16:18:29',1),
(23,3,'ING',250.50,'Ventas de martes',38,'2020-12-24 16:26:00',2),
(24,3,'EGR',-180.00,'Pago de arriendo de julio',37,'2020-12-24 16:27:21',2);


INSERT INTO `asientocontable` VALUES 
(1,15,33,185.40,NULL),
(2,15,27,NULL,185.40),
(3,16,34,345.00,NULL),
(4,16,28,NULL,345.00),
(5,17,29,18.55,NULL),
(6,17,33,NULL,18.55),
(7,18,37,785.00,NULL),
(8,18,35,NULL,785.00),
(9,19,38,354.20,NULL),
(10,19,36,NULL,354.20),
(11,20,29,18.00,NULL),
(12,20,33,NULL,18.00),
(13,21,46,250.00,NULL),
(14,21,45,NULL,250.00),
(15,22,46,1800.00,NULL),
(16,22,45,NULL,1800.00),
(17,23,38,250.50,NULL),
(18,23,36,NULL,250.50),
(19,24,39,180.00,NULL),
(20,24,37,NULL,180.00);

select ac.id, c.descripcion, ac.debe, ac.haber  from asientocontable ac inner join concepto c on ac.concepto=c.id

