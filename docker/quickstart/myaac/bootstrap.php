<?php

declare(strict_types=1);

function env_value(string $name, string $default = ''): string
{
	$value = getenv($name);
	return $value === false || $value === '' ? $default : $value;
}

function wait_for_database(): PDO
{
	$host = env_value('CANARY_DB_HOST', 'db');
	$port = env_value('CANARY_DB_PORT', '3306');
	$name = env_value('CANARY_DB_NAME', 'canary');
	$user = env_value('CANARY_DB_USER', 'canary');
	$password = env_value('CANARY_DB_PASSWORD', 'canary');
	$dsn = "mysql:host={$host};port={$port};dbname={$name};charset=utf8mb4";

	for ($attempt = 1; $attempt <= 90; ++$attempt) {
		try {
			return new PDO($dsn, $user, $password, [
				PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
				PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
			]);
		} catch (Throwable $error) {
			echo "Waiting for database ({$attempt}/90): {$error->getMessage()}\n";
			sleep(2);
		}
	}

	throw new RuntimeException('Database did not become available.');
}

function table_exists(PDO $pdo, string $table): bool
{
	$statement = $pdo->prepare(
		'SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = ?'
	);
	$statement->execute([$table]);
	return (int)$statement->fetchColumn() > 0;
}

function column_exists(PDO $pdo, string $table, string $column): bool
{
	$statement = $pdo->prepare(
		'SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = ? AND column_name = ?'
	);
	$statement->execute([$table, $column]);
	return (int)$statement->fetchColumn() > 0;
}

function add_column_if_missing(PDO $pdo, string $table, string $column, string $definition): void
{
	if (!table_exists($pdo, $table) || column_exists($pdo, $table, $column)) {
		return;
	}

	$pdo->exec("ALTER TABLE `{$table}` ADD `{$column}` {$definition}");
}

function wait_for_canary_schema(PDO $pdo): void
{
	for ($attempt = 1; $attempt <= 90; ++$attempt) {
		if (table_exists($pdo, 'accounts') && table_exists($pdo, 'players')) {
			return;
		}

		echo "Waiting for Canary schema ({$attempt}/90)\n";
		sleep(2);
	}

	throw new RuntimeException('Canary schema was not created before MyAAC setup.');
}

function execute_sql_script(PDO $pdo, string $sql): void
{
	$statement = '';
	$quote = null;
	$escaped = false;
	$lineComment = false;
	$blockComment = false;
	$length = strlen($sql);

	for ($index = 0; $index < $length; ++$index) {
		$char = $sql[$index];
		$next = $index + 1 < $length ? $sql[$index + 1] : '';

		if ($lineComment) {
			if ($char === "\n") {
				$lineComment = false;
			}
			continue;
		}

		if ($blockComment) {
			if ($char === '*' && $next === '/') {
				$blockComment = false;
				++$index;
			}
			continue;
		}

		if ($quote !== null) {
			$statement .= $char;
			if ($escaped) {
				$escaped = false;
			} elseif ($char === '\\') {
				$escaped = true;
			} elseif ($char === $quote) {
				$quote = null;
			}
			continue;
		}

		if ($char === '-' && $next === '-' && ($index + 2 >= $length || ctype_space($sql[$index + 2]))) {
			$lineComment = true;
			++$index;
			continue;
		}

		if ($char === '#') {
			$lineComment = true;
			continue;
		}

		if ($char === '/' && $next === '*') {
			$blockComment = true;
			++$index;
			continue;
		}

		if ($char === "'" || $char === '"' || $char === '`') {
			$quote = $char;
			$statement .= $char;
			continue;
		}

		if ($char === ';') {
			$trimmed = trim($statement);
			if ($trimmed !== '') {
				$pdo->exec($trimmed);
			}
			$statement = '';
			continue;
		}

		$statement .= $char;
	}

	$trimmed = trim($statement);
	if ($trimmed !== '') {
		$pdo->exec($trimmed);
	}
}

function write_myaac_config(): void
{
	$serverPath = env_value('MYAAC_SERVER_PATH', '/canary/');
	if (!str_ends_with($serverPath, '/')) {
		$serverPath .= '/';
	}

	$config = [
		'env' => 'prod',
		'server_path' => $serverPath,
		'site_url' => rtrim(env_value('MYAAC_SITE_URL', 'http://localhost:8080'), '/') . '/',
		'database_overwrite' => true,
		'database_type' => 'mysql',
		'database_host' => env_value('CANARY_DB_HOST', 'db'),
		'database_port' => env_value('CANARY_DB_PORT', '3306'),
		'database_user' => env_value('CANARY_DB_USER', 'canary'),
		'database_password' => env_value('CANARY_DB_PASSWORD', 'canary'),
		'database_name' => env_value('CANARY_DB_NAME', 'canary'),
		'database_encryption' => 'sha1',
		'gzip_output' => false,
		'cache_engine' => 'auto',
		'cache_prefix' => 'myaac_docker_',
		'database_auto_migrate' => true,
	];

	$content = "<?php\n";
	$content .= "\$config['installed'] = true;\n";
	foreach ($config as $key => $value) {
		$content .= "\$config['{$key}'] = " . var_export($value, true) . ";\n";
	}

	if (file_put_contents('/var/www/html/config.local.php', $content) === false) {
		throw new RuntimeException('Could not write /var/www/html/config.local.php.');
	}
}

