<?php
/*
 ************************************************************************
 PagSeguro Config File
 ************************************************************************
 */

global $config;
$PagSeguroConfig = array();

$PagSeguroConfig['environment'] = $config['pagSeguro']['environment']; // production, sandbox

$PagSeguroConfig['credentials'] = array();
$PagSeguroConfig['credentials']['email'] = $config['pagSeguro']['email'];
$PagSeguroConfig['credentials']['token']['production'] = $config['pagSeguro']['token']['production'];
$PagSeguroConfig['credentials']['token']['sandbox'] = $config['pagSeguro']['token']['sandbox'];

$PagSeguroConfig['application'] = array();
$PagSeguroConfig['application']['charset'] = "UTF-8"; // UTF-8, ISO-8859-1

$PagSeguroConfig['log'] = array();
$PagSeguroConfig['log']['active'] = false;
$PagSeguroConfig['log']['fileLocation'] = "";
