<?php

/**#@+
 * @version 0.1.2
 * @since 0.0.6
 */

/**
 * @package POT
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * Generic exception class for error codes.
 * 
 * @package POT
 */
class E_OTS_ErrorCode extends Exception
{
/**
 * Sets error code.
 * 
 * @param int $code Error code.
 * @param string $message Optional error message.
 */
    public function __construct($code, $message = '')
    {
        parent::__construct($message, $code);
    }
}

/**#@-*/

?>
