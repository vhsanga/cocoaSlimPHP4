<?php


function OpenCon()
{
	$dbhost = "127.0.0.1";
	$dbuser = "root";
	$dbpass = "123456";
	$db = "cocoa";
	$conn = new mysqli($dbhost, $dbuser, $dbpass,$db) or die("Connect failed: %s\n". $conn -> error);
	if ($conn->connect_error) {
	    die("Connection failed: " . $conn->connect_error);
	}

	return $conn;
}


/*
function OpenCon()
{
	$dbhost = "127.0.0.1";
	$dbuser = "nodoclic_root";
	$dbpass = "@UxQksypRtU;";
	$db = "nodoclic_camaras";
	$conn = new mysqli($dbhost, $dbuser, $dbpass,$db) or die("Connect failed: %s\n". $conn -> error);
	if ($conn->connect_error) {
	    die("Connection failed: " . $conn->connect_error);
	}

	return $conn;
}*/



function CloseCon($conn)
{
	$conn -> close();
}
