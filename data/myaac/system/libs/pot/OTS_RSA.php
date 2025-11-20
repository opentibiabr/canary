<?php

/**#@+
 * @version 0.1.2
 * @since 0.1.2
 */

/**
 * @package POT
 * @version 0.1.3
 * @author Wrzasq <wrzasq@gmail.com>
 * @author Alexander Valyalkin <valyala@gmail.com>
 * @copyright 2007 - 2008 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 * @license http://www.php.net/license/3_0.txt PHP License, Version 3.0
 */

/**
 * RSA encryption/decryption mechanism.
 * 
 * <p>
 * This code bases in large part on Alexander Valyalkin'es Crypt_RSA's source code.
 * </p>
 * 
 * @package POT
 * @version 0.1.3
 */
class OTS_RSA implements IOTS_Cipher
{
/**
 * OTServ key part.
 * 
 * @version 0.1.3
 * @since 0.1.3
 */
    const OTSERV_P = '14299623962416399520070177382898895550795403345466153217470516082934737582776038882967213386204600674145392845853859217990626450972452084065728686565928113';
/**
 * OTServ key part.
 * 
 * @version 0.1.3
 * @since 0.1.3
 */
    const OTSERV_Q = '7630979195970404721891201847792002125535401292779123937207447574596692788513647179235335529307251350570728407373705564708871762033017096809910315212884101';
/**
 * OTServ key part.
 * 
 * @version 0.1.3
 * @since 0.1.3
 */
    const OTSERV_D = '46730330223584118622160180015036832148732986808519344675210555262940258739805766860224610646919605860206328024326703361630109888417839241959507572247284807035235569619173792292786907845791904955103601652822519121908367187885509270025388641700821735345222087940578381210879116823013776808975766851829020659073';

/**
 * @deprecated 0.1.3 Use OTS_RSA::P.
 */
    const P = self::OTSERV_P;
/**
 * @deprecated 0.1.3 Use OTS_RSA::Q.
 */
    const Q = self::OTSERV_Q;
/**
 * @deprecated 0.1.3 Use OTS_RSA::D.
 */
    const D = self::OTSERV_D;

/**
 * Keys modulus.
 * 
 * @var string
 */
    private $n;

/**
 * Private key exponent.
 * 
 * @var string
 */
    private $d;

/**
 * Public key exponent.
 * 
 * @var string
 */
    private $e = '65537';

/**
 * Length of keys modulus.
 * 
 * @var int
 */
    private $length;

/**
 * Initializes new encryption session.
 * 
 * <p>
 * If you won't pass any parameters default OTServ keys will be generated. It is recommended action for compatibility with oryginal Tibia servers and clients as well as default Open Tibia implementation.
 * </p>
 * 
 * <p>
 * Note: You must be sure your <i>p</i>, <i>q</i> and <i>d</i> values are proper for RSA keys generation as class won't change it for you.
 * </p>
 * 
 * @param string $p Key part.
 * @param string $q Key part.
 * @param string $d Key part.
 * @throws LogicException When BCMath extension is not loaded.
 */
    public function __construct($p = self::OTSERV_P, $q = self::OTSERV_Q, $d = self::OTSERV_D)
    {
        // checks if required BCMath library is loaded
        if( !extension_loaded('bcmath') )
        {
            throw new LogicException();
        }

        $this->d = $d;

        // computes keys modulus
        $this->n = bcmul($p, $q);

        // length of key
        $tmp = OTS_BinaryTools::int2Bin($this->n);
        $this->length = strlen($tmp) * 8;
        $tmp = ord($tmp[ strlen($tmp) - 1]);

        // if last byte is 0
        if($tmp == 0)
        {
            $this->length -= 8;
        }
        else
        {
            // reduces last bits from count
            while(!($tmp & 0x80))
            {
                $this->length--;
                $tmp <<= 1;
            }
        }
    }

/**
 * Ecnrypts message with RSA algorithm.
 * 
 * @param string $message Message to be encrypted.
 * @return string Encrypted message.
 */
    public function encrypt($message)
    {
        // chunk length
        $length = ceil($this->length / 8);

        // c = m^e mod n
        return str_pad( strrev( OTS_BinaryTools::int2Bin( bcpowmod( OTS_BinaryTools::bin2Int( strrev( str_pad($message, $length, chr(0) ) ) ), $this->e, $this->n) ) ), $length, chr(0), STR_PAD_LEFT);
    }

/**
 * Decrypts RSA-encrypted message.
 * 
 * <p>
 * As OTServ clients use RSA encryption only for sending requests we don't need decryption here. If it will be needed, then this method will be implemented. At the moment it will throw exception.
 * </p>
 * 
 * @param string $message RSA-encrypted message.
 * @return string Decrypted content.
 * @throws LogicException Always as this method is not implemented.
 */
    public function decrypt($message)
    {
        throw new LogicException();
    }
}

/**#@-*/

?>
