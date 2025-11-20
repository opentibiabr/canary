<?php

/**#@+
 * @version 0.0.6
 * @since 0.0.6
 */

/**
 * @package POT
 * @author Wrzasq <wrzasq@gmail.com>
 * @copyright 2007 (C) by Wrzasq
 * @license http://www.gnu.org/licenses/lgpl-3.0.txt GNU Lesser General Public License, Version 3
 * @todo future: Add hasCache() instead of mixed result type in readCache().
 */

/**
 * This interface describes binary files cache control drivers.
 * 
 * @package POT
 * @tutorial POT/Cache_drivers.pkg
 * @example examples/cache.php cache.php
 */
interface IOTS_FileCache
{
/**
 * Returns cache.
 * 
 * @param string $md5 MD5 hash of file.
 * @return OTS_FileNode|null Root node (null if file cache is not valid).
 */
    public function readCache($md5);
/**
 * Writes node cache.
 * 
 * @param string $md5 MD5 checksum of current file.
 * @param OTS_FileNode $root Root node of file which should be cached.
 */
    public function writeCache($md5, OTS_FileNode $root);
}

/**#@-*/

?>
