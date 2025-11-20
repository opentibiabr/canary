<?php
define('MYAAC_INSTALL', true);

require_once '../../common.php';

require SYSTEM . 'functions.php';
require BASE . 'install/includes/functions.php';
require BASE . 'install/includes/locale.php';

$error = false;
require BASE . 'install/includes/config.php';

ini_set('max_execution_time', 300);

@ob_end_flush();
ob_implicit_flush();

header('X-Accel-Buffering: no');

if (!$error) {
    require BASE . 'install/includes/database.php';
    if (isset($database_error)) { // we failed connect to the database
        error($database_error);
        return;
    }
}

if ($db->hasTable(TABLE_PREFIX . 'account_actions')) {
    $locale['step_database_error_table_exist'] = str_replace('$TABLE$', TABLE_PREFIX . 'account_actions', $locale['step_database_error_table_exist']);
    warning($locale['step_database_error_table_exist']);
} else {
    // import schema
    try {
        $db->query(file_get_contents(BASE . 'install/includes/schema.sql'));

        $locale['step_database_success_schema'] = str_replace('$PREFIX$', TABLE_PREFIX, $locale['step_database_success_schema']);
        success($locale['step_database_success_schema']);
    } catch (PDOException $error_) {
        error($locale['step_database_error_schema'] . ' ' . $error_);
        return;
    }
}

if (!$db->hasColumn('accounts', 'email')) {
    if (query("ALTER TABLE `accounts` ADD `email` varchar(255) NOT NULL DEFAULT '';"))
        success($locale['step_database_adding_field'] . ' accounts.email...');
}

if ($db->hasColumn('accounts', 'key')) {
    if (query("ALTER TABLE `accounts` MODIFY `key` VARCHAR(64) NOT NULL DEFAULT '';"))
        success($locale['step_database_modifying_field'] . ' accounts.key...');
} else {
    if (query("ALTER TABLE `accounts` ADD `key` VARCHAR(64) NOT NULL DEFAULT '' AFTER `email`;"))
        success($locale['step_database_adding_field'] . ' accounts.key...');
}

if (!$db->hasColumn('accounts', 'created')) {
    if (query("ALTER TABLE `accounts` ADD `created` INT(11) NOT NULL DEFAULT 0 AFTER `" . ($db->hasColumn('accounts', 'group_id') ? 'group_id' : 'email') . "`;"))
        success($locale['step_database_adding_field'] . ' accounts.created...');
}

if (!$db->hasColumn('accounts', 'rlname')) {
    if (query("ALTER TABLE `accounts` ADD `rlname` VARCHAR(255) NOT NULL DEFAULT '' AFTER `created`;"))
        success($locale['step_database_adding_field'] . ' accounts.rlname...');
}

if (!$db->hasColumn('accounts', 'phone')) {
    if (query("ALTER TABLE `accounts` ADD `phone` VARCHAR(15) NULL AFTER `rlname`;"))
        success($locale['step_database_adding_field'] . ' accounts.phone...');
}

if (!$db->hasColumn('accounts', 'location')) {
    if (query("ALTER TABLE `accounts` ADD `location` VARCHAR(255) NOT NULL DEFAULT '' AFTER `rlname`;"))
        success($locale['step_database_adding_field'] . ' accounts.location...');
}

if (!$db->hasColumn('accounts', 'country')) {
    if (query("ALTER TABLE `accounts` ADD `country` VARCHAR(3) NOT NULL DEFAULT '' AFTER `location`;"))
        success($locale['step_database_adding_field'] . ' accounts.country...');
}

if ($db->hasColumn('accounts', 'page_lastday')) {
    if (query("ALTER TABLE `accounts` CHANGE `page_lastday` `web_lastlogin` INT(11) NOT NULL DEFAULT 0;")) {
        $tmp = str_replace('$FIELD$', 'accounts.page_lastday', $locale['step_database_changing_field']);
        $tmp = str_replace('$FIELD_NEW$', 'accounts.web_lastlogin', $tmp);
        success($tmp);
    }
} else if (!$db->hasColumn('accounts', 'web_lastlogin')) {
    if (query("ALTER TABLE `accounts` ADD `web_lastlogin` INT(11) NOT NULL DEFAULT 0 AFTER `country`;"))
        success($locale['step_database_adding_field'] . ' accounts.web_lastlogin...');
}

