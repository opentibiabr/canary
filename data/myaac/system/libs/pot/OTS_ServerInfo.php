<?php

/**#@+
 * @version 0.1.4
 * @since 0.1.4
 */

/**
 * @package POT
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * Various server status querying methods.
 *
 * @package POT
 * @property-read OTS_InfoRespond|bool $status status() method wrapper.
 * @property-read OTS_ServerStatus|bool $info Full info() method wrapper.
 */
class OTS_ServerInfo
{
    /**
     * Server address.
     *
     * @var string
     */
    private $server;

    /**
     * Connection port.
     *
     * @var int
     */
    private $port;

    /**
     * Creates handler for new server.
     *
     * @param string $server Server IP/domain.
     * @param int $port OTServ port.
     */
    public function __construct($server, $port)
    {
        $this->server = $server;
        $this->port = $port;
    }

    /**
     * Sends packet to server.
     *
     * @param OTS_Buffer|string $packet Buffer to send.
     * @return OTS_Buffer|null Respond buffer (null if server is offline).
     * @throws E_OTS_OutOfBuffer When there is read attemp after end of packet stream.
     */
    private function send(OTS_Buffer $packet)
    {
        // connects to server
        $socket = @fsockopen($this->server, $this->port, $error, $message, config('status_timeout'));

        // if connected then checking statistics
        if ($socket) {
            // sets 5 second timeout for reading and writing
            stream_set_timeout($socket, 5);

            // creates real packet
            $packet = $packet->getBuffer();
            $packet = pack('v', strlen($packet)) . $packet;

            // sends packet with request
            // 06 - length of packet, 255, 255 is the comamnd identifier, 'info' is a request
            fwrite($socket, $packet);

            // reads respond
            //$data = stream_get_contents($socket);
            $data = '';
            while (!feof($socket))
                $data .= fgets($socket, 1024);

            // closing connection to current server
            fclose($socket);

            // sometimes server returns empty info
            if (empty($data)) {
                // returns offline state
                return false;
            }

            return new OTS_Buffer($data);
        }

        return false;
    }

    /**
     * Queries server status.
     *
     * <p>
     * Sends 'info' packet to OTS server and return output. Returns {@link OTS_InfoRespond OTS_InfoRespond} (wrapper for XML data) with results or <var>false</var> if server is online.
     * </p>
     *
     * @return OTS_InfoRespond|bool Respond content document (false when server is offline).
     * @throws DOMException On DOM operation error.
     * @throws E_OTS_OutOfBuffer When there is read attemp after end of packet stream.
     * @example examples/info.php info.php
     * @tutorial POT/Server_status.pkg
     */
    public function status()
    {
        // request packet
        $request = new OTS_Buffer();
        $request->putChar(255);
        $request->putChar(255);
        $request->putString('info', false);

        $status = $this->send($request);

        // checks if server is online
        if ($status) {
            // loads respond XML
            $info = new OTS_InfoRespond();
            if (!$info->loadXML($status->getBuffer()))
                return false;

            return $info;
        }

        // offline
        return false;
    }

    /**
     * Queries server information.
     *
     * <p>
     * This method uses binary info protocol. It provides more infromation then {@link OTS_Toolbox::serverStatus() XML way}.
     * </p>
     *
     * @param int $flags Requested info flags.
     * @return OTS_ServerStatus|bool Respond content document (false when server is offline).
     * @throws E_OTS_OutOfBuffer When there is read attemp after end of packet stream.
     * @example examples/server.php info.php
     * @tutorial POT/Server_status.pkg
     */
    public function info($flags)
    {
        // request packet
        $request = new OTS_Buffer();
        $request->putChar(255);
        $request->putChar(1);
        $request->putShort($flags);

        $status = $this->send($request);

        // checks if server is online
        if ($status) {
            // loads respond
            return new OTS_ServerStatus($status);
        }

        // offline
        return false;
    }

    /**
     * Checks player online status.
     *
     * <p>
     * This method uses binary info protocol.
     * </p>
     *
     * @param string $name Player name.
     * @return bool True if player is online, false if player or server is online.
     * @throws E_OTS_OutOfBuffer When there is read attemp after end of packet stream.
     * @example examples/server.php info.php
     * @tutorial POT/Server_status.pkg
     */
    public function playerStatus($name)
    {
        // request packet
        $request = new OTS_Buffer();
        $request->putChar(255);
        $request->putChar(1);
        $request->putShort(OTS_ServerStatus::REQUEST_PLAYER_STATUS_INFO);
        $request->putString($name);

        $status = $this->send($request);

        // checks if server is online
        if ($status) {
            $status->getChar();
            return (bool)$status->getChar();
        }

        // offline
        return false;
    }

    /**
     * Magic PHP5 method.
     *
     * @param string $name Property name.
     * @param mixed $value Property value.
     * @throws OutOfBoundsException For non-supported properties.
     * @throws E_OTS_OutOfBuffer When there is read attemp after end of packet stream.
     */
    public function __get($name)
    {
        switch ($name) {
            case 'status':
                return $this->status();

            case 'info':
                return $this->info(OTS_ServerStatus::REQUEST_BASIC_SERVER_INFO | OTS_ServerStatus::REQUEST_OWNER_SERVER_INFO | OTS_ServerStatus::REQUEST_MISC_SERVER_INFO | OTS_ServerStatus::REQUEST_PLAYERS_INFO | OTS_ServerStatus::REQUEST_MAP_INFO | OTS_ServerStatus::REQUEST_PLAYER_STATUS_INFO);

            default:
                throw new OutOfBoundsException();
        }
    }
}

/**#@-*/
