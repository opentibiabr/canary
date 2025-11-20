<?php

/**#@+
 * @version 0.1.2
 * @since 0.1.2
 */

/**
 * @package POT
 * @author Wrzasq <wrzasq@gmail.com>
 * @author Jeroen Derks <jeroen@derks.it>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 * @license http://www.php.net/license/2_02.txt PHP License, Version 2.02
 */

/**
 * XTEA encryption/decryption mechanism.
 * 
 * <p>
 * This code bases in large part on Jeroen Derks'es Crypt_Xtea's source code.
 * </p>
 * 
 * @package POT
 */
class OTS_XTEA implements IOTS_Cipher
{
/**
 * Encryption key.
 * 
 * @var array
 */
    private $key;

/**
 * Initializes new encryption session.
 * 
 * <p>
 * Note: Your key must be exacly 128bit length (16 characters)! Class will not resize it for you.
 * </p>
 * 
 * @param string $key Encryption key to be used.
 */
    public function __construct($key)
    {
        $this->key = array_values( unpack('V4', $key) );
    }

/**
 * Encrypt a string with XTEA algorithm.
 * 
 * @param string $message Data to encrypt.
 * @return string Encrypted message.
 */
    public function encrypt($message)
    {
        // resize data to 32 bits
        $n = strlen($message);
        $message = pack('v', $n) . str_pad($message, $n - ($n - 2) % 4 + 4, chr(0) );

        // convert data to long integers
        $message = array_values( unpack('V*', $message) );
        $length = count($message);

        // converts to unsigned integers
        foreach($message as $index => $result)
        {
            if($result < 0)
            {
                $message[$index] += 0xFFFFFFFF + 1;
            }
        }

        // resizes to 64 bits
        if($length % 2 == 1)
        {
            $message[] = 0;
        }

        $result = '';

        // encrypt the long data with the key
        for($i = 0; $i < $length; $i++)
        {
            $sum = 0;
            $delta = 0x9E3779B9;
            $y = $message[$i];
            $z = $message[++$i];

            for($j = 0; $j < 32; $j++)
            {
                $y = OTS_BinaryTools::unsignedAdd($y, OTS_BinaryTools::unsignedAdd( ($z << 4) ^ OTS_BinaryTools::unsignedRightShift($z, 5), $z) ^ OTS_BinaryTools::unsignedAdd($sum, $this->key[$sum & 3]) );
                $sum = OTS_BinaryTools::unsignedAdd($sum, $delta);
                $z = OTS_BinaryTools::unsignedAdd($z, OTS_BinaryTools::unsignedAdd( ($y << 4) ^ OTS_BinaryTools::unsignedRightShift($y, 5), $y) ^ OTS_BinaryTools::unsignedAdd($sum, $this->key[ OTS_BinaryTools::unsignedRightShift($sum, 11) & 3]) );
            }

            // append the enciphered longs to the result
            $result .= pack('VV', $y, $z);
        }

        return $result;
    }

/**
 * Decrypt XTEA-encrypted string.
 * 
 * @param string $message Encrypted message.
 * @return string Decrypted string.
 */
    public function decrypt($message)
    {
        // convert data to long
        $message = array_values( unpack('V*', $message) );
        $length = count($message);

        // converts to unsigned integers
        foreach($message as $index => $result)
        {
            if($result < 0)
            {
                $message[$index] += 0xFFFFFFFF + 1;
            }
        }

        // decrypt the long data with the key
        $result = '';

        for($i = 0; $i < $length; $i++)
        {
            $sum = 0xC6EF3720;
            $delta = 0x61C88647;
            $y = $message[$i];
            $z = $message[++$i];

            for($j = 0; $j < 32; $j++)
            {
                $z = OTS_BinaryTools::unsignedAdd($z, -( OTS_BinaryTools::unsignedAdd( ($y << 4) ^ OTS_BinaryTools::unsignedRightShift($y, 5), $y) ^ OTS_BinaryTools::unsignedAdd($sum, $this->key[ OTS_BinaryTools::unsignedRightShift($sum, 11) & 3]) ) );
                $sum = OTS_BinaryTools::unsignedAdd($sum, $delta);
                $y = OTS_BinaryTools::unsignedAdd($y, -( OTS_BinaryTools::unsignedAdd( ($z << 4) ^ OTS_BinaryTools::unsignedRightShift($z, 5), $z) ^ OTS_BinaryTools::unsignedAdd($sum, $this->key[$sum & 3]) ) );
            }

            // append the deciphered longs to the result data
            $result .= pack('VV', $y, $z);
        }

        // reads message length
        $offset = unpack('v', $result);

        return substr($result, 2, $offset[1]);
    }
}

/**#@-*/

?>
