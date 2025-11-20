<?php

/**#@+
 * @version 0.1.4
 * @since 0.1.4
 */

/**
 * @package POT
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * Wrapper for binary server status request.
 *
 * @package POT
 * @property-read int $uptime Uptime.
 * @property-read string $ip IP number.
 * @property-read string $name Server name.
 * @property-read int $port Server port.
 * @property-read string $location Server physical location.
 * @property-read string $url Website URL.
 * @property-read string $serverVersion Server version.
 * @property-read string $owner Owner name.
 * @property-read string $eMail Owner's e-mail.
 * @property-read int $onlinePlayers Players online count.
 * @property-read int $maxPlayers Maximum allowed players count.
 * @property-read int $playersPeak Record of players online.
 * @property-read string $mapName Map name.
 * @property-read string $mapAuthor Map author.
 * @property-read int $mapWidth Map width.
 * @property-read int $mapHeight Map height.
 * @property-read string $motd Message Of The Day.
 * @property-read array $players Online players list.
 */
class OTS_ServerStatus
{
/**
 * Basic server info.
 */
    const REQUEST_BASIC_SERVER_INFO = 1;
/**
 * Server owner info.
 */
    const REQUEST_OWNER_SERVER_INFO = 2;
/**
 * Server extra info.
 */
    const REQUEST_MISC_SERVER_INFO = 4;
/**
 * Players stats info.
 */
    const REQUEST_PLAYERS_INFO = 8;
/**
 * Map info.
 */
    const REQUEST_MAP_INFO = 16;
/**
 * Extended players info.
 */
    const REQUEST_EXT_PLAYERS_INFO = 32;
/**
 * Player status info.
 */
    const REQUEST_PLAYER_STATUS_INFO = 64;
/**
 * Server software info.
 */
    const REQUEST_SERVER_SOFTWARE_INFO = 128;
/**
 * Basic server respond.
 */
    const RESPOND_BASIC_SERVER_INFO = 0x10;
/**
 * Server owner respond.
 */
    const RESPOND_OWNER_SERVER_INFO = 0x11;
/**
 * Server extra respond.
 */
    const RESPOND_MISC_SERVER_INFO = 0x12;
/**
 * Players stats respond.
 */
    const RESPOND_PLAYERS_INFO = 0x20;
/**
 * Map respond.
 */
    const RESPOND_MAP_INFO = 0x30;
/**
 * Extended players info.
 */
    const RESPOND_EXT_PLAYERS_INFO = 0x21;
/**
 * Player status info.
 */
    const RESPOND_PLAYER_STATUS_INFO = 0x22;
/**
 * Server software info.
 */
    const RESPOND_SERVER_SOFTWARE_INFO = 0x23;
/**
 * Server name.
 *
 * @var string
 */
    private $name;
/**
 * Server IP.
 *
 * @var string
 */
    private $ip;
/**
 * Server port.
 *
 * @var string
 */
    private $port;
/**
 * Owner name.
 *
 * @var string
 */
    private $owner;
/**
 * Owner's e-mail.
 *
 * @var string
 */
    private $eMail;
/**
 * Message of the day.
 *
 * @var string
 */
    private $motd;
/**
 * Server location.
 *
 * @var string
 */
    private $location;
/**
 * Website URL.
 *
 * @var string
 */
    private $url;
/**
 * Uptime.
 *
 * @var int
 */
    private $uptime;
/**
 * Status version.
 *
 * @var string
 */
    private $version;
/**
 * Players online.
 *
 * @var int
 */
    private $online;
/**
 * Maximum players.
 *
 * @var int
 */
    private $max;
/**
 * Players peak.
 *
 * @var int
 */
    private $peak;
/**
 * Map name.
 *
 * @var string
 */
    private $map;
/**
 * Map author.
 *
 * @var string
 */
    private $author;
/**
 * Map width.
 *
 * @var int
 */
    private $width;
/**
 * Map height.
 *
 * @var int
 */
    private $height;
/**
 * Players online list.
 *
 * @var array
 */
    private $players = array();

/**
 * Server software.
 *
 * @var string
 */
	private $softwareName;
	private $softwareVersion;
	private $softwareProtocol;

/**
 * Reads info from respond packet.
 *
 * @param OTS_Buffer $info Information packet.
 */
    public function __construct(OTS_Buffer $info)
    {
        // skips packet length
        $info->getShort();

        while( $info->isValid() )
        {
            switch( $info->getChar() )
            {
                case self::RESPOND_BASIC_SERVER_INFO:
                    $this->name = $info->getString();
                    $this->ip = $info->getString();
                    $this->port = (int) $info->getString();
                    break;

                case self::RESPOND_OWNER_SERVER_INFO:
                    $this->owner = $info->getString();
                    $this->eMail = $info->getString();
                    break;

                case self::RESPOND_MISC_SERVER_INFO:
                    $this->motd = $info->getString();
                    $this->location = $info->getString();
                    $this->url = $info->getString();

                    $uptime = $info->getLong() << 32;

                    $this->uptime += $info->getLong() + $uptime;
                    $this->version = $info->getString();
                    break;

                case self::RESPOND_PLAYERS_INFO:
                    $this->online = $info->getLong();
                    $this->max = $info->getLong();
                    $this->peak = $info->getLong();
                    break;

                case self::RESPOND_MAP_INFO:
                    $this->map = $info->getString();
                    $this->author = $info->getString();
                    $this->width = $info->getShort();
                    $this->height = $info->getShort();
                    break;

                case self::RESPOND_EXT_PLAYERS_INFO:
                    $count = $info->getLong();

                    for($i = 0; $i < $count; $i++)
                    {
                        $name = $info->getString();
                        $this->players[$name] = $info->getLong();
                    }
                    break;

				case self::RESPOND_SERVER_SOFTWARE_INFO:
					$this->softwareName = $info->getString();
					$this->softwareVersion = $info->getString();
					$this->softwareProtocol = $info->getString();
					break;
            }
        }
    }

/**
 * Returns server uptime.
 *
 * @return int Uptime.
 */
    public function getUptime()
    {
        return $this->uptime;
    }

/**
 * Returns server IP.
 *
 * @return string IP.
 */
    public function getIP()
    {
        return $this->ip;
    }

/**
 * Returns server name.
 *
 * @return string Name.
 */
    public function getName()
    {
        return $this->name;
    }

/**
 * Returns server port.
 *
 * @return int Port.
 */
    public function getPort()
    {
        return $this->port;
    }

/**
 * Returns server location.
 *
 * @return string Location.
 */
    public function getLocation()
    {
        return $this->location;
    }

/**
 * Returns server website.
 *
 * @return string Website URL.
 */
    public function getURL()
    {
        return $this->url;
    }

/**
 * Returns server version.
 *
 * @return string Version.
 */
    public function getServerVersion()
    {
        return $this->version;
    }

/**
 * Returns owner name.
 *
 * @return string Owner name.
 */
    public function getOwner()
    {
        return $this->owner;
    }

/**
 * Returns owner e-mail.
 *
 * @return string Owner e-mail.
 */
    public function getEMail()
    {
        return $this->eMail;
    }

/**
 * Returns current amount of players online.
 *
 * @return int Count of players.
 */
    public function getOnlinePlayers()
    {
        return $this->online;
    }

/**
 * Returns maximum amount of players online.
 *
 * @return int Maximum allowed count of players.
 */
    public function getMaxPlayers()
    {
        return $this->max;
    }

/**
 * Returns record of online players.
 *
 * @return int Players online record.
 */
    public function getPlayersPeak()
    {
        return $this->peak;
    }

/**
 * Returns map name.
 *
 * @return string Map name.
 */
    public function getMapName()
    {
        return $this->map;
    }

/**
 * Returns map author.
 *
 * @return string Mapper name.
 */
    public function getMapAuthor()
    {
        return $this->author;
    }

/**
 * Returns map width.
 *
 * @return int Map width.
 */
    public function getMapWidth()
    {
        return $this->width;
    }

/**
 * Returns map height.
 *
 * @return int Map height.
 */
    public function getMapHeight()
    {
        return $this->height;
    }

/**
 * Returns server's Message Of The Day
 *
 * @return string Server MOTD.
 */
    public function getMOTD()
    {
        return $this->motd;
    }

/**
 * Returns list of players currently online.
 *
 * @return array List of players in format 'name' => level.
 */
    public function getPlayers()
    {
    }

/**
 * Returns software name.
 *
 * @return string Software name.
 */
    public function getSoftwareName()
    {
        return $this->softwareName;
    }

/**
 * Returns software version.
 *
 * @return string Software version.
 */
    public function getSoftwareVersion()
    {
        return $this->softwareVersion;
    }

/**
 * Returns software protocol.
 *
 * @return string Software protocol.
 */
    public function getSoftwareProtocol()
    {
        return $this->softwareProtocol;
    }

/**
 * Magic PHP5 method.
 *
 * @param string $name Property name.
 * @return mixed Property value.
 * @throws OutOfBoundsException For non-supported properties.
 */
    public function __get($name)
    {
        switch($name)
        {
            case 'uptime':
                return $this->getUptime();

            case 'ip':
                return $this->getIP();

            case 'name':
                return $this->getName();

            case 'port':
                return $this->getPort();

            case 'location':
                return $this->getLocation();

            case 'url':
                return $this->getURL();

            case 'serverVersion':
                return $this->getServerVersion();

            case 'owner':
                return $this->getOwner();

            case 'eMail':
                return $this->getEMail();

            case 'onlinePlayers':
                return $this->getOnlinePlayers();

            case 'maxPlayers':
                return $this->getMaxPlayers();

            case 'playersPeak':
                return $this->getPlayersPeak();

            case 'mapName':
                return $this->getMapName();

            case 'mapAuthor':
                return $this->getMapAuthor();

            case 'mapWidth':
                return $this->getMapWidth();

            case 'mapHeight':
                return $this->getMapHeight();

            case 'motd':
                return $this->getMOTD();

            case 'players':
                return $this->getPlayers();

            default:
                throw new OutOfBoundsException();
        }
    }
}

/**#@-*/

?>
