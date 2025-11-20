<?php

/**#@+
 * @version 0.0.1
 */

/**
 * @package POT
 * @version 0.1.5
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * OTServ account abstraction.
 *
 * @package POT
 * @version 0.1.5
 * @property string $name Account name.
 * @property string $password Password.
 * @property string $eMail Email address.
 * @property int $premiumEnd Timestamp of PACC end.
 * @property bool $deleted Deleted flag state.
 * @property bool $warned Warned flag state.
 * @property bool $banned Ban state.
 * @property-read int $id Account number.
 * @property-read bool $loaded Loaded state.
 * @property-read OTS_Players_List $playersList Characters of this account.
 * @property-read int $access Access level.
 * @tutorial POT/Accounts.pkg
 */
class OTS_Account extends OTS_Row_DAO implements IteratorAggregate, Countable
{
    /**
     * Account data.
     *
     * @var array
     * @version 0.1.5
     */
    private $data = array('email' => '', 'rlname' => '', 'phone' => '', 'location' => '', 'country' => '', 'web_flags' => 0, 'premdays' => 0, 'lastday' => 0, 'created' => 0, 'coins' => 0, 'coins_transferable' => 0);

    public static $cache = array();

    const GRATIS_PREMIUM_DAYS = 65535;

    /**
     * Creates new account.
     *
     * <p>
     * This method creates new account with given name. Account number is generated automaticly and saved into {@link OTS_Account::getId() ID field}.
     * </p>
     *
     * <p>
     * If you won't specify account name then random one will be generated.
     * </p>
     *
     * <p>
     * If you use own account name then it will be returned after success, and exception will be generated if it will be alredy used as name will be simply used in query with account create attempt.
     * </p>
     *
     * @param string $name Account name.
     * @return string Account name.
     * @throws PDOException On PDO operation error.
     * @since 0.1.5
     * @version 0.1.5
     * @example examples/create.php create.php
     * @tutorial POT/Accounts.pkg#create
     */
    public function createNamed($name = null)
    {
        // if name is not passed then it will be generated randomly
        if (!isset($name)) {
            // reads already existing names
            foreach ($this->db->query('SELECT ' . $this->db->fieldName('name') . ' FROM ' . $this->db->tableName('accounts'))->fetchAll() as $account) {
                $exist[] = $account['name'];
            }

            // initial name
            $name = uniqid();

            // repeats until name is unique
            while (in_array($name, $exist)) {
                $name .= '_';
            }

            // resets array for account numbers loop
            $exist = array();
        }

        // saves blank account info
        $this->db->exec('INSERT INTO ' . $this->db->tableName('accounts') . ' (' . $this->db->fieldName('name') . ', ' . $this->db->fieldName('password') . ', ' . $this->db->fieldName('email') . ') VALUES (' . $this->db->quote($name) . ', \'\', \'\')');

        // reads created account's ID
        $this->data['id'] = $this->db->lastInsertId();

        // return name of newly created account
        return $name;
    }

    /**
     * Creates new account.
     *
     * <p>
     * Create new account in given range (1 - 9999999 by default).
     * </p>
     *
     * <p>
     * Note: If account name won't be speciffied random will be created.
     * </p>
     *
     * <p>
     * Note: Since 0.0.3 version this method doesn't require buffered queries.
     * </p>
     *
     * <p>
     * Note: Since 0.1.5 version you should use {@link OTS_Account::createNamed() createNamed() method} since OTServ now uses account names.
     * </p>
     *
     * <p>
     * Note: Since 0.1.1 version this method throws {@link E_OTS_Generic E_OTS_Generic} exceptions instead of general Exception class objects. Since all exception classes are child classes of Exception class so your old code will still handle all exceptions.
     * </p>
     *
     * <p>
     * Note: Since 0.1.5 version this method no longer creates account as blocked.
     * </p>
     *
     * @param string $name Account name.
     * @param int $id Account id.
     * @return int Created account number.
     * @throws PDOException On PDO operation error.
     * @throws Exception ON lastInsertId error.
     * @version 0.1.5
     * @deprecated 0.1.5 Use createNamed().
     */
    public function create($name = NULL, $id = NULL)
    {
        if (isset($name)) {
            $nameOrNumber = 'name';
            $nameOrNumberValue = $name;
        } else {
            if (USE_ACCOUNT_NUMBER) {
                $nameOrNumber = 'number';
                $nameOrNumberValue = $id;
                $id = null;
            } else {
                $nameOrNumber = null;
            }
        }

        // saves blank account info
        $this->db->exec('INSERT INTO `accounts` (' . (isset($id) ? '`id`,' : '') . (isset($nameOrNumber) ? '`' . $nameOrNumber . '`,' : '') . '`password`, `email`, `created`) VALUES (' . (isset($id) ? $id . ',' : '') . (isset($nameOrNumber) ? $this->db->quote($nameOrNumberValue) . ',' : '') . ' \'\', \'\',' . time() . ')');

        if (isset($name)) {
            $this->data['name'] = $name;
        } else {
            if (USE_ACCOUNT_NUMBER) {
                $this->data['number'] = $name;
            }
        }

        $lastInsertId = $this->db->lastInsertId();
        if ($lastInsertId != 0) {
            $this->data['id'] = $lastInsertId;
        } elseif (isset($id)) {
            $this->data['id'] = $id;
        } else {
            throw new Exception(__CLASS__ . ':' . __METHOD__ . ' unexpected error. Please report to MyAAC Developers.');
        }

        return $this->data['id'];
    }

