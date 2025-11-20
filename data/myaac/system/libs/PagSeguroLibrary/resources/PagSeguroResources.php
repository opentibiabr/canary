<?php

// Static URLs
$PagSeguroResources['staticUrl'] = array();
$PagSeguroResources['staticUrl']['production'] = "https://stc.pagseguro.uol.com.br";
$PagSeguroResources['staticUrl']['sandbox'] = "https://stc.sandbox.pagseguro.uol.com.br";

// WebService URLs
$PagSeguroResources['webserviceUrl'] = array();
$PagSeguroResources['webserviceUrl']['production'] = "https://ws.pagseguro.uol.com.br";
$PagSeguroResources['webserviceUrl']['sandbox'] = "https://ws.sandbox.pagseguro.uol.com.br";

// Payment service
$PagSeguroResources['paymentService'] = array();
$PagSeguroResources['paymentService']['servicePath'] = "/v2/checkout";
$PagSeguroResources['paymentService']['checkoutUrl'] = "/v2/checkout/payment.html";
$PagSeguroResources['paymentService']['baseUrl']['production'] = "https://pagseguro.uol.com.br";
$PagSeguroResources['paymentService']['baseUrl']['sandbox'] = "https://sandbox.pagseguro.uol.com.br";
$PagSeguroResources['paymentService']['serviceTimeout'] = 20;

// Notification service
$PagSeguroResources['notificationService'] = array();
$PagSeguroResources['notificationService']['servicePath'] = "/v2/transactions/notifications";
$PagSeguroResources['notificationService']['serviceTimeout'] = 20;

// Transaction search service
$PagSeguroResources['transactionSearchService'] = array();
$PagSeguroResources['transactionSearchService']['servicePath'] = "/v2/transactions";
$PagSeguroResources['transactionSearchService']['serviceTimeout'] = 20;