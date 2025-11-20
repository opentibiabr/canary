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
 * This is class similar to {@link OTS_Toolbox OTS_Toolbox} except that this class contains routines for binary number operations. It is mainly used by encryption/decryption classes so you are probably not interested in using it.
 * 
 * @package POT
 */
class OTS_BinaryTools
{
/**
 * Handle proper unsigned right shift, dealing with PHP's signed shift.
 * 
 * @param int $integer Number to be shifted.
 * @param int $n Number of bits to shift.
 * @return int Shifted integer.
 */
    public static function unsignedRightShift($integer, $n)
    {
        // convert to 32 bits
        if(0xFFFFFFFF < $integer || -0xFFFFFFFF > $integer)
        {
            $integer = fmod($integer, 0xFFFFFFFF + 1);
        }

        // convert to unsigned integer
        if(0x7FFFFFFF < $integer)
        {
            $integer -= 0xFFFFFFFF + 1;
        }
        elseif(-0x80000000 > $integer)
        {
            $integer += 0xFFFFFFFF + 1;
        }

        // do right shift
        if (0 > $integer)
        {
            // remove sign bit before shift
            $integer &= 0x7FFFFFFF;
            // right shift
            $integer >>= $n;
            // set shifted sign bit
            $integer |= 1 << (31 - $n);
        }
        else
        {
            // use normal right shift
            $integer >>= $n;
        }

        return $integer;
    }

/**
 * Handle proper unsigned add, dealing with PHP's signed add.
 * 
 * @param int $a First number.
 * @param int $b Second number.
 * @return int Unsigned sum.
 */
    public static function unsignedAdd($a, $b)
    {
        // remove sign if necessary
        if($a < 0)
        {
            $a -= 1 + 0xFFFFFFFF;
        }

        if($b < 0)
        {
            $b -= 1 + 0xFFFFFFFF;
        }

        $result = $a + $b;

        // convert to 32 bits
        if(0xFFFFFFFF < $result || -0xFFFFFFFF > $result)
        {
            $result = fmod($result, 0xFFFFFFFF + 1);
        }

        // convert to signed integer
        if(0x7FFFFFFF < $result)
        {
            $result -= 0xFFFFFFFF + 1;
        }
        elseif(-0x80000000 > $result)
        {
            $result += 0xFFFFFFFF + 1;
        }

        return $result;
    }

/**
 * Transforms binary representation of large integer into string.
 * 
 * @param string $string Binary string.
 * @return string Numeric representation.
 */
    public static function bin2Int($string)
    {
        $result = '0';
        $n = strlen($string);

        do
        {
            $result = bcadd( bcmul($result, '256'), ord($string[--$n]) );
        }
        while($n > 0);

        return $result;
    }

/**
 * Transforms large integer into binary string.
 * 
 * @param string $number Large integer.
 * @return string Binary string.
 */
    public static function int2Bin($number)
    {
        $result = '';

        do
        {
            $result .= chr( bcmod($number, '256') );
            $number = bcdiv($number, '256');
        }
        while( bccomp($number, '0') );

        return $result;
    }
}

/**#@-*/

?>