    /**
     * @param OTS_Group $group Group to be assigned to account.
     * @param int $min Minimum number.
     * @param int $max Maximum number.
     * @return int Created account number.
     * @version 0.0.6
     * @since 0.0.4
     * @deprecated 0.0.6 There is no more group_id field in database, use create().
     */
    public function createEx(OTS_Group $group, $min = 1, $max = 9999999)
    {
        return $this->create($min, $max);
    }

    /**
     * Loads account with given number.
     *
     * @param int $id Account number.
     * @throws PDOException On PDO operation error.
     * @version 0.0.6
     */
    public function load($id, $fresh = false, $searchOnlyById = false)
    {
        if (!$fresh && isset(self::$cache[$id])) {
            $this->data = self::$cache[$id];
            return;
        }

        $numberColumn = 'id';
        $nameOrNumber = '';
        if (!$searchOnlyById) {
            if (USE_ACCOUNT_NAME) {
                $nameOrNumber = '`name`,';
            } else if (USE_ACCOUNT_NUMBER) {
                $nameOrNumber = '`number`,';
                $numberColumn = 'number';
            }
        }

        // SELECT query on database
        $this->data = $this->db->query('SELECT `id`, ' . $nameOrNumber . '`password`, `email`, `coins`, `rlname`, `phone`, `location`, `country`, `web_flags`, ' . ($this->db->hasColumn('accounts', 'premdays') ? '`premdays`, ' : '') . ($this->db->hasColumn('accounts', 'lastday') ? '`lastday`, ' : ($this->db->hasColumn('accounts', 'premend') ? '`premend`,' : ($this->db->hasColumn('accounts', 'premium_ends_at') ? '`premium_ends_at`,' : ''))) . '`created` FROM `accounts` WHERE `' . $numberColumn . '` = ' . (int)$id)->fetch();
        self::$cache[$id] = $this->data;
    }

    /**
     * Loads account by it's name.
     *
     * <p>
     * Note: Since 0.1.5 version this method loads account by it's name not by e-mail address. To find account by it's e-mail address use {@link OTS_Account::findByEMail() findByEMail() method}.
     * </p>
     *
     * @param string $name Account's name.
     * @throws PDOException On PDO operation error.
     * @version 0.1.5
     * @since 0.0.2
     */
    public function find($name)
    {
        // finds player's ID
        $id = $this->db->query('SELECT `id` FROM `accounts` WHERE `name` = ' . $this->db->quote($name))->fetch();

        // if anything was found
        if (isset($id['id'])) {
            $this->load($id['id']);
        }
    }

    /**
     * Loads account by it's e-mail address.
     *
     * @param string $email Account's e-mail address.
     * @throws PDOException On PDO operation error.
     * @version 0.1.5
     * @since 0.1.5
     */
    public function findByEMail($email)
    {
        // finds player's ID
        $id = $this->db->query('SELECT `id` FROM `accounts` WHERE `email` = ' . $this->db->quote($email))->fetch();

        // if anything was found
        if (isset($id['id'])) {
            $this->load($id['id']);
        }
    }

    /**
     * Checks if object is loaded.
     *
     * @return bool Load state.
     */
    public function isLoaded()
    {
        return isset($this->data['id']);
    }

