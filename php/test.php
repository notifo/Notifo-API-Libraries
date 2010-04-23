<?php

include("Notifo_API.php");

$notifo = new Notifo_API("username", "apisecret");

$params = array("to"=>"username",
		"label"=>"Dictionary",
		"title"=>"Word of the Day",
		"msg"=>"chuffed: delighted; pleased; satisfied.",
		"uri"=>"http://dictionary.com");

$notifo->send_notification($params);

?>