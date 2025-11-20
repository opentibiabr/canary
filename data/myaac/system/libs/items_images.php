<?php
/**
 * Items_Images class
 *
 * @package   MyAAC
 * @author    Slawkens <slawkens@gmail.com>
 * @author    OpenTibiaBR
 * @copyright 2023 MyAAC
 * @link      https://github.com/opentibiabr/myaac
 */
defined('MYAAC') or die('Direct access not allowed!');

if ( !function_exists( 'stackId' ) )
{
	function stackId( $count )
	{
		if ( $count >= 50 )
			$stack = 8;
		elseif ( $count >= 25 )
			$stack = 7;
		elseif ( $count >= 10 )
			$stack = 6;
		elseif ( $count >= 5 )
			$stack = 5;
		elseif ( $count >= 4 )
			$stack = 4;
		elseif ( $count >= 3 )
			$stack = 3;
		elseif ( $count >= 2 )
			$stack = 2;
		else
			$stack = 1;

		return $stack;
	}
}

class Items_Images
{
	public static $outputDir = '';
	public static $files = array();

	private static $otb, $dat, $spr;
	private static $lastItem;
	private static $loaded = false;

	public function __destruct()
	{
		if(self::$otb)
			fclose(self::$otb);
		if(self::$dat)
			fclose(self::$dat);
		if(self::$spr)
			fclose(self::$spr);
	}