if (!$db->hasColumn('accounts', 'web_flags')) {
    if (query("ALTER TABLE `accounts` ADD `web_flags` INT(11) NOT NULL DEFAULT 0 AFTER `web_lastlogin`;"))
        success($locale['step_database_adding_field'] . ' accounts.web_flags...');
}

if (!$db->hasColumn('accounts', 'email_hash')) {
    if (query("ALTER TABLE `accounts` ADD `email_hash` VARCHAR(32) NOT NULL DEFAULT '' AFTER `web_flags`;"))
        success($locale['step_database_adding_field'] . ' accounts.email_hash...');
}

if (!$db->hasColumn('accounts', 'email_verified')) {
    if (query("ALTER TABLE `accounts` ADD `email_verified` TINYINT(1) NOT NULL DEFAULT 0 AFTER `email_hash`;"))
        success($locale['step_database_adding_field'] . ' accounts.email_verified...');
}

if (!$db->hasColumn('accounts', 'email_new')) {
    if (query("ALTER TABLE `accounts` ADD `email_new` VARCHAR(255) NOT NULL DEFAULT '' AFTER `email_hash`;"))
        success($locale['step_database_adding_field'] . ' accounts.email_new...');
}

if (!$db->hasColumn('accounts', 'email_new_time')) {
    if (query("ALTER TABLE `accounts` ADD `email_new_time` INT(11) NOT NULL DEFAULT 0 AFTER `email_new`;"))
        success($locale['step_database_adding_field'] . ' accounts.email_new_time...');
}

if (!$db->hasColumn('accounts', 'email_code')) {
    if (query("ALTER TABLE `accounts` ADD `email_code` VARCHAR(255) NOT NULL DEFAULT '' AFTER `email_new_time`;"))
        success($locale['step_database_adding_field'] . ' accounts.email_code...');
}

if ($db->hasColumn('accounts', 'next_email')) {
    if (!$db->hasColumn('accounts', 'email_next')) {
        if (query("ALTER TABLE `accounts` CHANGE `next_email` `email_next` INT(11) NOT NULL DEFAULT 0;")) {
            $tmp = str_replace('$FIELD$', 'accounts.next_email', $locale['step_database_changing_field']);
            $tmp = str_replace('$FIELD_NEW$', 'accounts.email_next', $tmp);
            success($tmp);
        }
    }
} else if (!$db->hasColumn('accounts', 'email_next')) {
    if (query("ALTER TABLE `accounts` ADD `email_next` INT(11) NOT NULL DEFAULT 0 AFTER `email_code`;"))
        success($locale['step_database_adding_field'] . ' accounts.email_next...');
}

if ($db->hasColumn('guilds', 'checkdata')) {
    if (query("ALTER TABLE `guilds` MODIFY `checkdata` INT NOT NULL DEFAULT 0;"))
        success($locale['step_database_modifying_field'] . ' guilds.checkdata...');
}

if (!$db->hasColumn('guilds', 'motd')) {
    if (query("ALTER TABLE `guilds` ADD `motd` VARCHAR(255) NOT NULL DEFAULT '';"))
        success($locale['step_database_adding_field'] . ' guilds.motd...');
} else {
    if (query("ALTER TABLE `guilds` MODIFY `motd` VARCHAR(255) NOT NULL DEFAULT '';"))
        success($locale['step_database_modifying_field'] . ' guilds.motd...');
}

if (!$db->hasColumn('guilds', 'description')) {
    if (query("ALTER TABLE `guilds` ADD `description` TEXT NOT NULL;"))
        success($locale['step_database_adding_field'] . ' guilds.description...');
}