    /**
     * Updates account in database.
     *
     * <p>
     * Unlike other DAO objects account can't be saved without ID being set. It means that you can't just save unexisting account to automaticly create it. First you have to create record by using {@link OTS_Account::createName() createNamed() method}
     * </p>
     *
     * <p>
     * Note: Since 0.0.3 version this method throws {@link E_OTS_NotLoaded E_OTS_NotLoaded exception} instead of triggering E_USER_WARNING.
     * </p>
     *
     * @throws E_OTS_NotLoaded If account doesn't have ID assigned.
     * @throws PDOException On PDO operation error.
     * @version 0.1.5
     */
    public function save()
    {
        if (!isset($this->data['id'])) {
            throw new E_OTS_NotLoaded();
        }

        $field = 'lastday';
        if ($this->db->hasColumn('accounts', 'premend')) { // othire
            $field = 'premend';
            if (!isset($this->data['premend'])) {
                $this->data['premend'] = 0;
            }
        } else if ($this->db->hasColumn('accounts', 'premium_ends_at')) {
            $field = 'premium_ends_at';
            if (!isset($this->data['premium_ends_at'])) {
                $this->data['premium_ends_at'] = 0;
            }
        }

        // UPDATE query on database
        $this->db->exec('UPDATE `accounts` SET ' . ($this->db->hasColumn('accounts', 'name') ? '`name` = ' . $this->db->quote($this->data['name']) . ',' : '') . '`password` = ' . $this->db->quote($this->data['password']) . ', `email` = ' . $this->db->quote($this->data['email']) . ', `rlname` = ' . $this->db->quote($this->data['rlname']) . ', `location` = ' . $this->db->quote($this->data['location']) . ', `country` = ' . $this->db->quote($this->data['country']) . ', `web_flags` = ' . (int)$this->data['web_flags'] . ', ' . ($this->db->hasColumn('accounts', 'premdays') ? '`premdays` = ' . (int)$this->data['premdays'] . ',' : '') . '`' . $field . '` = ' . (int)$this->data[$field] . ' WHERE `id` = ' . $this->data['id']);
    }

