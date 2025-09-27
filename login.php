<?php
header('Content-Type: application/json');
if (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') {
    header('Strict-Transport-Security: max-age=31536000; includeSubDomains');
}

// Mysql
// Server_Name => From Config.lua!
$config = [
    'db_host' => '127.0.0.1',
    'db_user' => 'root',
    'db_pass' => 'root',
    'db_name' => 'otservbr-global',
    'server_ip' => '127.0.0.1',
    'server_port' => 7172,
    'server_name' => 'otservbr-global'
];

// Check Config.lua
const ARGON2_MEMORY_COST = 1 << 16;
const ARGON2_TIME_COST = 2;
const ARGON2_PARALLELISM = 2;

// Http Secure
if (php_sapi_name() !== 'cli' && ($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST') {
    http_response_code(405);
    echo json_encode(['errorCode' => 3, 'errorMessage' => 'Method not allowed.']);
    exit;
}

function verifyPassword(string $password, string $stored): bool {
    if (strpos($stored, '$argon2') === 0) {
        if (function_exists('password_verify')) {
            return password_verify($password, $stored);
        }
        if (function_exists('sodium_crypto_pwhash_str_verify')) {
            return sodium_crypto_pwhash_str_verify($stored, $password);
        }
        return false;
    }

    if (preg_match('/^([A-Za-z0-9]+)\\$([A-Za-z0-9+/]+)\\$([A-Za-z0-9+/]+)$/', $stored, $matches)) {
        if (!function_exists('sodium_crypto_pwhash')) {
            return false;
        }
        $algo = strtolower($matches[1]);
        $salt = base64_decode($matches[2], true);
        $hash = base64_decode($matches[3], true);
        if ($salt === false || $hash === false) {
            return false;
        }
        switch ($algo) {
            case 'argon2':
            case 'argon2i':
                $algoConst = SODIUM_CRYPTO_PWHASH_ALG_ARGON2I13;
                break;
            case 'argon2id':
                $algoConst = SODIUM_CRYPTO_PWHASH_ALG_ARGON2ID13;
                break;
            default:
                return false;
        }
        $memlimit = ARGON2_MEMORY_COST * 1024; // libsodium usa bytes
        try {
            $calc = sodium_crypto_pwhash(
                strlen($hash),
                $password,
                $salt,
                ARGON2_TIME_COST,
                $memlimit,
                $algoConst
            );
        } catch (SodiumException $e) {
            return false;
        }
        return hash_equals($hash, $calc);
    }

    // Sha1 Legacy
    return hash_equals(strtolower($stored), sha1($password));
}

// Client JSON
$rawInput = file_get_contents('php://input');
if ($rawInput === '' || $rawInput === false) {
    $rawInput = stream_get_contents(STDIN);
}
$request = json_decode($rawInput);
if (!isset($request->type) || $request->type !== 'login') {
    echo json_encode(['errorCode' => 3, 'errorMessage' => 'Invalid request type.']);
    exit;
}

$email = $request->email ?? '';
$password = $request->password ?? '';

if (!$email || !$password) {
    echo json_encode(['errorCode' => 3, 'errorMessage' => 'Email and password required.']);
    exit;
}

// Database
try {
    $pdo = new PDO(
        "mysql:host={$config['db_host']};dbname={$config['db_name']}",
        $config['db_user'],
        $config['db_pass'],
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_EMULATE_PREPARES => false
        ]
    );
} catch (PDOException $e) {
    echo json_encode(['errorCode' => 3, 'errorMessage' => 'Database connection failed.']);
    exit;
}

// Email Check:
$stmt = $pdo->prepare("SELECT * FROM accounts WHERE email = :email LIMIT 1");
$stmt->execute([':email' => $email]);
$account = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$account || !verifyPassword($password, $account['password'])) {
	usleep(500000); // Prevent bruteforce
    echo json_encode(['errorCode' => 3, 'errorMessage' => 'Invalid email or password.']);
    exit;
}

$stmt = $pdo->prepare("SELECT * FROM players WHERE account_id = :account_id AND deletion = 0");
$stmt->execute([':account_id' => $account['id']]);
$players = $stmt->fetchAll(PDO::FETCH_ASSOC);

$mainCharacter = '';
$highestLevel = 0;
foreach ($players as $p) {
    if ($p['level'] > $highestLevel) {
        $mainCharacter = $p['name'];
        $highestLevel = $p['level'];
    }
}

$characters = [];
foreach ($players as $player) {
    $characters[] = [
        'worldid' => 0,
        'name' => $player['name'],
        'ismale' => intval($player['sex']) === 1,
        'tutorial' => !empty($player['istutorial']),
        'level' => intval($player['level']),
        'vocation' => getVocationName($player['vocation']),
        'outfitid' => intval($player['looktype']),
        'headcolor' => intval($player['lookhead']),
        'torsocolor' => intval($player['lookbody']),
        'legscolor' => intval($player['looklegs']),
        'detailcolor' => intval($player['lookfeet']),
        'addonsflags' => intval($player['lookaddons']),
        'ishidden' => 0,
        'istournamentparticipant' => false,
        'ismaincharacter' => $player['name'] === $mainCharacter,
        'dailyrewardstate' => intval($player['isreward'] ?? 0),
        'remainingdailytournamentplaytime' => 0
    ];
}

$worlds = [[
    'id' => 0,
    'name' => $config['server_name'],
    'externaladdress' => $config['server_ip'],
    'externalport' => $config['server_port'],
    'externaladdressprotected' => $config['server_ip'],
    'externalportprotected' => $config['server_port'],
    'externaladdressunprotected' => $config['server_ip'],
    'externalportunprotected' => $config['server_port'],
    'previewstate' => 0,
    'location' => 'BRA',
    'anticheatprotection' => false,
    'pvptype' => 0,
    'istournamentworld' => false,
    'restrictedstore' => false,
    'currenttournamentphase' => 2
]];

$session = [
    'sessionkey' => "$email\n$password",
    'lastlogintime' => (int)$account['lastday'],
    'ispremium' => true,
    'premiumuntil' => $account['premdays'] > 0 ? time() + ($account['premdays'] * 86400) : 0,
    'status' => 'active',
    'returnernotification' => false,
    'showrewardnews' => true,
    'isreturner' => false,
    'fpstracking' => false,
    'optiontracking' => false,
    'tournamentticketpurchasestate' => 0,
    'emailcoderequest' => false
];

echo json_encode([
    'session' => $session,
    'playdata' => [
        'worlds' => $worlds,
        'characters' => $characters
    ]
]);

function getVocationName($id) {
    $vocations = [
        0 => 'No Vocation',
        1 => 'Sorcerer',
        2 => 'Druid',
        3 => 'Paladin',
        4 => 'Knight',
        5 => 'Master Sorcerer',
        6 => 'Elder Druid',
        7 => 'Royal Paladin',
        8 => 'Elite Knight'
    ];
    return $vocations[$id] ?? 'Unknown';
}
