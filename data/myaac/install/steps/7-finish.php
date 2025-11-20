<?php
defined('MYAAC') or die('Direct access not allowed!');

ini_set('max_execution_time', 300);
if(isset($config['installed']) && $config['installed'] && !isset($_SESSION['saved'])) {
	warning($locale['already_installed']);
}
else {
	require SYSTEM . 'init.php';
	if(!$error) {
		if(USE_ACCOUNT_NAME)
			$account = isset($_SESSION['var_account']) ? $_SESSION['var_account'] : null;
		else
			$account_id = isset($_SESSION['var_account_id']) ? $_SESSION['var_account_id'] : null;

		$password = $_SESSION['var_password'];

		$config_salt_enabled = $db->hasColumn('accounts', 'salt');
		if($config_salt_enabled)
		{
			$salt = generateRandomString(10, false, true, true);
			$password = $salt . $password;
		}

		$account_db = new OTS_Account();
		if(isset($account))
			$account_db->find($account);
		else
			$account_db->load($account_id);

		$player_name = $_SESSION['var_player_name'];
		$player_db = new OTS_Player();
		$player_db->find($player_name);

		if(!$player_db->isLoaded())
		{
			$player = new OTS_Player();
			$player->setName($player_name);

			$player_used = &$player;
		}
		else {
			$player_used = &$player_db;
		}

		$groups = new OTS_Groups_List();
		$player_used->setGroupId($groups->getHighestId());

		$email = $_SESSION['var_email'];
		if($account_db->isLoaded()) {
			$account_db->setPassword(encrypt($password));
			$account_db->setEMail($email);
			$account_db->save();

			$account_used = &$account_db;
		}
		else {
			$new_account = new OTS_Account();
			if(USE_ACCOUNT_NAME) {
				$new_account->create($account);
			}
			else {
				$new_account->create(null, $account_id);
			}

			$new_account->setPassword(encrypt($password));
			$new_account->setEMail($email);

			$new_account->save();

			$new_account->setCustomField('created', time());
			$new_account->logAction('Account created.');

			$account_used = &$new_account;
		}

		if($config_salt_enabled)
			$account_used->setCustomField('salt', $salt);

		$account_used->setCustomField('web_flags', FLAG_ADMIN + FLAG_SUPER_ADMIN);
		$account_used->setCustomField('country', 'us');
		if($db->hasColumn('accounts', 'group_id'))
			$account_used->setCustomField('group_id', $groups->getHighestId());
		if($db->hasColumn('accounts', 'type'))
			$account_used->setCustomField('type', 5);

		if(!$player_db->isLoaded())
			$player->setAccountId($account_used->getId());
		else
			$player_db->setAccountId($account_used->getId());

		success($locale['step_database_created_account']);

		setSession('account', $account_used->getId());
		setSession('password', encrypt($password));
		setSession('remember_me', true);

		if($player_db->isLoaded()) {
			$player_db->save();
		}
		else {
			$player->save();
		}

		$player_id = 0;
		$query = $db->query("SELECT `id` FROM `players` WHERE `name` = " . $db->quote($player_name) . ";");
		if($query->rowCount() == 1) {
			$query = $query->fetch();
			$player_id = $query['id'];
		}

		$query = $db->query("SELECT `id` FROM `" . TABLE_PREFIX ."news` WHERE `title` LIKE 'Hello!';");
		if($query->rowCount() == 0) {
			if(query("INSERT INTO `" . TABLE_PREFIX ."news` (`id`, `type`, `date`, `category`, `title`, `body`, `player_id`, `comments`, `hidden`) VALUES (NULL, '1', UNIX_TIMESTAMP(), '2', 'Hello!', 'MyAAC is just READY to use!', " . $player_id . ", 'https://github.com/opentibiabr/myaac', '0');
	INSERT INTO `myaac_news` (`id`, `type`, `date`, `category`, `title`, `body`, `player_id`, `comments`, `hidden`) VALUES (NULL, '2', UNIX_TIMESTAMP(), '4', 'Hello tickets!', 'https://github.com/opentibiabr/myaac', " . $player_id . ", '', '0');")) {
				success($locale['step_database_created_news']);
			}
		}

		$twig->display('install.installer.html.twig', array(
			'url' => 'tools/7-finish.php',
			'message' => $locale['importing_spinner']
		));

		if(!isset($_SESSION['installed'])) {
			$_SESSION['installed'] = true;
		}

		foreach($_SESSION as $key => $value) {
			if(strpos($key, 'var_') !== false)
				unset($_SESSION[$key]);
		}
		unset($_SESSION['saved']);
		if(file_exists(CACHE . 'install.txt')) {
			unlink(CACHE . 'install.txt');
		}
	}
}