	public static function generate($id = 100, $count = 1)
	{
		if(!self::$loaded)
			self::load();

		$originalId = $id;
		if($id < 100)
			return false;
			//die('ID cannot be lower than 100.');

		rewind(self::$otb);
		rewind(self::$dat);
		rewind(self::$spr);

		$nostand = false;
		$init = false;
		$originalId = $id;

		// parse info from otb
		while( false !== ( $char = fgetc( self::$otb ) ) )
		{
			$byte = HEX_PREFIX.bin2hex( $char );

			if ( $byte == 0xFE )
				$init = true;
			elseif ( $byte == 0x10 and $init ) {
				extract( unpack( 'x2/Ssid', fread( self::$otb, 4 ) ) );

				if ( $id == $sid ) {
					if ( HEX_PREFIX.bin2hex( fread( self::$otb, 1 ) ) == 0x11 ) {
						extract( unpack( 'x2/Sid', fread( self::$otb, 4 ) ) );
						break;
					}
				}
				$init = false;
			}
		}

		self::$lastItem = array_sum( unpack( 'x4/S*', fread( self::$dat, 12 )));
		if($id > self::$lastItem)
			return false;

		//ini_set('max_execution_time', 300);
		// parse info from dat
		for( $i = 100; $i <= $id; $i++ ) {
			while( ( $byte = HEX_PREFIX.bin2hex( fgetc( self::$dat ) ) ) != 0xFF ) {
				$offset = 0;
				switch( $byte ) {
					case 0x00:
					case 0x09:
					case 0x0A:
					case 0x1A:
					case 0x1D:
					case 0x1E:
						$offset = 2;
						break;

					case 0x16:
					case 0x19:
						$offset = 4;
						break;

					case 0x01:
					case 0x02:
					case 0x03:
					case 0x04:
					case 0x05:
					case 0x06:
					case 0x07:
					case 0x08:
					case 0x0B:
					case 0x0C:
					case 0x0D:
					case 0x0E:
					case 0x0F:
					case 0x10:
					case 0x11:
					case 0x12:
					case 0x13:
					case 0x14:
					case 0x15:
					case 0x17:
					case 0x18:
					case 0x1B:
					case 0x1C:
					case 0x1F:
					case 0x20:
						break;

					default:
						return false; #trigger_error( sprintf( 'Unknown .DAT byte %s (previous byte: %s; address %x)', $byte, $prev, ftell( $dat ), E_USER_ERROR ) );
						break;
				}

				$prev = $byte;
				fseek( self::$dat, $offset, SEEK_CUR );
			}
			extract( unpack( 'Cwidth/Cheight', fread( self::$dat, 2 ) ) );

			if ( $width > 1 or $height > 1 ) {
				fseek( self::$dat, 1, SEEK_CUR );
				$nostand = true;
			}

			$sprites_c = array_product( unpack( 'C*', fread( self::$dat, 5 ) ) ) * $width * $height;
			$sprites = unpack( 'S*', fread( self::$dat, 2 * $sprites_c ) );
		}

		if ( array_key_exists( stackId( $count ), $sprites ) ) {
			$sprites = (array) $sprites[stackId( $count )];
		}
		else {
			$sprites = (array) $sprites[array_rand( $sprites ) ];
		}

		fseek( self::$spr, 6 );

		$sprite = imagecreatetruecolor( 32 * $width, 32 * $height );
		imagecolortransparent( $sprite, imagecolorallocate( $sprite, 0, 0, 0 ) );

		foreach( $sprites as $key => $value ) {
			fseek( self::$spr, 6 + ( $value - 1 ) * 4 );
			extract( unpack( 'Laddress', fread( self::$spr, 4 ) ) );

			fseek( self::$spr, $address + 3 );
			extract( unpack( 'Ssize', fread( self::$spr, 2 ) ) );

			list( $num, $bit ) = array( 0, 0 );

			while( $bit < $size ) {
				$pixels = unpack( 'Strans/Scolored', fread( self::$spr, 4 ) );
				$num += $pixels['trans'];
				for( $i = 0; $i < $pixels['colored']; $i++ )
				{
					extract( unpack( 'Cred/Cgreen/Cblue', fread( self::$spr, 3 ) ) );

					$red = ( $red == 0 ? ( $green == 0 ? ( $blue == 0 ? 1 : $red ) : $red ) : $red );

					imagesetpixel( $sprite,
						$num % 32 + ( $key % 2 == 1 ? 32 : 0 ),
						$num / 32 + ( $key % 4 != 1 and $key % 4 != 0 ? 32 : 0 ),
						imagecolorallocate( $sprite, $red, $green, $blue ) );

					$num++;
				}

				$bit += 4 + 3 * $pixels['colored'];
			}
		}

		if ( $count >= 2 ) {
			if ( $count > 100 )
				$count = 100;

			$font = 3;
			$length = imagefontwidth( $font ) * strlen( $count );

			$pos = array(
				'x' => ( 32 * $width ) - ( $length + 1 ),
				'y' => ( 32 * $height ) - 13
			);
			imagestring( $sprite, $font, $pos['x'] - 1, $pos['y'] - 1, $count, imagecolorallocate( $sprite, 1, 1, 1 ) );
			imagestring( $sprite, $font, $pos['x'], $pos['y'] - 1, $count, imagecolorallocate( $sprite, 1, 1, 1 ) );
			imagestring( $sprite, $font, $pos['x'] - 1, $pos['y'], $count, imagecolorallocate( $sprite, 1, 1, 1 ) );

			imagestring( $sprite, $font, $pos['x'], $pos['y'] + 1, $count, imagecolorallocate( $sprite, 1, 1, 1 ) );
			imagestring( $sprite, $font, $pos['x'] + 1, $pos['y'], $count, imagecolorallocate( $sprite, 1, 1, 1 ) );
			imagestring( $sprite, $font, $pos['x'] + 1, $pos['y'] + 1, $count, imagecolorallocate( $sprite, 1, 1, 1 ) );

			imagestring( $sprite, $font, $pos['x'], $pos['y'], $count, imagecolorallocate( $sprite, 219, 219, 219 ) );
		}

		$imagePath = self::$outputDir . ($count > 1 ? $originalId . '-' . $count : $originalId ) . '.gif';

		// save image
		imagegif($sprite, $imagePath);
	}

	public static function load()
	{
		if(!defined( 'HEX_PREFIX'))
			define('HEX_PREFIX', '0x');

		self::$otb = fopen(self::$files['otb'], 'rb');
		self::$dat = fopen(self::$files['dat'], 'rb');
		self::$spr = fopen(self::$files['spr'], 'rb');

		if(!self::$otb || !self::$dat || !self::$spr)
			throw new RuntimeException('ERROR: Cannot load data files.');
		/*
		if ( $nostand )
		{
			for( $i = 0; $i < count( $sprites ) / 4; $i++ )
			{
				$sprites = array_merge( (array) $sprites, array_reverse( array_slice( $sprites, $i * 4, 4 ) ) );
			}
		}
		else
		{
			$sprites = (array) $sprites[array_rand( $sprites ) ];
		}
		*/

		self::$loaded = true;
	}

	public static function loaded() {
		return self::$loaded;
	}
}