function import_myaac_schema(PDO $pdo): void
{
	if (table_exists($pdo, 'myaac_account_actions')) {
		echo "MyAAC schema already exists.\n";
		return;
	}

	echo "Importing MyAAC schema...\n";
	$schema = file_get_contents('/var/www/html/install/includes/schema.sql');
	if ($schema === false) {
		throw new RuntimeException('Could not read MyAAC schema.sql.');
	}

	execute_sql_script($pdo, $schema);
}

function myaac_database_version(): int
{
	$common = file_get_contents('/var/www/html/common.php');
	if ($common === false || !preg_match('/const\s+DATABASE_VERSION\s*=\s*(\d+);/', $common, $matches)) {
		throw new RuntimeException('Could not detect MyAAC DATABASE_VERSION.');
	}

	return (int)$matches[1];
}

function set_myaac_database_version(PDO $pdo): void
{
	$version = (string)myaac_database_version();
	$statement = $pdo->prepare(
		'INSERT INTO myaac_config (`name`, `value`) VALUES (?, ?) ON DUPLICATE KEY UPDATE `value` = VALUES(`value`)'
	);
	$statement->execute(['database_version', $version]);
}

function myaac_quickstart_installed(PDO $pdo): bool
{
	if (!table_exists($pdo, 'myaac_config')) {
		return false;
	}

	$statement = $pdo->prepare('SELECT `value` FROM myaac_config WHERE `name` = ? LIMIT 1');
	$statement->execute(['docker_quickstart_installed']);
	return $statement->fetchColumn() !== false;
}

function ensure_canary_myaac_columns(PDO $pdo): void
{
	add_column_if_missing($pdo, 'accounts', 'key', "VARCHAR(64) NOT NULL DEFAULT '' AFTER `email`");
	add_column_if_missing($pdo, 'accounts', 'created', "INT(11) NOT NULL DEFAULT 0 AFTER `key`");
	add_column_if_missing($pdo, 'accounts', 'rlname', "VARCHAR(255) NOT NULL DEFAULT '' AFTER `created`");
	add_column_if_missing($pdo, 'accounts', 'location', "VARCHAR(255) NOT NULL DEFAULT '' AFTER `rlname`");
	add_column_if_missing($pdo, 'accounts', 'country', "VARCHAR(3) NOT NULL DEFAULT '' AFTER `location`");
	add_column_if_missing($pdo, 'accounts', 'web_lastlogin', "INT(11) NOT NULL DEFAULT 0 AFTER `country`");
	add_column_if_missing($pdo, 'accounts', 'web_flags', "INT(11) NOT NULL DEFAULT 0 AFTER `web_lastlogin`");
	add_column_if_missing($pdo, 'accounts', 'email_verified', "TINYINT(1) NOT NULL DEFAULT 0 AFTER `web_flags`");
	add_column_if_missing($pdo, 'accounts', 'email_new', "VARCHAR(255) NOT NULL DEFAULT '' AFTER `email_verified`");
	add_column_if_missing($pdo, 'accounts', 'email_new_time', "INT(11) NOT NULL DEFAULT 0 AFTER `email_new`");
	add_column_if_missing($pdo, 'accounts', 'email_code', "VARCHAR(255) NOT NULL DEFAULT '' AFTER `email_new_time`");
	add_column_if_missing($pdo, 'accounts', 'email_next', "INT(11) NOT NULL DEFAULT 0 AFTER `email_code`");
	add_column_if_missing($pdo, 'accounts', 'premium_points', "INT(11) NOT NULL DEFAULT 0 AFTER `email_next`");

	add_column_if_missing($pdo, 'players', 'created', 'INT(11) NOT NULL DEFAULT 0');
	if (!column_exists($pdo, 'players', 'deletion')) {
		add_column_if_missing($pdo, 'players', 'deleted', 'TINYINT(1) NOT NULL DEFAULT 0');
	}
	add_column_if_missing($pdo, 'players', 'hide', 'TINYINT(1) NOT NULL DEFAULT 0');
	add_column_if_missing($pdo, 'players', 'comment', "VARCHAR(5000) NOT NULL DEFAULT ''");

	if (table_exists($pdo, 'guilds')) {
		add_column_if_missing($pdo, 'guilds', 'motd', "VARCHAR(255) NOT NULL DEFAULT ''");
		add_column_if_missing($pdo, 'guilds', 'description', "VARCHAR(5000) NOT NULL DEFAULT ''");
		add_column_if_missing($pdo, 'guilds', 'logo_name', "VARCHAR(255) NOT NULL DEFAULT 'default.gif'");
	}
}

