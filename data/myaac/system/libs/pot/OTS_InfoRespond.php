<?php

/**#@+
 * @version 0.0.2
 * @since 0.0.2
 */

/**
 * @package POT
 * @version 0.1.0
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * Wrapper for 'info' respond's DOMDocument.
 * 
 * <p>
 * Note: as this class extends DOMDocument class and contains exacly respond XML tree you can work on it as on normal DOM tree.
 * </p>
 * 
 * @package POT
 * @version 0.1.0
 * @property-read string $tspqVersion Root element version.
 * @property-read int $uptime Uptime.
 * @property-read string $ip IP number.
 * @property-read string $name Server name.
 * @property-read int $port Server port.
 * @property-read string $location Server physical location.
 * @property-read string $url Website URL.
 * @property-read string $server What the hell...?
 * @property-read string $serverVersion Server version.
 * @property-read string $clientVersion Client version.
 * @property-read string $owner Owner name.
 * @property-read string $eMail Owner's e-mail.
 * @property-read int $onlinePlayers Players online count.
 * @property-read int $maxPlayers Maximum allowed players count.
 * @property-read int $playersPeak Record of players online.
 * @property-read int $monstersCount Number of monsters on map.
 * @property-read string $mapName Map name.
 * @property-read string $mapAuthor Map author.
 * @property-read int $mapWidth Map width.
 * @property-read int $mapHeight Map height.
 * @property-read string $motd Message Of The Day.
 */
