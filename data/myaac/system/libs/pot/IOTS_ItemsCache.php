<?php

/**#@+
 * @version 0.0.8
 * @since 0.0.8
 */

/**
 * @package POT
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 * @todo future: Add hasItems() instead of mixed result type in readItems().
 */

/**
 * This interface defines items.xml cache handler as an standard file cache extender.
 * 
 * @package POT
 * @tutorial POT/Cache_drivers.pkg#interface.items
 */
interface IOTS_ItemsCache extends IOTS_FileCache
{
/**
 * Returns cache.
 * 
 * @param string $md5 MD5 hash of file.
 * @return array|null List of items (null if file cache is not valid).
 */
    public function readItems($md5);
/**
 * Writes items cache.
 * 
 * @param string $md5 MD5 checksum of current file.
 * @param array $items List of items to be saved.
 */
    public function writeItems($md5, $items);
}

/**#@-*/

?>
