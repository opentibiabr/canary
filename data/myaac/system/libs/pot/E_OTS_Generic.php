<?php

/**#@+
 * @version 0.1.1
 * @since 0.1.1
 */

/**
 * @package POT
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * Generic exception class for general exceptions.
 * 
 * @package POT
 */
class E_OTS_Generic extends E_OTS_ErrorCode
{
/**
 * No database driver speciffied.
 */
    const CONNECT_NO_DRIVER = 1;
/**
 * Invalid database driver.
 */
    const CONNECT_INVALID_DRIVER = 2;
/**
 * No free account numbers to create account.
 * 
 * @deprecated 0.1.5.+SVN This case won't be used anymore since we use named accounts now.
 */
    const CREATE_ACCOUNT_IMPOSSIBLE = 3;
}

/**#@-*/

?>
