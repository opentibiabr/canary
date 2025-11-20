<?php

/**#@+
 * @version 0.0.1
 */

/**
 * This file contains main toolkit class. Please read README file for quick startup guide and/or tutorials for more info.
 *
 * @package POT
 * @version 0.1.5
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 * @todo future: Deprecations cleanup.
 * @todo future: Drop PHP 5.0.x support (PDO:: constants, array type hinting).
 * @todo future: Code as C++ extension (as an alternative to pure PHP library which of course would still be available).
 * @todo future: Implement POT namespace when it will be supported by PHP.
 * @todo future: Complete phpUnit test.
 * @todo future: Main POT class as database instance.
 * @todo future: E_* classes into *Exception, IOTS_* into *Interface, change POT classes prefix from OTS_* into OT_*, unify *List and *_List naming into *List, remove prefix from filenames.
 */

/**
 * Main POT class.
 *
 * @package POT
 * @version 0.1.5
 */
class POT
{
/**
 * North.
 */
    const DIRECTION_NORTH = 0;
/**
 * East.
 */
    const DIRECTION_EAST = 1;
/**
 * South.
 */
    const DIRECTION_SOUTH = 2;
/**
 * West.
 */
    const DIRECTION_WEST = 3;


/**
 * Skill enum.
 *
 */
	const SKILL_FIRST = 0;

	const SKILL_FIST = 0;
	const SKILL_CLUB = 1;
	const SKILL_SWORD = 2;
	const SKILL_AXE = 3;
	const SKILL_DISTANCE = 4;
	const SKILL_DIST = 4;
	const SKILL_SHIELDING = 5;
	const SKILL_SHIELD = 5;
	const SKILL_FISHING = 6;
	const SKILL_FISH = 6;

	const SKILL_MAGLEVEL = 7;
	const SKILL__MAGLEVEL = 7;
	const SKILL_MAGIC = 7;
	const SKILL__MAGIC = 7;

	const SKILL_LEVEL = 8;
	const SKILL__LEVEL = 8;

