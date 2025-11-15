<?php
header("Content-Type: application/json");
$db = new SQLite3('/home/${EC2_USER}/canary/data/otservbr.db');
$input = json_decode(file_get_contents("php://input"), true);
$acc = $input["account"] ?? "";
$pass = $input["password"] ?? "";

$stmt = $db->prepare("SELECT id, password FROM accounts WHERE name = :acc LIMIT 1");
$stmt->bindValue(":acc", $acc);
$res = $stmt->execute()->fetchArray(SQLITE3_ASSOC);

if (!$res || $res["password"] != $pass) {
    echo json_encode(["errorCode" => 3, "errorMessage" => "Invalid credentials"]);
    exit;
}

echo json_encode([
    "session" => [
        "sessionkey" => $acc . "\n" . $pass,
        "lastlogintime" => 0,
        "ispremium" => true,
        "premiumuntil" => 9999999999
    ],
    "playdata" => [
        "worlds" => [[
            "id" => 0,
            "name" => "Vayra",
            "externaladdress" => "${{ secrets.EC2_HOST }}",
            "externalport" => 7172,
            "previewstate" => 0,
            "location" => "BRA",
            "pvptype" => "pvp"
        ]],
        "characters" => []
    ]
]);
?>