    /**
     * Account number.
     *
     * <p>
     * Note: Since 0.0.3 version this method throws {@link E_OTS_NotLoaded E_OTS_NotLoaded} exception instead of triggering E_USER_WARNING.
     * </p>
     *
     * @return int Account number.
     * @throws E_OTS_NotLoaded If account is not loaded.
     * @version 0.0.3
     */
    public function getId()
    {
        if (!isset($this->data['id'])) {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['id'];
    }

    public function getNumber()
    {
        if (isset($this->data['number'])) {
            return $this->data['number'];
        }

        return $this->data['id'];
    }

    public function getRLName()
    {
        if (!isset($this->data['rlname'])) {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['rlname'];
    }

    public function getLocation()
    {
        if (!isset($this->data['location'])) {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['location'];
    }

    public function getCoins()
    {
        if (!isset($this->data['coins'])) {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['coins'];
    }

    public function getCountry()
    {
        if (!isset($this->data['country'])) {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['country'];
    }

    public function getWebFlags()
    {
        if (!isset($this->data['web_flags'])) {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['web_flags'];
    }

    public function hasFlag($flag)
    {
        if (!isset($this->data['web_flags'])) {
            throw new E_OTS_NotLoaded();
        }

        return ($this->data['web_flags'] & $flag) == $flag;
    }

    public function isAdmin()
    {
        return $this->hasFlag(FLAG_ADMIN) || $this->isSuperAdmin();
    }

    public function isSuperAdmin()
    {
        return $this->hasFlag(FLAG_SUPER_ADMIN);
    }

    /**
     * @return false|float|int
     * @throws E_OTS_NotLoaded
     */
    public function getPremDays()
    {
        if (!isset($this->data['lastday']) && !isset($this->data['premend']) && !isset($this->data['premium_ends_at'])) {
            throw new E_OTS_NotLoaded();
        }

        if (isset($this->data['premium_ends_at']) || isset($this->data['premend'])) {
            $col = isset($this->data['premium_ends_at']) ? 'premium_ends_at' : 'premend';
            $ret = ceil(($this->data[$col] - time()) / 86400);
            return $ret > 0 ? $ret : 0;
        }

        global $config;
        if (!isVipSystemEnabled() && isset($config['lua']['freePremium']) && configLua('freePremium')) return -1;

        if ($this->data['premdays'] == self::GRATIS_PREMIUM_DAYS) {
            return self::GRATIS_PREMIUM_DAYS;
        }

        if (isset($this->data['lastday'])) {
            $ret = ceil(($this->data['lastday'] - time()) / 86400);
            return $ret > 0 ? $ret : 0;
        }

        $ret = ceil($this->data['premdays'] - (date("z", time()) + (365 * (date("Y", time()) - date("Y", $this->data['lastday']))) - date("z", $this->data['lastday'])));
        return $ret > 0 ? $ret : 0;
    }

    /**
     * @return mixed
     */
    public function getExpirePremiumTime()
    {
        return $this->data['lastday'];
    }

    public function isPremium(): bool
    {
        global $config;
        if (!isVipSystemEnabled() && isset($config['lua']['freePremium']) && configLua('freePremium')) return true;

        if (isset($this->data['premium_ends_at'])) {
            return $this->data['premium_ends_at'] > time();
        }

        if (isset($this->data['premend'])) {
            return $this->data['premend'] > time();
        }

        if (isset($this->data['lastday'])) {
            return $this->data['lastday'] > time();
        }

        return ($this->data['premdays'] - (date("z", time()) + (365 * (date("Y", time()) - date("Y", $this->data['lastday']))) - date("z", $this->data['lastday'])) > 0);
    }

    public function getLastDay()
    {
        if (!isset($this->data['lastday'])) {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['lastday'];
    }

    /**
     * Get last login of the last character logged
     *
     * @return mixed
     * @throws E_OTS_NotLoaded
     */
    public function getLastLogin()
    {
        if (!isset($this->data['id'])) {
            throw new E_OTS_NotLoaded();
        }
        $value = $this->db->query("SELECT `id`, `name`, `lastlogin` FROM `players` WHERE `account_id` = {$this->data['id']} ORDER BY `lastlogin` desc;")->fetch();
        return $value['lastlogin'];
    }

    public function getCreated()
    {
        if (!isset($this->data['created'])) {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['created'];
    }

    /**
     * Name.
     *
     * @throws E_OTS_NotLoaded If account is not loaded.
     * @since 0.7.5
     * @version 0.7.5
     */
    public function setPremDays($premdays)
    {
        $lastDay = ($premdays > 0 && $premdays < OTS_Account::GRATIS_PREMIUM_DAYS) ? time() + ($premdays * 86400) : 0;
        $this->data['premdays'] = (int)$premdays;
        $this->data['lastday'] = $lastDay;
        $this->data['premend'] = $lastDay;
        $this->data['premium_ends_at'] = $lastDay;
    }

    public function setRLName($name)
    {
        $this->data['rlname'] = (string)$name;
    }

    public function setLocation($location)
    {
        $this->data['location'] = (string)$location;
    }

    public function setCountry($country)
    {
        $this->data['country'] = (string)$country;
    }

    public function setWebFlags($webflags)
    {
        $this->data['web_flags'] = (int)$webflags;
    }

    /**
     * Name.
     *
     * @return string Name.
     * @throws E_OTS_NotLoaded If account is not loaded.
     * @version 0.1.5
     * @since 0.1.5
     */
    public function getName()
    {
        if (!isset($this->data['name'])) {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['name'];
    }

    /**
     * Sets account's name.
     *
     * <p>
     * This method only updates object state. To save changes in database you need to use {@link OTS_Account::save() save() method} to flush changed to database.
     * </p>
     *
     * @param string $name Account name.
     * @since 0.1.5
     * @version 0.1.5
     */
    public function setName($name)
    {
        $this->data['name'] = (string)$name;
    }

    /**
     * Account's password.
     *
     * <p>
     * Doesn't matter what password hashing mechanism is used by OTServ - this method will just return RAW database content. It is not possible to "decrypt" hashed strings, so it even wouldn't be possible to return real password string.
     * </p>
     *
     * <p>
     * Note: Since 0.0.3 version this method throws {@link E_OTS_NotLoaded E_OTS_NotLoaded} exception instead of triggering E_USER_WARNING.
     * </p>
     *
     * @return string Password.
     * @throws E_OTS_NotLoaded If account is not loaded.
     * @version 0.0.3
     */
    public function getPassword()
    {
        if (!isset($this->data['password'])) {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['password'];
    }

    /**
     * Sets account's password.
     *
     * <p>
     * This method only updates object state. To save changes in database you need to use {@link OTS_Account::save() save() method} to flush changed to database.
     * </p>
     *
     * <p>
     * Remember that this method just sets database field's content. It doesn't apply any hashing/encryption so if OTServ uses hashing for passwords you have to apply it by yourself before passing string to this method.
     * </p>
     *
     * @param string $password Password.
     */
    public function setPassword($password)
    {
        $this->data['password'] = (string)$password;
    }

    /**
     * E-mail address.
     *
     * <p>
     * Note: Since 0.0.3 version this method throws {@link E_OTS_NotLoaded E_OTS_NotLoaded} exception instead of triggering E_USER_WARNING.
     * </p>
     *
     * @return string E-mail.
     * @throws E_OTS_NotLoaded If account is not loaded.
     * @version 0.0.3
     */
    public function getEMail()
    {
        if (!isset($this->data['email'])) {
            throw new E_OTS_NotLoaded();
        }

        return $this->data['email'];
    }

    /**
     * Sets account's email.
     *
     * <p>
     * This method only updates object state. To save changes in database you need to use {@link OTS_Account::save() save() method} to flush changed to database.
     * </p>
     *
     * @param string $email E-mail address.
     */
    public function setEMail($email)
    {
        $this->data['email'] = (string)$email;
    }


    /**
     * Reads custom field.
     *
     * <p>
     * Reads field by it's name. Can read any field of given record that exists in database.
     * </p>
     *
     * <p>
     * Note: You should use this method only for fields that are not provided in standard setters/getters (SVN fields). This method runs SQL query each time you call it so it highly overloads used resources.
     * </p>
     *
     * @param string $field Field name.
     * @return string Field value.
     * @throws E_OTS_NotLoaded If account is not loaded.
     * @throws PDOException On PDO operation error.
     * @version 0.0.5
     * @since 0.0.3
     */
    public function getCustomField($field)
    {
        if (!isset($this->data['id'])) {
            throw new E_OTS_NotLoaded();
        }

        $value = $this->db->query('SELECT ' . $this->db->fieldName($field) . ' FROM ' . $this->db->tableName('accounts') . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id'])->fetch();
        return $value[$field];
    }

    /**
     * Writes custom field.
     *
     * <p>
     * Write field by it's name. Can write any field of given record that exists in database.
     * </p>
     *
     * <p>
     * Note: You should use this method only for fields that are not provided in standard setters/getters (SVN fields). This method runs SQL query each time you call it so it highly overloads used resources.
     * </p>
     *
     * <p>
     * Note: Make sure that you pass $value argument of correct type. This method determinates whether to quote field name. It is safe - it makes you sure that no unproper queries that could lead to SQL injection will be executed, but it can make your code working wrong way. For example: $object->setCustomField('foo', '1'); will quote 1 as as string ('1') instead of passing it as a integer.
     * </p>
     *
     * @param string $field Field name.
     * @param mixed $value Field value.
     * @throws E_OTS_NotLoaded If account is not loaded.
     * @throws PDOException On PDO operation error.
     * @version 0.0.5
     * @since 0.0.3
     */
    public function setCustomField($field, $value)
    {
        if (!isset($this->data['id'])) {
            throw new E_OTS_NotLoaded();
        }

        // quotes value for SQL query
        if (!(is_int($value) || is_float($value))) {
            $value = $this->db->quote($value);
        }
        $this->db->exec('UPDATE ' . $this->db->tableName('accounts') . ' SET ' . $this->db->fieldName($field) . ' = ' . $value . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id']);
    }

    /**
     * @return array Array of OTS_Player objects from given account.
     * @throws E_OTS_NotLoaded If account is not loaded.
     * @version 0.1.0
     * @deprecated 0.0.5 Use getPlayersList().
     */
    public function getPlayers()
    {
        if (!isset($this->data['id'])) {
            throw new E_OTS_NotLoaded();
        }

        $players = array();

        foreach ($this->db->query('SELECT ' . $this->db->fieldName('id') . ' FROM ' . $this->db->tableName('players') . ' WHERE ' . $this->db->fieldName('account_id') . ' = ' . $this->data['id'])->fetchAll() as $player) {
            // creates new object
            $object = new OTS_Player();
            $object->load($player['id']);
            $players[] = $object;
        }

        return $players;
    }

    /**
     * List of characters on account.
     *
     * <p>
     * In difference to {@link OTS_Account::getPlayers() getPlayers() method} this method returns filtered {@link OTS_Players_List OTS_Players_List} object instead of array of {@link OTS_Player OTS_Player} objects. It is more effective since OTS_Player_List doesn't perform all rows loading at once.
     * </p>
     *
     * <p>
     * Note: Returned object is only prepared, but not initialised. When using as parameter in foreach loop it doesn't matter since it will return it's iterator, but if you will wan't to execute direct operation on that object you will need to call {@link OTS_Base_List::rewind() rewind() method} first.
     * </p>
     *
     * @return OTS_Players_List List of players from current account.
     * @throws E_OTS_NotLoaded If account is not loaded.
     * @version 0.1.4
     * @since 0.0.5
     */
    public function getPlayersList($withDeleted = true)
    {
        if (!isset($this->data['id'])) {
            throw new E_OTS_NotLoaded();
        }

        // creates filter
        $filter = new OTS_SQLFilter();
        $filter->compareField('account_id', (int)$this->data['id']);

        if (!$withDeleted) {
            global $db;
            if ($db->hasColumn('players', 'deletion')) {
                $filter->compareField('deletion', 0);
            } else {
                $filter->compareField('deleted', 0);
            }
        }

        // creates list object
        $list = new OTS_Players_List();
        $list->setFilter($filter);

        return $list;
    }

    /**
     * @param int $time Time for time until expires (0 - forever).
     * @throws PDOException On PDO operation error.
     * @version 0.1.5
     * @since 0.0.5
     * @deprecated 0.1.5 Use OTS_AccountBan class.
     */
    public function ban($time = 0)
    {
        // can't ban nothing
        if (!$this->isLoaded()) {
            throw new E_OTS_NotLoaded();
        }

        // creates ban entry
        $ban = new OTS_AccountBan();
        $ban->setValue($this->data['id']);
        $ban->setExpires($time);
        $ban->setAdded(time());
        $ban->activate();
        $ban->save();
    }

    /**
     * @throws PDOException On PDO operation error.
     * @since 0.0.5
     * @version 0.1.5
     * @deprecated 0.1.5 Use OTS_AccountBan class.
     */
    public function unban()
    {
        // can't unban nothing
        if (!$this->isLoaded()) {
            throw new E_OTS_NotLoaded();
        }

        // deletes ban entry
        $ban = new OTS_AccountBan();
        $ban->find($this->data['id']);
        $ban->delete();
    }

    /**
     * @return bool True if account is banned, false otherwise.
     * @throws PDOException On PDO operation error.
     * @version 0.1.5
     * @since 0.0.5
     * @deprecated 0.1.5 Use OTS_AccountBan class.
     */
    public function isBanned()
    {
        // nothing can't be banned
        if (!$this->isLoaded()) {
            throw new E_OTS_NotLoaded();
        }
        if (!isset($this->data['banned']))
            $this->loadBan();
        return ($this->data['banned'] === true);
    }

    public function getBanTime()
    {
        // nothing can't be banned
        if (!$this->isLoaded()) {
            throw new E_OTS_NotLoaded();
        }
        if (!isset($this->data['banned_time']))
            $this->loadBan();
        return $this->data['banned_time'];
    }

    public function loadBan()
    {
        // nothing can't be banned
        if (!$this->isLoaded()) {
            throw new E_OTS_NotLoaded();
        }

        if ($this->db->hasTable('account_bans')) {
            $ban = $this->db->query('SELECT `expires_at` FROM `account_bans` WHERE `account_id` = ' . $this->data['id'] . ' AND (`expires_at` > ' . time() . ' OR `expires_at` = -1) ORDER BY `expires_at` DESC')->fetch();
            $this->data['banned'] = isset($ban['expires_at']);
            $this->data['banned_time'] = isset($ban['expires_at']) ? $ban['expires_at'] : 0;
        } else if ($this->db->hasTable('bans')) {
            if ($this->db->hasColumn('bans', 'active')) {
                $ban = $this->db->query('SELECT `active`, `expires` FROM `bans` WHERE (`type` = 3 OR `type` = 5) AND `active` = 1 AND `value` = ' . $this->data['id'] . ' AND (`expires` > ' . time() . ' OR `expires` = -1) ORDER BY `expires` DESC')->fetch();
                $this->data['banned'] = isset($ban['active']);
                $this->data['banned_time'] = isset($ban['expires']) ? $ban['expires'] : 0;
            } else { // tfs 0.2
                $ban = $this->db->query('SELECT `time` FROM `bans` WHERE (`type` = 3 OR `type` = 5) AND `account` = ' . $this->data['id'] . ' AND (`time` > ' . time() . ' OR `time` = -1) ORDER BY `time` DESC')->fetch();
                $this->data['banned'] = isset($ban['time']) && ($ban['time'] == -1 || $ban['time'] > 0);
                $this->data['banned_time'] = isset($ban['time']) ? $ban['time'] : 0;
            }
        } else {
            $this->data['banned'] = false;
            $this->data['banned_time'] = 0;
        }
    }

    /**
     * Deletes account.
     *
     * <p>
     * This method physicly deletes account from database! To set <i>deleted</i> flag use {@link OTS_Account::setDeleted() setDeleted() method}.
     * </p>
     *
     * @throws E_OTS_NotLoaded If account is not loaded.
     * @throws PDOException On PDO operation error.
     * @version 0.0.5
     * @since 0.0.5
     */
    public function delete()
    {
        if (!isset($this->data['id'])) {
            throw new E_OTS_NotLoaded();
        }

        // deletes row from database
        $this->db->exec('DELETE FROM ' . $this->db->tableName('accounts') . ' WHERE ' . $this->db->fieldName('id') . ' = ' . $this->data['id']);

        // resets object handle
        unset($this->data['id']);
    }

    /**
     * Checks highest access level of account.
     *
     * @return int Access level (highest access level of all characters).
     * @throws PDOException On PDO operation error.
     */
    public function getAccess()
    {
        return $this->getGroupId();
    }

    public function getGroupId()
    {
        if (isset($this->data['group_id'])) {
            return $this->data['group_id'];
        }

        global $db;
        if ($db->hasColumn('accounts', 'group_id')) {
            $query = $this->db->query('SELECT `group_id` FROM `accounts` WHERE `id` = ' . (int)$this->getId())->fetch();
            // if anything was found
            if (isset($query['group_id'])) {
                $this->data['group_id'] = $query['group_id'];
                return $query['group_id'];
            }
        }

        $query = $this->db->query('SELECT `group_id` FROM `players` WHERE `account_id` = ' . (int)$this->getId() . ' ORDER BY `group_id` DESC LIMIT 1');
        if ($query->rowCount() == 1) {
            $query = $query->fetch();
            $this->data['group_id'] = $query['group_id'];
            return $query['group_id'];
        }

        return 0;
    }

    public function getAccGroupId()
    {
        if (isset($this->data['group_id'])) {
            return $this->data['group_id'];
        }

        global $db;
        if ($db->hasColumn('accounts', 'group_id')) {
            $query = $this->db->query('SELECT `group_id` FROM `accounts` WHERE `id` = ' . (int)$this->getId())->fetch();
            // if anything was found
            if (isset($query['group_id'])) {
                $this->data['group_id'] = $query['group_id'];
                return $query['group_id'];
            }
        }
        if ($db->hasColumn('accounts', 'type')) {
            $query = $this->db->query('SELECT `type` FROM `accounts` WHERE `id` = ' . (int)$this->getId())->fetch();
            // if anything was found
            if (isset($query['type'])) {
                $this->data['type'] = $query['type'];
                return $query['type'];
            }
        }
        return 0;
    }

    /**
     * /**
     * Checks highest access level of account in given guild.
     *
     * @param OTS_Guild $guild Guild in which access should be checked.
     * @return int Access level (highest access level of all characters).
     * @throws PDOException On PDO operation error.
     */
    public function getGuildAccess(OTS_Guild $guild)
    {
        // by default
        $access = 0;

        // finds ranks of all characters
        foreach ($this->getPlayersList(false) as $player) {
            $rank = $player->getRank();

            // checks if rank's access level is higher then previouls found highest
            if (isset($rank) && $rank->isLoaded() && $rank->getGuild()->getId() == $guild->getId() && $rank->getLevel() > $access) {
                $access = $rank->getLevel();
            }
        }

        return $access;
    }

    public function logAction($action)
    {
        $ip = get_browser_real_ip();
        if (strpos($ip, ":") === false) {
            $ipv6 = '0';
        } else {
            $ipv6 = $ip;
            $ip = '';
        }

        return $this->db->exec('INSERT INTO `' . TABLE_PREFIX . 'account_actions` (`account_id`, `ip`, `ipv6`, `date`, `action`) VALUES (' . $this->db->quote($this->getId()) . ', ' . ($ip == '' ? '0' : $this->db->quote(ip2long($ip))) . ', (' . ($ipv6 == '0' ? $this->db->quote('') : $this->db->quote(inet_pton($ipv6))) . '), UNIX_TIMESTAMP(NOW()), ' . $this->db->quote($action) . ')');
    }

    public function getActionsLog($limit1, $limit2)
    {
        $actions = array();

        foreach ($this->db->query('SELECT `ip`, `ipv6`, `date`, `action` FROM `' . TABLE_PREFIX . 'account_actions` WHERE `account_id` = ' . $this->data['id'] . ' ORDER by `date` DESC LIMIT ' . $limit1 . ', ' . $limit2 . '')->fetchAll() as $a)
            $actions[] = array('ip' => $a['ip'], 'ipv6' => $a['ipv6'], 'date' => $a['date'], 'action' => $a['action']);

        return $actions;
    }

    /**
     * Returns players iterator.
     *
     * <p>
     * There is no need to implement entire Iterator interface since we have {@link OTS_Players_List players list class} for it.
     * </p>
     *
     * @return Iterator List of players.
     * @throws PDOException On PDO operation error.
     * @throws E_OTS_NotLoaded If account is not loaded.
     * @since 0.0.5
     * @version 0.0.5
     */
    #[\ReturnTypeWillChange]
    public function getIterator()
    {
        return $this->getPlayersList();
    }

    /**
     * Returns number of player within.
     *
     * @return int Count of players.
     * @throws PDOException On PDO operation error.
     * @throws E_OTS_NotLoaded If account is not loaded.
     * @since 0.0.5
     * @version 0.0.5
     */
    public function count(): int
    {
        return $this->getPlayersList()->count();
    }

    /**
     * Magic PHP5 method.
     *
     * @param string $name Property name.
     * @return mixed Property value.
     * @throws E_OTS_NotLoaded If account is not loaded.
     * @throws OutOfBoundsException For non-supported properties.
     * @throws PDOException On PDO operation error.
     * @since 0.1.0
     * @version 0.1.5
     */
    public function __get($name)
    {
        switch ($name) {
            case 'id':
                return $this->getId();

            case 'name':
                return $this->getName();

            case 'password':
                return $this->getPassword();

            case 'eMail':
                return $this->getEMail();

            case 'premiumEnd':
                return $this->getPremiumEnd();

            case 'loaded':
                return $this->isLoaded();

            case 'playersList':
                return $this->getPlayersList();

            case 'deleted':
                return $this->isDeleted();

            case 'banned':
                return $this->isBanned();

            case 'access':
                return $this->getAccess();

            default:
                throw new OutOfBoundsException();
        }
    }

    /**
     * Magic PHP5 method.
     *
     * @param string $name Property name.
     * @param mixed $value Property value.
     * @throws E_OTS_NotLoaded If account is not loaded.
     * @throws OutOfBoundsException For non-supported properties.
     * @throws PDOException On PDO operation error.
     * @since 0.1.0
     * @version 0.1.5
     */
    public function __set($name, $value)
    {
        switch ($name) {
            case 'name':
                $this->setName($name);
                break;

            case 'password':
                $this->setPassword($value);
                break;

            case 'eMail':
                $this->setEMail($value);
                break;

            case 'premiumEnd':
                $this->setPremiumEnd($value);
                break;

            case 'deleted':
                if ($value) {
                    $this->setDeleted();
                } else {
                    $this->unsetDeleted();
                }
                break;

            case 'banned':
                if ($value) {
                    $this->ban();
                } else {
                    $this->unban();
                }
                break;

            default:
                throw new OutOfBoundsException();
        }
    }

    /**
     * Returns string representation of object.
     *
     * <p>
     * If any display driver is currently loaded then it uses it's method. Otherwise just returns account number.
     * </p>
     *
     * @return string String representation of object.
     * @since 0.1.0
     * @version 0.1.3
     */
    public function __toString()
    {
        $ots = POT::getInstance();

        // checks if display driver is loaded
        if ($ots->isDisplayDriverLoaded()) {
            return $ots->getDisplayDriver()->displayAccount($this);
        }

        return $this->getId();
    }
}

/**#@-*/

?>