class OTS_InfoRespond extends DOMDocument
{
/**
 * Returns version of root element.
 * 
 * @return string TSPQ version.
 * @throws DOMException On DOM operation error.
 */
    public function getTSPQVersion()
    {
        return $this->documentElement->getAttribute('version');
    }

/**
 * Returns server uptime.
 * 
 * @return int Uptime.
 * @throws DOMException On DOM operation error.
 */
    public function getUptime()
    {
        return (int) $this->documentElement->getElementsByTagName('serverinfo')->item(0)->getAttribute('uptime');
    }

/**
 * Returns server IP.
 * 
 * @return string IP.
 * @throws DOMException On DOM operation error.
 */
    public function getIP()
    {
        return $this->documentElement->getElementsByTagName('serverinfo')->item(0)->getAttribute('ip');
    }

/**
 * Returns server name.
 * 
 * @return string Name.
 * @throws DOMException On DOM operation error.
 */
    public function getName()
    {
        return $this->documentElement->getElementsByTagName('serverinfo')->item(0)->getAttribute('servername');
    }

/**
 * Returns server port.
 * 
 * @return int Port.
 * @throws DOMException On DOM operation error.
 */
    public function getPort()
    {
        return (int) $this->documentElement->getElementsByTagName('serverinfo')->item(0)->getAttribute('port');
    }

/**
 * Returns server location.
 * 
 * @return string Location.
 * @throws DOMException On DOM operation error.
 */
    public function getLocation()
    {
        return $this->documentElement->getElementsByTagName('serverinfo')->item(0)->getAttribute('location');
    }

/**
 * Returns server website.
 * 
 * @return string Website URL.
 * @throws DOMException On DOM operation error.
 */
    public function getURL()
    {
        return $this->documentElement->getElementsByTagName('serverinfo')->item(0)->getAttribute('url');
    }

/**
 * Returns server attribute.
 * 
 * I have no idea what the hell is it representing :P.
 * 
 * @return string Attribute value.
 * @throws DOMException On DOM operation error.
 */
    public function getServer()
    {
        return $this->documentElement->getElementsByTagName('serverinfo')->item(0)->getAttribute('server');
    }

/**
 * Returns server version.
 * 
 * @return string Version.
 * @throws DOMException On DOM operation error.
 */
    public function getServerVersion()
    {
        return $this->documentElement->getElementsByTagName('serverinfo')->item(0)->getAttribute('version');
    }

/**
 * Returns dedicated version of client.
 * 
 * @return string Version.
 * @throws DOMException On DOM operation error.
 */
    public function getClientVersion()
    {
        return $this->documentElement->getElementsByTagName('serverinfo')->item(0)->getAttribute('client');
    }

/**
 * Returns owner name.
 * 
 * @return string Owner name.
 * @throws DOMException On DOM operation error.
 */
    public function getOwner()
    {
        return $this->documentElement->getElementsByTagName('owner')->item(0)->getAttribute('name');
    }

/**
 * Returns owner e-mail.
 * 
 * @return string Owner e-mail.
 * @throws DOMException On DOM operation error.
 */
    public function getEMail()
    {
        return $this->documentElement->getElementsByTagName('owner')->item(0)->getAttribute('email');
    }

/**
 * Returns current amount of players online.
 * 
 * @return int Count of players.
 * @throws DOMException On DOM operation error.
 */
    public function getOnlinePlayers()
    {
        return (int) $this->documentElement->getElementsByTagName('players')->item(0)->getAttribute('online');
    }

/**
 * Returns maximum amount of players online.
 * 
 * @return int Maximum allowed count of players.
 * @throws DOMException On DOM operation error.
 */
    public function getMaxPlayers()
    {
        return (int) $this->documentElement->getElementsByTagName('players')->item(0)->getAttribute('max');
    }

/**
 * Returns record of online players.
 * 
 * @return int Players online record.
 * @throws DOMException On DOM operation error.
 */
    public function getPlayersPeak()
    {
        return (int) $this->documentElement->getElementsByTagName('players')->item(0)->getAttribute('peak');
    }

/**
 * Returns number of all monsters on map.
 * 
 * @return int Count of monsters.
 * @throws DOMException On DOM operation error.
 */
    public function getMonstersCount()
    {
        return (int) $this->documentElement->getElementsByTagName('monsters')->item(0)->getAttribute('total');
    }

/**
 * Returns map name.
 * 
 * @return string Map name.
 * @throws DOMException On DOM operation error.
 */
    public function getMapName()
    {
        return $this->documentElement->getElementsByTagName('map')->item(0)->getAttribute('name');
    }

/**
 * Returns map author.
 * 
 * @return string Mapper name.
 * @throws DOMException On DOM operation error.
 */
    public function getMapAuthor()
    {
        return $this->documentElement->getElementsByTagName('map')->item(0)->getAttribute('author');
    }

/**
 * Returns map width.
 * 
 * @return int Map width.
 * @throws DOMException On DOM operation error.
 */
    public function getMapWidth()
    {
        return (int) $this->documentElement->getElementsByTagName('map')->item(0)->getAttribute('width');
    }

/**
 * Returns map height.
 * 
 * @return int Map height.
 * @throws DOMException On DOM operation error.
 */
    public function getMapHeight()
    {
        return (int) $this->documentElement->getElementsByTagName('map')->item(0)->getAttribute('height');
    }

/**
 * Returns server's Message Of The Day
 * 
 * @version 0.1.0
 * @return string Server MOTD.
 * @throws DOMException On DOM operation error.
 */
    public function getMOTD()
    {
        // look for text node child
        foreach( $this->documentElement->getElementsByTagName('motd')->item(0)->childNodes as $child)
        {
            if($child->nodeType == XML_TEXT_NODE)
            {
                // found
                return $child->nodeValue;
            }
        }

        // strange...
        return '';
    }

/**
 * Magic PHP5 method.
 * 
 * @version 0.1.0
 * @since 0.1.0
 * @param string $name Property name.
 * @return mixed Property value.
 * @throws OutOfBoundsException For non-supported properties.
 * @throws DOMException On DOM operation error.
 */
    public function __get($name)
    {
        switch($name)
        {
            case 'tspqVersion':
                return $this->getTSPQVersion();

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

            case 'server':
                return $this->getServer();

            case 'serverVersion':
                return $this->getServerVersion();

            case 'clientVersion':
                return $this->getClientVersion();

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

            case 'monstersCount':
                return $this->getMonstersCount();

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

            default:
                throw new OutOfBoundsException();
        }
    }

/**
 * Returns string representation of XML.
 * 
 * @version 0.1.0
 * @since 0.1.0
 * @return string String representation of object.
 */
    public function __toString()
    {
        return $this->saveXML();
    }
}

/**#@-*/

?>
