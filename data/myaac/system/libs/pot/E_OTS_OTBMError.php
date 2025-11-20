<?php

/**#@+
 * @version 0.0.6
 * @since 0.0.6
 */

/**
 * Code in this file bases on oryginal OTServ OTBM format loading C++ code (iomapotbm.h, iomapotbm.cpp).
 * 
 * @package POT
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 */

/**
 * OTBM map loading error.
 * 
 * @package POT
 */
class E_OTS_OTBMError extends E_OTS_ErrorCode
{
/**
 * Unsupported file version.
 */
    const LOADMAPERROR_OUTDATEDHEADER = 3;
/**
 * Unknown node type.
 */
    const LOADMAPERROR_UNKNOWNNODETYPE = 8;
}

/**#@-*/

?>
