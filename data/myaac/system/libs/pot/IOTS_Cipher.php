<?php

/**#@+
 * @version 0.1.2
 * @since 0.1.2
 */

/**
 * @package POT
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * Cypher encryption/decryption class interface.
 * 
 * @package POT
 */
interface IOTS_Cipher
{
/**
 * Ecnrypts message.
 * 
 * @param string $message Message to be encrypted.
 * @return string Encrypted message.
 */
    public function encrypt($message);

/**
 * Decrypts encrypted message.
 * 
 * @param string $message Encrypted message.
 * @return string Decrypted content.
 */
    public function decrypt($message);
}

/**#@-*/

?>