function finish_myaac_install(PDO $pdo): void
{
	global $cache, $config, $db, $eloquentConnection, $hooks, $locale, $ots, $twig;

	if (myaac_quickstart_installed($pdo)) {
		echo "MyAAC quickstart already installed.\n";
		return;
	}

	require_once '/var/www/html/common.php';
	require_once SYSTEM . 'functions.php';
	require_once BASE . 'install/includes/locale.php';
	require_once SYSTEM . 'init.php';

	$adminAccount = env_value('MYAAC_ADMIN_ACCOUNT', 'myaacadmin');
	$adminEmail = env_value('MYAAC_ADMIN_EMAIL', 'admin@localhost.local');
	$adminPassword = env_value('MYAAC_ADMIN_PASSWORD', 'admin123');
	$adminPlayer = env_value('MYAAC_ADMIN_PLAYER', 'MyAAC Admin');

	$groups = new OTS_Groups_List();
	$highestGroupId = max(1, (int)$groups->getHighestId());
	$account = new OTS_Account();
	$account->find($adminAccount);

	if (!$account->isLoaded()) {
		$account->create($adminAccount);
	}

	$account->setPassword(encrypt($adminPassword));
	$account->setEMail($adminEmail);
	$account->save();
	$account->setCustomField('created', time());
	$account->setCustomField('web_flags', FLAG_ADMIN + FLAG_SUPER_ADMIN);
	$account->setCustomField('country', 'br');
	$account->setCustomField('email_verified', 1);

	if ($GLOBALS['db']->hasColumn('accounts', 'group_id')) {
		$account->setCustomField('group_id', $highestGroupId);
	}

	if ($GLOBALS['db']->hasColumn('accounts', 'type')) {
		$account->setCustomField('type', 6);
	}

	if ($GLOBALS['db']->hasTable('players')) {
		$player = new OTS_Player();
		$player->find($adminPlayer);

		if (!$player->isLoaded()) {
			$player->setName($adminPlayer);
			$player->setAccountId($account->getId());
			$player->setGroupId($highestGroupId);
			$player->save();
		} else {
			$player->setAccountId($account->getId());
			$player->save();
		}
	}

	require BASE . 'install/includes/import_base_data.php';

	if (function_exists('clearCache')) {
		clearCache();
	}

	foreach ([17, 20, 22, 27, 30, 31, 45] as $migration) {
		$path = SYSTEM . "migrations/{$migration}.php";
		if (is_file($path)) {
			require $path;
			if (isset($up) && is_callable($up)) {
				$up();
			}
			unset($up);
		}
	}

	if (class_exists(\MyAAC\Models\FAQ::class) && \MyAAC\Models\FAQ::count() === 0) {
		\MyAAC\Models\FAQ::create([
			'question' => 'What is this?',
			'answer' => 'This is a Canary quickstart website powered by MyAAC.',
		]);
	}

	if (class_exists(\MyAAC\Models\News::class) && \MyAAC\Models\News::count() === 0) {
		\MyAAC\Models\News::create([
			'type' => 1,
			'date' => time(),
			'category' => 2,
			'title' => 'Canary Docker quickstart',
			'body' => 'Your local Canary server is ready to use.',
			'player_id' => 0,
			'comments' => 'https://docs.opentibiabr.com/',
			'hide' => 0,
		]);
	}

	$settings = \MyAAC\Settings::getInstance();
	$settings->updateInDatabase('core', 'anonymous_usage_statistics', 'false');
	$settings->updateInDatabase('core', 'date_timezone', env_value('MYAAC_TIMEZONE', 'America/Fortaleza'));
	$settings->updateInDatabase('core', 'client', env_value('MYAAC_CLIENT_VERSION', '1513'));

	$statement = $pdo->prepare(
		'INSERT INTO myaac_config (`name`, `value`) VALUES (?, ?) ON DUPLICATE KEY UPDATE `value` = VALUES(`value`)'
	);
	$statement->execute(['docker_quickstart_installed', date(DATE_ATOM)]);
}

chdir('/var/www/html');
write_myaac_config();

$pdo = wait_for_database();
wait_for_canary_schema($pdo);
import_myaac_schema($pdo);
ensure_canary_myaac_columns($pdo);
set_myaac_database_version($pdo);
finish_myaac_install($pdo);
echo "MyAAC quickstart is ready.\n";