if ($db->hasColumn('guilds', 'logo_gfx_name')) {
    if (query("ALTER TABLE `guilds` CHANGE `logo_gfx_name` `logo_name` VARCHAR( 255 ) NOT NULL DEFAULT 'default.gif';")) {
        $tmp = str_replace('$FIELD$', 'guilds.logo_gfx_name', $locale['step_database_changing_field']);
        $tmp = str_replace('$FIELD_NEW$', 'guilds.logo_name', $tmp);
        success($tmp);
    }
} else if (!$db->hasColumn('guilds', 'logo_name')) {
    if (query("ALTER TABLE `guilds` ADD `logo_name` VARCHAR( 255 ) NOT NULL DEFAULT 'default.gif';"))
        success($locale['step_database_adding_field'] . ' guilds.logo_name...');
}

if (!$db->hasColumn('players', 'created')) {
    if (query("ALTER TABLE `players` ADD `created` INT(11) NOT NULL DEFAULT 0;"))
        success($locale['step_database_adding_field'] . ' players.created...');
}

if (!$db->hasColumn('players', 'deleted') && !$db->hasColumn('players', 'deletion')) {
    if (query("ALTER TABLE `players` ADD `deleted` TINYINT(1) NOT NULL DEFAULT 0;"))
        success($locale['step_database_adding_field'] . ' players.deleted...');
}

if ($db->hasColumn('players', 'hide_char')) {
    if (!$db->hasColumn('players', 'hidden')) {
        if (query("ALTER TABLE `players` CHANGE `hide_char` `hidden` TINYINT(1) NOT NULL DEFAULT 0;")) {
            $tmp = str_replace('$FIELD$', 'players.hide_char', $locale['step_database_changing_field']);
            $tmp = str_replace('$FIELD_NEW$', 'players.hidden', $tmp);
            success($tmp);
        }
    }
} else if (!$db->hasColumn('players', 'hidden')) {
    if (query("ALTER TABLE `players` ADD `hidden` TINYINT(1) NOT NULL DEFAULT 0;"))
        success($locale['step_database_adding_field'] . ' players.hidden...');
}

if (!$db->hasColumn('players', 'comment')) {
    if (query("ALTER TABLE `players` ADD `comment` TEXT NOT NULL;"))
        success($locale['step_database_adding_field'] . ' players.comment...');
}
if (!$db->hasColumn('players', 'ismain')) {
    if (query("ALTER TABLE `players` ADD `ismain` TINYINT(1) NOT NULL DEFAULT 0 AFTER `istutorial`;"))
        success($locale['step_database_adding_field'] . ' players.ismain...');
}

if ($db->hasColumn('players', 'rank_id')) {
    if (query("ALTER TABLE players MODIFY `rank_id` INT(11) NOT NULL DEFAULT 0;"))
        success($locale['step_database_modifying_field'] . ' players.rank_id...');

    if ($db->hasColumn('players', 'guildnick')) {
        if (query("ALTER TABLE players MODIFY `guildnick` VARCHAR(255) NOT NULL DEFAULT '';")) {
            success($locale['step_database_modifying_field'] . ' players.guildnick...');
        }
    }
}

if ($db->hasTable('z_forum')) {
    if (!$db->hasColumn('z_forum', 'post_html')) {
        if (query("ALTER TABLE `z_forum` ADD `post_html` tinyint(1) NOT NULL DEFAULT '0' AFTER `post_smile`;")) {
            success($locale['step_database_adding_field'] . ' z_forum.post_html...');
        }
    }

    if (!$db->hasColumn('z_forum', 'sticked')) {
        if (query("ALTER TABLE `z_forum` ADD `sticked` tinyint(1) NOT NULL DEFAULT '0';")) {
            success($locale['step_database_adding_field'] . ' z_forum.sticked...');
        }
    }

    if (!$db->hasColumn('z_forum', 'closed')) {
        if (query("ALTER TABLE `z_forum` ADD `closed` tinyint(1) NOT NULL DEFAULT '0';")) {
            success($locale['step_database_adding_field'] . ' z_forum.closed...');
        }
    }
}
