<?php
header('Content-Type: application/json');
echo json_encode([
    "message" => "Hello from AzureTech ! Mon nom est " . gethostname(),
    "service" => "Azure App Service (PaaS)",
    "runtime" => "PHP 8.2",
    "host"    => gethostname()
]);