	const SKILL_LAST = self::SKILL_FISH;
	const SKILL__LAST = self::SKILL__LEVEL;
/**
 * Head slot.
 *
 * @version 0.0.3
 * @since 0.0.3
 */
    const SLOT_HEAD = 1;
/**
 * Necklace slot.
 *
 * @version 0.0.3
 * @since 0.0.3
 */
    const SLOT_NECKLACE = 2;
/**
 * Backpack slot.
 *
 * @version 0.0.3
 * @since 0.0.3
 */
    const SLOT_BACKPACK = 3;
/**
 * Armor slot.
 *
 * @version 0.0.3
 * @since 0.0.3
 */
    const SLOT_ARMOR = 4;
/**
 * Right hand slot.
 *
 * @version 0.0.3
 * @since 0.0.3
 */
    const SLOT_RIGHT = 5;
/**
 * Left hand slot.
 *
 * @version 0.0.3
 * @since 0.0.3
 */
    const SLOT_LEFT = 6;
/**
 * Legs slot.
 *
 * @version 0.0.3
 * @since 0.0.3
 */
    const SLOT_LEGS = 7;
/**
 * Boots slot.
 *
 * @version 0.0.3
 * @since 0.0.3
 */
    const SLOT_FEET = 8;
/**
 * Ring slot.
 *
 * @version 0.0.3
 * @since 0.0.3
 */
    const SLOT_RING = 9;
/**
 * Ammunition slot.
 *
 * @version 0.0.3
 * @since 0.0.3
 */
    const SLOT_AMMO = 10;

/**
 * First depot item sid.
 *
 * @version 0.0.4
 * @since 0.0.4
 */
    const DEPOT_SID_FIRST = 100;

/**
 * IP ban.
 *
 * @version 0.0.5
 * @since 0.0.5
 */
    const BAN_IP = 1;
/**
 * Player ban.
 *
 * @version 0.0.5
 * @since 0.0.5
 */
    const BAN_PLAYER = 2;
/**
 * Account ban.
 *
 * @version 0.0.5
 * @since 0.0.5
 */
    const BAN_ACCOUNT = 3;

/**
 * Ascencind sorting order.
 *
 * @version 0.0.5
 * @since 0.0.5
 */
    const ORDER_ASC = 1;
/**
 * Descending sorting order.
 *
 * @version 0.0.5
 * @since 0.0.5
 */
    const ORDER_DESC = 2;

/**
 * @version 0.0.7
 * @since 0.0.7
 * @deprecated 0.1.0 Use OTS_SpellsList::SPELL_RUNE.
 */
    const SPELL_RUNE = 0;
/**
 * @version 0.0.7
 * @since 0.0.7
 * @deprecated 0.1.0 Use OTS_SpellsList::SPELL_INSTANT.
 */
    const SPELL_INSTANT = 1;
/**
 * @version 0.0.7
 * @since 0.0.7
 * @deprecated 0.1.0 Use OTS_SpellsList::SPELL_CONJURE.
 */
    const SPELL_CONJURE = 2;

/**
 * Singleton.
 *
 * <p>
 * This method return global instance of POT class. You can only fetch it this way - class constructor is private and you can't create instance of it other way. This is clasic singleton implementation. As class names are globaly accessible you can fetch it anywhere in code.
 * </p>
 *
 * @return POT Global POT class instance.
 * @example examples/quickstart.php quickstart.php
 * @tutorial POT/Basics.pkg#basics.instance
 */
    public static function getInstance()
    {
        static $instance;

        // creates new instance
        if( !isset($instance) )
        {
            $instance = new self();
        }

        return $instance;
    }

/**
 * POT classes directory.
 *
 * <p>
 * Directory path to POT files.
 * </p>
 *
 * @var string
 */
    private $path = '';

/**
 * Set POT directory.
 *
 * <p>
 * Use this method if you keep your POT package in different directory then this file. Don't need to care about trailing directory separator - it will append it if needed.
 * </p>
 *
 * @param string $path POT files path.
 * @example examples/fakeroot.php fakeroot.php
 * @tutorial POT/Basics.pkg#basics.fakeroot
 */
    public function setPOTPath($path)
    {
        $this->path = str_replace('\\', '/', $path);

        // appends ending slash to directory path
        if( substr($this->path, -1) !== '/')
        {
            $this->path .= '/';
        }
    }

/**
 * Class initialization tools.
 *
 * <p>
 * Never create instance of this class by yourself! Use POT::getInstance()!
 * </p>
 *
 * <p>
 * Note: Since 0.0.2 version this method registers spl_autoload_register() callback. If you use POT with PHP 5.0 you need {@link compat.php compat.php library} to prevent from FATAL errors.
 * </p>
 *
 * <p>
 * Note: Since 0.0.3 version this method is private.
 * </p>
 *
 * @version 0.0.3
 */
    private function __construct()
    {
        // default POT directory
        $this->path = __DIR__ . '/';
        // registers POT autoload mechanism
        spl_autoload_register( array($this, 'loadClass') );
    }

/**
 * Loads POT class file.
 *
 * <p>
 * Runtime class loading on demand - usefull for autoloading functions. Usualy you don't need to call this method directly.
 * </p>
 *
 * <p>
 * Note: Since 0.0.2 version this method is suitable for spl_autoload_register().
 * </p>
 *
 * <p>
 * Note: Since 0.0.3 version this method handles also exception classes.
 * </p>
 *
 * @version 0.0.3
 * @param string $class Class name.
 */
    public function loadClass($class)
    {
        if( preg_match('/^(I|E_)?OTS_/', $class) > 0)
        {
            include_once($this->path . $class . '.php');
        }
    }

/**
 * Database connection.
 *
 * <p>
 * OTServ database connection object.
 * </p>
 *
 * @var OTS_DB_MySQL
 */
    private $db;

/**
 * Connects to database.
 *
 * <p>
 * Creates OTServ database connection object.
 * </p>
 *
 * <p>
 * First parameter is one of database driver constants values. Currently {@link OTS_DB_MySQL MySQL}, {@link OTS_DB_SQLite SQLite}, {@link OTS_DB_PostgreSQL PostgreSQL} and {@link OTS_DB_ODBC ODBC} drivers are supported. This parameter can be null, then you have to specify <var>'driver'</var> parameter. Such way is comfortable to store entire database configuration in one array and possibly runtime evaluation and/or configuration file saving.
 * </p>
 *
 * <p>
 * For parameters list see driver documentation. Common parameters for all drivers are:
 * </p>
 *
 * <ul>
 * <li><var>driver</var> - optional, specifies driver, aplies when <var>$driver</var> method parameter is <i>null</i>,</li>
 * <li><var>prefix</var> - optional, prefix for database tables, use if you have more then one OTServ installed on one database.</li>
 * </ul>
 *
 * <p>
 * Note: Since 0.1.1 version this method throws {@link E_OTS_Generic E_OTS_Generic exceptions} instead of general Exception class objects. Since all exception classes are child classes of Exception class so your old code will still handle all exceptions.
 * </p>
 *
 * <p>
 * Note: Since 0.1.2 version this method checks if PDO extension is loaded and if not, then throws LogicException. This exception class is part of SPL library and was introduced in PHP 5.1 so if you use PHP 5.0 you will need to load {@link compat.php compat.php library} first.
 * </p>
 *
 * @version 0.1.3
 * @param array $params Connection info.
 * @throws LogicException When PDO extension is not loaded.
 * @throws PDOException On PDO operation error.
 * @example examples/quickstart.php quickstart.php
 * @tutorial POT/Basics.pkg#basics.database
 */
    public function connect($params)
    {
        // checks if PDO extension is loaded
        if( !extension_loaded('PDO') ) {
            throw new RuntimeException('Please install PHP pdo extension. MyAAC will not work without it.');
        }

        $this->db = new OTS_DB_MySQL($params);

        $this->db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    }

/**
 * @version 0.1.0
 * @param string $class Class name.
 * @return IOTS_DAO OTServ database object.
 * @deprecated 0.1.0 Create objects directly from now.
 */
    public function createObject($class)
    {
        $class = 'OTS_' . $class;
        return new $class();
    }

/**
 * Queries server status.
 *
 * <p>
 * Sends 'info' packet to OTS server and return output. Returns {@link OTS_InfoRespond OTS_InfoRespond} (wrapper for XML data) with results or <var>false</var> if server is online.
 * </p>
 *
 * <p>
 * Note: Since 0.1.4 version this method is static so you can call it staticly, but it is also still possible to call it in dynamic context.
 * </p>
 *
 * @version 0.1.4
 * @since 0.0.2
 * @param string $server Server IP/domain.
 * @param int $port OTServ port.
 * @return OTS_InfoRespond|bool Respond content document (false when server is offline).
 * @throws DOMException On DOM operation error.
 * @example examples/info.php info.php
 * @tutorial POT/Server_status.pkg
 * @deprecated 0.1.4 Use OTS_ServerInfo->status().
 */
    public static function serverStatus($server, $port)
    {
        $status = new OTS_ServerInfo($server, $port);
        return $status->status();
    }

/**
 * Returns database connection handle.
 *
 * <p>
 * At all you shouldn't use this method and work with database using POT classes, but it may be sometime necessary to use direct database access (mainly until POT won't provide many important features).
 * </p>
 *
 * <p>
 * It is also important as serialised objects after unserialisation needs to be re-initialised with database connection.
 * </p>
 *
 * <p>
 * Note that before you will be able to fetch connection handler, you have to connect to database using {@link POT::connect() connect() method}.
 * </p>
 *
 * @version 0.0.4
 * @since 0.0.4
 * @return OTS_DB_MySQL Database connection handle.
 */
    public function getDBHandle()
    {
        return $this->db;
    }

/**
 * Bans given IP number.
 *
 * <p>
 * Adds IP/mask ban. You can call this function with only one parameter to ban only given IP address without expiration.
 * </p>
 *
 * <p>
 * Second parameter is mask which you can use to ban entire IP classes. Third parameter is time after which ban will expire. However - this is not lifetime - it is timestamp of moment, when ban should expire (and <var>0</var> means forever).
 * </p>
 *
 * @version 0.1.5
 * @since 0.0.5
 * @param mixed|string $ip IP to ban.
 * @param mixed|string $mask Mask for ban (by default bans only given IP).
 * @param int $time Time for time until expires (0 - forever).
 * @throws PDOException On PDO operation error.
 * @deprecated 0.1.5 Use OTS_IPBan class.
 */
    public function banIP($ip, $mask = '255.255.255.255', $time = 0)
    {
        // long2ip( ip2long('255.255.255.255') ) != '255.255.255.255' -.-'
        // it's because that PHP integer types are signed
        if($ip === '255.255.255.255')
        {
            $ip = 4294967295;
        }
        else
        {
            $ip = sprintf('%u', ip2long($ip) );
        }

        if($mask === '255.255.255.255')
        {
            $mask = 4294967295;
        }
        else
        {
            $mask = sprintf('%u', ip2long($mask) );
        }

        // creates ban entry
        $ban = new OTS_IPBan();
        $ban->setValue($ip);
        $ban->setParam($mask);
        $ban->setExpires($time);
        $ban->setAdded( time() );
        $ban->activate();
        $ban->save();
    }

/**
 * Deletes ban from given IP number.
 *
 * <p>
 * Removes given IP/mask ban. Remember to specify also mask if you banned intire IP class.
 * </p>
 *
 * @version 0.1.5
 * @since 0.0.5
 * @param mixed|string $ip IP to ban.
 * @param string $mask Mask for ban (by default 255.255.255.255) - not used thought.
 * @throws PDOException On PDO operation error.
 * @deprecated 0.1.5 Use OTS_IPBan class.
 */
    public function unbanIP($ip, $mask = '255.255.255.255')
    {
        // long2ip( ip2long('255.255.255.255') ) != '255.255.255.255' -.-'
        // it's because that PHP integer types are signed
        if($ip === '255.255.255.255')
        {
            $ip = 4294967295;
        }
        else
        {
            $ip = sprintf('%u', ip2long($ip) );
        }

        // mask is not used anymore

        // deletes ban entry
        $ban = new OTS_IPBan();
        $ban->find($ip);
        $ban->delete();
    }

/**
 * Checks if given IP is banned.
 *
 * @version 0.1.5
 * @since 0.0.5
 * @param mixed|string $ip IP to ban.
 * @return bool True if IP number is banned, false otherwise.
 * @throws PDOException On PDO operation error.
 * @deprecated 0.1.5 Use OTS_IPBan class.
 */
    public function isIPBanned($ip)
    {
        // long2ip( ip2long('255.255.255.255') ) != '255.255.255.255' -.-'
        // it's because that PHP integer types are signed
        if($ip === '255.255.255.255')
        {
            $ip = 4294967295;
        }
        else
        {
            $ip = sprintf('%u', ip2long($ip) );
        }

        // finds ban entry
        $ban = new OTS_IPBan();
        $ban->find($ip);
        return $ban->isLoaded() && $ban->isActive() && ( $ban->getExpires() == 0 || $ban->getExpires() > time() );
    }

/**
 * Returns list of banned IPs as list of pairs (ip => IP, mask => MASK).
 *
 * @version 0.1.5
 * @since 0.1.3
 * @return array List of banned IPs.
 * @throws PDOException On PDO operation error.
 * @deprecated 0.1.5 Use OTS_IPBans_List class.
 */
    public function bannedIPs()
    {
        $list = array();

        // generates bans array
        foreach( new OTS_IPBans_List() as $ban)
        {
            // checks if ban is active
            if( $ban->isActive() && ( $ban->getExpires() == 0 || $ban->getExpires() > time() ) )
            {
                $list[] = array('ip' => $ban->getValue(), 'mask' => $ban->getParam() );
            }
        }

        return $list;
    }

/**
 * @version 0.1.0
 * @since 0.0.5
 * @return OTS_SQLFilter Filter object.
 * @deprecated 0.1.0 Create objects directly from now.
 */
    public function createFilter()
    {
        return new OTS_SQLFilter();
    }

/**
 * List of vocations.
 *
 * @version 0.1.0
 * @since 0.0.5
 * @var OTS_VocationsList
 */
    private $vocations;

/**
 * Loads vocations list.
 *
 * <p>
 * This method loads vocations from given file. You can create local instances of vocations lists directly - calling this method will associate loaded list with POT class instance and will make it available everywhere in the code.
 * </p>
 *
 * <p>
 * Note: Since 0.1.0 version this method loads instance of {@link OTS_VocationsList OTS_VocationsList} which you should fetch to get vocations info instead of calling POT class methods.
 * </p>
 *
 * @version 0.1.0
 * @since 0.0.5
 * @param string $file vocations.xml file location.
 * @throws DOMException On DOM operation error.
 */
    public function loadVocations($file)
    {
        // loads DOM document
        $this->vocations = new OTS_VocationsList($file);
    }

/**
 * Checks if vocations are loaded.
 *
 * <p>
 * You should use this method before fetching vocations list in new enviroment, or after loading new list to make sure it is loaded.
 * </p>
 *
 * @version 0.1.0
 * @since 0.1.0
 * @return bool True if vocations are loaded.
 */
    public function areVocationsLoaded()
    {
        return isset($this->vocations);
    }

/**
 * Unloads vocations list.
 *
 * @version 0.1.0
 * @since 0.1.0
 */
    public function unloadVocations()
    {
        unset($this->vocations);
    }

/**
 * Returns vocations list object.
 *
 * <p>
 * Note: Since 0.1.0 version this method returns loaded instance of {@link OTS_VocationsList OTS_VocationsList} instead of array. However {@link OTS_VocationsList OTS_VocationsList class} provides full array interface including Iterator, Countable and ArrayAccess interfaces so your code will work fine with it.
 * </p>
 *
 * @version 0.1.3
 * @since 0.0.5
 * @return OTS_VocationsList List of vocations.
 * @throws E_OTS_NotLoaded If vocations list is not loaded.
 */
    public function getVocationsList()
    {
        if( isset($this->vocations) )
        {
            return $this->vocations;
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.0.5
 * @param string $name Vocation.
 * @return int ID.
 * @throws E_OTS_NotLoaded If vocations list is not loaded.
 * @deprecated 0.1.3 Use POT::getVocationsList()->getVocationId().
 */
    public function getVocationId($name)
    {
        if( isset($this->vocations) )
        {
            return $this->vocations->getVocationId($name);
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.0.5
 * @param int $id Vocation ID.
 * @return string Name.
 * @throws E_OTS_NotLoaded If vocations list is not loaded.
 * @deprecated 0.1.3 Use POT::getVocationsList()->getVocationName().
 */
    public function getVocationName($id)
    {
        if( isset($this->vocations) )
        {
            return $this->vocations->getVocationName($id);
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * List of loaded monsters.
 *
 * @version 0.1.0
 * @since 0.0.6
 * @var OTS_MonstersList
 */
    private $monsters;

/**
 * Loads monsters mapping file.
 *
 * <p>
 * This method loads monsters list from <var>monsters.xml</var> file in given directory. You can create local instances of monsters lists directly - calling this method will associate loaded list with POT class instance and will make it available everywhere in the code.
 * </p>
 *
 * <p>
 * Note: Since 0.1.0 version this method loads instance of {@link OTS_MonstersList OTS_MonstersList} which you should fetch to get vocations info instead of calling POT class methods.
 * </p>
 *
 * @version 0.1.0
 * @since 0.0.6
 * @param string $path Monsters directory.
 * @throws DOMException On DOM operation error.
 */
    public function loadMonsters($path)
    {
        $this->monsters = new OTS_MonstersList($path);
    }

/**
 * Checks if monsters are loaded.
 *
 * <p>
 * You should use this method before fetching monsters list in new enviroment, or after loading new list to make sure it is loaded.
 * </p>
 *
 * @version 0.1.0
 * @since 0.1.0
 * @return bool True if monsters are loaded.
 */
    public function areMonstersLoaded()
    {
        return isset($this->monsters);
    }

/**
 * Unloads monsters list.
 *
 * @version 0.1.0
 * @since 0.1.0
 */
    public function unloadMonsters()
    {
        unset($this->monsters);
    }

/**
 * Returns list of laoded monsters.
 *
 * <p>
 * Note: Since 0.1.0 version this method returns loaded instance of {@link OTS_MonstersList OTS_MonstersList} instead of array. However {@link OTS_MonstersList OTS_MonstersList class} provides full array interface including Iterator, Countable and ArrayAccess interfaces so your code will work fine with it.
 * </p>
 *
 * @version 0.1.3
 * @since 0.0.6
 * @return OTS_MonstersList List of monsters.
 * @throws E_OTS_NotLoaded If monsters list is not loaded.
 */
    public function getMonstersList()
    {
        if( isset($this->monsters) )
        {
            return $this->monsters;
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.0.6
 * @param string $name Monster name.
 * @return OTS_Monster Monster data.
 * @throws E_OTS_NotLoaded If monsters list is not loaded.
 * @deprecated 0.1.3 Use POT::getMonstersList()->getMonster().
 */
    public function getMonster($name)
    {
        if( isset($this->monsters) )
        {
            return $this->monsters->getMonster($name);
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * Spells list.
 *
 * @version 0.1.0
 * @since 0.1.0
 * @var OTS_SpellsList
 */
    private $spells;

/**
 * Loads spells list.
 *
 * <p>
 * This method loads spells list from given file. You can create local instances of spells lists directly - calling this method will associate loaded list with POT class instance and will make it available everywhere in the code.
 * </p>
 *
 * <p>
 * Note: Since 0.1.0 version this method loads instance of {@link OTS_SpellsList OTS_SpellsList} which you should fetch to get vocations info instead of calling POT class methods.
 * </p>
 *
 * @version 0.1.0
 * @since 0.0.7
 * @param string $file Spells file name.
 * @throws DOMException On DOM operation error.
 */
    public function loadSpells($file)
    {
        $this->spells = new OTS_SpellsList($file);
    }

/**
 * Checks if spells are loaded.
 *
 * <p>
 * You should use this method before fetching spells list in new enviroment, or after loading new list to make sure it is loaded.
 * </p>
 *
 * @version 0.1.0
 * @since 0.1.0
 * @return bool True if spells are loaded.
 */
    public function areSpellsLoaded()
    {
        return isset($this->spells);
    }

/**
 * Unloads spells list.
 *
 * @version 0.1.0
 * @since 0.1.0
 */
    public function unloadSpells()
    {
        unset($this->spells);
    }

/**
 * Returns list of laoded spells.
 *
 * @version 0.1.3
 * @since 0.1.0
 * @return OTS_SpellsList List of spells.
 * @throws E_OTS_NotLoaded If spells list is not loaded.
 */
    public function getSpellsList()
    {
        if( isset($this->spells) )
        {
            return $this->spells;
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.0.7
 * @return array List of rune names.
 * @throws E_OTS_NotLoaded If spells list is not loaded.
 * @deprecated 0.1.3 Use POT::getSpellsList()->getRunesList().
 */
    public function getRunesList()
    {
        if( isset($this->spells) )
        {
            return $this->spells->getRunesList();
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.0.7
 * @param string $name Rune name.
 * @return OTS_Spell Rune spell wrapper (null if rune does not exist).
 * @throws E_OTS_NotLoaded If spells list is not loaded.
 * @deprecated 0.1.3 Use POT::getSpellsList()->getRune().
 */
    public function getRune($name)
    {
        if( isset($this->spells) )
        {
            return $this->spells->getRune($name);
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.0.7
 * @return array List of instant spells names.
 * @throws E_OTS_NotLoaded If spells list is not loaded.
 * @deprecated 0.1.3 Use POT::getSpellsList()->getInstantsList().
 */
    public function getInstantsList()
    {
        if( isset($this->spells) )
        {
            return $this->spells->getInstantsList();
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.0.7
 * @param string $name Spell name.
 * @return OTS_Spell Instant spell wrapper (null if rune does not exist).
 * @throws E_OTS_NotLoaded If spells list is not loaded.
 * @deprecated 0.1.3 Use POT::getSpellsList()->getInstant().
 */
    public function getInstant($name)
    {
        if( isset($this->spells) )
        {
            return $this->spells->getInstant($name);
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.0.7
 * @return array List of conjure spells names.
 * @throws E_OTS_NotLoaded If spells list is not loaded.
 * @deprecated 0.1.3 Use POT::getSpellsList()->getConjuresList().
 */
    public function getConjuresList()
    {
        if( isset($this->spells) )
        {
            return $this->spells->getConjuresList();
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.0.7
 * @param string $name Spell name.
 * @return OTS_Spell Conjure spell wrapper (null if rune does not exist).
 * @throws E_OTS_NotLoaded If spells list is not loaded.
 * @deprecated 0.1.3 Use POT::getSpellsList()->getConjure().
 */
    public function getConjure($name)
    {
        if( isset($this->spells) )
        {
            return $this->spells->getConjure($name);
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * List of loaded houses.
 *
 * @version 0.1.0
 * @since 0.1.0
 * @var OTS_HousesList
 */
    private $houses;

/**
 * Loads houses list file.
 *
 * <p>
 * This method loads houses list from given file. You can create local instances of houses lists directly - calling this method will associate loaded list with POT class instance and will make it available everywhere in the code.
 * </p>
 *
 * @version 0.1.0
 * @since 0.1.0
 * @param string $path Houses file.
 * @throws DOMException On DOM operation error.
 */
    public function loadHouses($path)
    {
        $this->houses = new OTS_HousesList($path);
    }

/**
 * Checks if houses are loaded.
 *
 * <p>
 * You should use this method before fetching houses list in new enviroment, or after loading new list to make sure it is loaded.
 * </p>
 *
 * @version 0.1.0
 * @since 0.1.0
 * @return bool True if houses are loaded.
 */
    public function areHousesLoaded()
    {
        return isset($this->houses);
    }

/**
 * Unloads houses list.
 *
 * @version 0.1.0
 * @since 0.1.0
 */
    public function unloadHouses()
    {
        unset($this->houses);
    }

/**
 * Returns list of laoded houses.
 *
 * @version 0.1.3
 * @since 0.1.0
 * @return OTS_HousesList List of houses.
 * @throws E_OTS_NotLoaded If houses list is not loaded.
 */
    public function getHousesList()
    {
        if( isset($this->houses) )
        {
            return $this->houses;
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.1.0
 * @param int $id House ID.
 * @return OTS_House House information wrapper.
 * @throws E_OTS_NotLoaded If houses list is not loaded.
 * @deprecated 0.1.3 Use POT::getHousesList()->getHouse().
 */
    public function getHouse($id)
    {
        if( isset($this->houses) )
        {
            return $this->houses->getHouse($id);
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.1.0
 * @param string $name House name.
 * @return int House ID.
 * @throws E_OTS_NotLoaded If houses list is not loaded.
 * @deprecated 0.1.3 Use POT::getHousesList()->getHouseId().
 */
    public function getHouseId($name)
    {
        if( isset($this->houses) )
        {
            return $this->houses->getHouseId($name);
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * Cache handler for items loading.
 *
 * @version 0.1.0
 * @since 0.1.0
 * @var IOTS_FileCache
 */
    private $itemsCache;

/**
 * Presets cache handler for items loader.
 *
 * <p>
 * Use this method in order to preset cache handler for items list that you want to load into global POT instance. Note that this driver will be set for global resource only. If you will create local items list instances they won't use this driver automaticly.
 * </p>
 *
 * @param IOTS_FileCache $cache Cache handler (skip this parameter to reset cache handler to null).
 */
    public function setItemsCache(IOTS_FileCache $cache = null)
    {
        $this->itemsCache = $cache;
    }

/**
 * List of loaded items.
 *
 * @version 0.1.0
 * @since 0.1.0
 * @var OTS_ItemsList
 */
    private $items;

/**
 * Loads items list.
 *
 * <p>
 * This method loads items list from <var>items.xml</var> and <var>items.otb</var> files from given directory. You can create local instances of items lists directly - calling this method will associate loaded list with POT class instance and will make it available everywhere in the code.
 * </p>
 *
 * @version 0.1.0
 * @since 0.1.0
 * @param string $path Items information directory.
 * @throws E_OTS_FileLoaderError On binary file loading error.
 */
    public function loadItems($path)
    {
        $this->items = new OTS_ItemsList();

        // sets items cache if any
        if( isset($this->itemsCache) )
        {
            $this->items->setCacheDriver($this->itemsCache);
        }

        $this->items->loadItems($path);
    }

/**
 * Checks if items are loaded.
 *
 * <p>
 * You should use this method before fetching items list in new enviroment, or after loading new list to make sure it is loaded.
 * </p>
 *
 * @version 0.1.0
 * @since 0.1.0
 * @return bool True if items are loaded.
 */
    public function areItemsLoaded()
    {
        return isset($this->items);
    }

/**
 * Unloads items list.
 *
 * @version 0.1.0
 * @since 0.1.0
 */
    public function unloadItems()
    {
        unset($this->items);
    }

/**
 * Returns list of laoded items.
 *
 * @version 0.1.3
 * @since 0.1.0
 * @return OTS_ItemsList List of items.
 * @throws E_OTS_NotLoaded If items list is not loaded.
 */
    public function getItemsList()
    {
        if( isset($this->items) )
        {
            return $this->items;
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.1.0
 * @param int $id Item type ID.
 * @return OTS_ItemType Item type object.
 * @throws E_OTS_NotLoaded If items list is not loaded.
 * @deprecated 0.1.3 Use POT::getItemsList()->getItemType().
 */
    public function getItemType($id)
    {
        if( isset($this->items) )
        {
            return $this->items->getItemType($id);
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.1.0
 * @param string $name Item type name.
 * @return int Type ID.
 * @throws E_OTS_NotLoaded If items list is not loaded.
 * @deprecated 0.1.3 Use POT::getItemsList()->getItemTypeId().
 */
    public function getItemTypeId($name)
    {
        if( isset($this->items) )
        {
            return $this->items->getItemTypeId($name);
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * Cache handler for OTBM loading.
 *
 * @version 0.1.0
 * @since 0.1.0
 * @var IOTS_FileCache
 */
    private $mapCache;

/**
 * Presets cache handler for OTBM loader.
 *
 * <p>
 * Use this method in order to preset cache handler for map that you want to load into global POT instance. Note that this driver will be set for global resource only. If you will create local OTBM instances they won't use this driver automaticly.
 * </p>
 *
 * @param IOTS_FileCache $cache Cache handler (skip this parameter to reset cache handler to null).
 */
    public function setMapCache(IOTS_FileCache $cache = null)
    {
        $this->mapCache = $cache;
    }

/**
 * Loaded map.
 *
 * @version 0.1.0
 * @since 0.1.0
 * @var OTS_OTBMFile
 */
    private $map;

/**
 * Loads OTBM map.
 *
 * <p>
 * This method loads OTBM map from given file. You can create local instances of maps directly - calling this method will associate loaded map with POT class instance and will make it available everywhere in the code.
 * </p>
 *
 * <p>
 * Note: This method will also load houses list associated with map.
 * </p>
 *
 * @version 0.1.0
 * @since 0.1.0
 * @param string $path Map file path.
 */
    public function loadMap($path)
    {
        $this->map = new OTS_OTBMFile();

        // sets items cache if any
        if( isset($this->mapCache) )
        {
            $this->map->setCacheDriver($this->mapCache);
        }

        $this->map->loadFile($path);
        $this->houses = $this->map->getHousesList();
    }

/**
 * Checks if OTBM is loaded.
 *
 * <p>
 * You should use this method before fetching map information in new enviroment, or after loading new map to make sure it is loaded.
 * </p>
 *
 * @version 0.1.0
 * @since 0.1.0
 * @return bool True if map is loaded.
 */
    public function isMapLoaded()
    {
        return isset($this->map);
    }

/**
 * Unloads OTBM map.
 *
 * @version 0.1.0
 * @since 0.1.0
 */
    public function unloadMap()
    {
        unset($this->map);
    }

/**
 * Returns loaded map.
 *
 * @version 0.1.3
 * @since 0.1.0
 * @return OTS_OTBMFile Loaded OTBM file.
 * @throws E_OTS_NotLoaded If map is not loaded.
 */
    public function getMap()
    {
        if( isset($this->map) )
        {
            return $this->map;
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.1.0
 * @return int Map width.
 * @throws E_OTS_NotLoaded If map is not loaded.
 * @deprecated 0.1.3 Use POT::getMap()->getMapWidth().
 */
    public function getMapWidth()
    {
        if( isset($this->map) )
        {
            return $this->map->getWidth();
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.1.0
 * @return int Map height.
 * @throws E_OTS_NotLoaded If map is not loaded.
 * @deprecated 0.1.3 Use POT::getMap()->getMapHeight().
 */
    public function getMapHeight()
    {
        if( isset($this->map) )
        {
            return $this->map->getHeight();
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.1.0
 * @return string Map description.
 * @throws E_OTS_NotLoaded If map is not loaded.
 * @deprecated 0.1.3 Use POT::getMap()->getMapDescription().
 */
    public function getMapDescription()
    {
        if( isset($this->map) )
        {
            return $this->map->getDescription();
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.1.0
 * @param string $name Town.
 * @return int ID.
 * @throws E_OTS_NotLoaded If map is not loaded.
 * @deprecated 0.1.3 Use POT::getMap()->getTownId().
 */
    public function getTownId($name)
    {
        if( isset($this->map) )
        {
            return $this->map->getTownId($name);
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * @version 0.1.3
 * @since 0.1.0
 * @param int $id Town ID.
 * @return string Name.
 * @throws E_OTS_NotLoaded If map is not loaded.
 * @deprecated 0.1.3 Use POT::getMap()->getTownName().
 */
    public function getTownName($id)
    {
        if( isset($this->map) )
        {
            return $this->map->getTownName($id);
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * Display driver.
 *
 * @version 0.1.0
 * @since 0.1.0
 * @var IOTS_Display
 */
    private $display;

/**
 * Sets display driver for database-related resources.
 *
 * @version 0.1.0
 * @since 0.1.0
 * @param IOTS_Display $display Display driver.
 */
    public function setDisplayDriver(IOTS_Display $display)
    {
        $this->display = $display;
    }

/**
 * Checks if any display driver is loaded.
 *
 * <p>
 * This method is mostly used internaly by POT classes.
 * </p>
 *
 * @version 0.1.0
 * @since 0.1.0
 * @return bool True if driver is loaded.
 */
    public function isDisplayDriverLoaded()
    {
        return isset($this->display);
    }

/**
 * Unloads display driver.
 *
 * @version 0.1.0
 * @since 0.1.0
 */
    public function unloadDisplayDriver()
    {
        unset($this->display);
    }

/**
 * Returns current display driver.
 *
 * <p>
 * This method is mostly used internaly by POT classes.
 * </p>
 *
 * @version 0.1.3
 * @since 0.1.0
 * @return IOTS_Display Current display driver.
 * @throws E_OTS_NotLoaded If display driver is not loaded.
 */
    public function getDisplayDriver()
    {
        if( isset($this->display) )
        {
            return $this->display;
        }

        throw new E_OTS_NotLoaded();
    }

/**
 * Display driver for non-database resources.
 *
 * @version 0.1.3
 * @since 0.1.3
 * @var IOTS_DataDisplay
 */
    private $dataDisplay;

/**
 * Sets display driver for non-database resources.
 *
 * @version 0.1.3
 * @since 0.1.3
 * @param IOTS_DataDisplay $dataDisplay Display driver.
 */
    public function setDataDisplayDriver(IOTS_DataDisplay $dataDisplay)
    {
        $this->dataDisplay = $dataDisplay;
    }

/**
 * Checks if any display driver for non-database resources is loaded.
 *
 * <p>
 * This method is mostly used internaly by POT classes.
 * </p>
 *
 * @version 0.1.3
 * @since 0.1.3
 * @return bool True if driver is loaded.
 */
    public function isDataDisplayDriverLoaded()
    {
        return isset($this->dataDisplay);
    }

/**
 * Unloads display driver.
 *
 * @version 0.1.3
 * @since 0.1.3
 */
    public function unloadDataDisplayDriver()
    {
        unset($this->dataDisplay);
    }

/**
 * Returns current display driver.
 *
 * <p>
 * This method is mostly used internaly by POT classes.
 * </p>
 *
 * @version 0.1.3
 * @since 0.1.3
 * @return IOTS_DataDisplay Current display driver.
 * @throws E_OTS_NotLoaded If display driver is not loaded.
 */
    public function getDataDisplayDriver()
    {
        if( isset($this->dataDisplay) )
        {
            return $this->dataDisplay;
        }

        throw new E_OTS_NotLoaded();
    }
}

/*
 * This part is for PHP 5.0 compatibility.
 */

if( !defined('PDO_PARAM_STR') )
{
/**
 * @ignore
 * @version 0.0.7
 * @since 0.0.7
 * @deprecated Will be dropped after dropping IOTS_DB::SQLquote() since only this deprecated method uses it.
 */
    define('PDO_PARAM_STR', PDO::PARAM_STR);
}

if( !defined('PDO_ATTR_STATEMENT_CLASS') )
{
/**
 * @ignore
 * @version 0.0.7
 * @since 0.0.7
 * @deprecated Use PDO::ATTR_STATEMENT_CLASS, this is for PHP 5.0 compatibility.
 */
    define('PDO_ATTR_STATEMENT_CLASS', PDO::ATTR_STATEMENT_CLASS);
}

if( !defined('PDO_ATTR_ERRMODE') )
{
/**
 * @ignore
 * @version 0.1.3
 * @since 0.1.3
 * @deprecated Use PDO::ATTR_ERRMODE, this is for PHP 5.0 compatibility.
 */
    define('PDO_ATTR_ERRMODE', PDO::ATTR_ERRMODE);
}

if( !defined('PDO_ERRMODE_EXCEPTION') )
{
/**
 * @ignore
 * @version 0.1.3
 * @since 0.1.3
 * @deprecated Use PDO::ERRMODE_EXCEPTION, this is for PHP 5.0 compatibility.
 */
    define('PDO_ERRMODE_EXCEPTION', PDO::ERRMODE_EXCEPTION);
}

/**#@-*/

?>
