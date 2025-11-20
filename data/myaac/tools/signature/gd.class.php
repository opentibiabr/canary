<?PHP
	defined('MYAAC') or die('Direct access not allowed!');
	/**
	 * @author Christopher Eklund
	 * @copyright MadPHP.org 2009
	 * @version 2.4.5
	**/
	class MadGD
	{
		public $textConfig = array( 'font' => 2, 'size' => 9, 'color' => 'FFFFFF', 'shadow' => true );
		public $textBold   = array( 'font' => 3, 'size' => 9, 'color' => 'FFFFFF', 'shadow' => true );
		public $testMode   = false;
		public $background = null;
		public $extension  = null;
		public $instance   = null;

		public $equipment  = array(
			'pos' => array(
				'x' => 339,
				'y' => 3
			),
			'x' => array( ),
			'y' => array( )
		);

		public $x = 0;
		public $y = 0;
		public $l = 0;


		/**
		 * @access public
		 * @return null
		**/
		public function __construct( $path = null )
		{
			if ( $path != null )
			{
				$this->setBackground( $path );
			}
			$this->setEquipments( );
		}


		public function save($player_id)
		{
			imagepng($this->instance, SIGNATURES_CACHE . $player_id . '.png');
			imagedestroy($this->instance);
		}
		/**
		 * @access public
		 * @return null
		**/
		private function setEquipments( )
		{
			$equipments = array(
				'amulet'     => array( 1, 15 ),
				'helmet'     => array( 38, 1 ),
				'backpack'   => array( 76, 15 ),
				'lefthand'   => array( 1, 52 ),
				'armor'      => array( 38, 38 ),
				'righthand'  => array( 75, 52 ),
				'ring'       => array( 1, 89 ),
				'legs'       => array( 38, 75 ),
				'ammunition' => array( 75, 89 ),
				'boots'      => array( 38, 112 )
			);

			foreach( $equipments as $eq => $positions )
			{
				$this->equipment['x'][$eq] = $this->equipment['pos']['x'] + $positions[0];
				$this->equipment['y'][$eq] = $this->equipment['pos']['y'] + $positions[1];
			}
		}


		/**
		 * @param string $path
		 * @access public
		 * @return instance
		**/
		public function setBackground( $path )
		{
			$this->background = $path;
			$this->extension  = strtolower( pathinfo( $path, PATHINFO_EXTENSION ) );

			switch( $this->extension )
			{
				case MADGD_PNG:
					$this->instance = imagecreatefrompng( $this->background );
					break;

				case MADGD_GIF:
					$this->instance = imagecreatefromgif( $this->background );
					break;

				case MADGD_JPG:
				case MADGD_JPEG:
					$this->instance = imagecreatefromjpeg( $this->background );
					break;
			}
			return $this->instance;
		}


		/**
		 * @param string $image
		 * @param integer $x
		 * @param integer $y
		 * @access public
		 * @return null
		**/
		public function setEquipmentBackground( $image, $x = false, $y = false )
		{
			if ( $x )
			{
				$this->equipment['pos']['x'] = $x;
			}
			if ( $y )
			{
				$this->equipment['pos']['y'] = $y;
			}

			$this->setEquipments( );
			return $this->addIcon( $image )->setPosition( $this->equipment['pos']['x'], $this->equipment['pos']['y'] );
		}


		/**
		 * @param string/int $regular
		 * @param string/int $bold
		 * @param int $size
		 * @param string $color
		 * @param boolean $shadow
		 * @access public
		 * @return null
		**/
		public function setDefaultStyle( $regular = 2, $bold = 3, $size = 9, $color = 'FFFFFF', $shadow = true )
		{
			$this->textConfig = array( 'font' => $regular, 'size' => $size, 'color' => $color, 'shadow' => $shadow );
			$this->textBold   = array( 'font' => $bold,    'size' => $size, 'color' => $color, 'shadow' => $shadow );
		}


		/**
		 * @param string $text
		 * @param array $style
		 * @access public
		 * @return instance
		**/
		public function addText( $text, $style = array( ) )
		{
			foreach( $this->textConfig as $key => $value )
			{
				if ( !array_key_exists( $key, $style ) )
				{
					$style[$key] = $value;
				}
			}
			return new MadGDText( $this, array( $text, $style ) );
		}


		/**
		 * @param string $icon
		 * @access public
		 * @return instance
		**/
		public function addIcon( $icon, $width = null, $height = null )
		{
			return new MadGDIcon( $this, $icon, $width, $height );
		}


		/**
		 * @param string $hex
		 * @param boolean/int $index
		 * @access public
		 * @return array $hex
		**/
		public function HexRGB( $hex, $index = false )
		{
			if ( !is_array( $hex ) )
			{
				$hex = preg_replace( '/#/', null, $hex );
				if ( strlen( $hex ) == 6 )
				{
					$hex = array(
						hexdec( substr( $hex, 0, 2 ) ),
						hexdec( substr( $hex, 2, 2 ) ),
						hexdec( substr( $hex, 4, 2 ) )
					);
				}
			}
			return ( in_array( $index, array( 0, 1, 2 ) ) ? $hex[$index] : $hex );
		}


		/**
		 * @param string $path
		 * @access public
		 * @return null
		**/
		public function display( $path = false )
		{
			if ( !$this->testMode )
			{
				if ( !$path )
				{
					header( 'Content-Type: image/png' );
					imagepng( $this->instance, '', 9 );
				}
				else
				{
					imagepng( $this->instance, $path, 9 );
				}
				imagedestroy( $this->instance );
				unset( $this->instance );
			}
		}
	}


	class MadGDText
	{
		private $parent = null;
		private $text   = null;
		private $style  = array( );

		/**
		 * @param instance $parent
		 * @param array $object
		 * @access public
		 * @return null
		**/
		public function __construct( $parent, $object )
		{
			$this->parent = $parent;
			$this->text   = $object[0];
			$this->style  = $object[1];
		}


		/**
		 * @param int $x
		 * @param int $y
		 * @access public
		 * @return null
		**/
		public function setPosition( $x = MADGD_STACK, $y = 5 )
		{
			$textSize = ( !is_int( $this->style['font'] ) ? imagettfbbox( $this->style['size'], 0, $this->style['font'], $this->text ) : null );

			$this->parent->x = ( $x === MADGD_STACK ? $this->parent->x + $this->parent->l + $y : $x );
			$this->parent->y = ( $x === MADGD_STACK ? $this->parent->y : $y );
			$this->parent->l = ( is_int( $this->style['font'] ) ? imagefontwidth( $this->style['font'] ) * strlen( $this->text ) : $textSize[2] );

			if ( is_int( $this->style['font'] ) )
			{
				if ( $this->style['shadow'] )
				{
					imagestring( $this->parent->instance, $this->style['font'], $this->parent->x + 1, $this->parent->y + 1, $this->text, imagecolorallocate( $this->parent->instance, 0, 0, 0 ) );
				}
				imagestring( $this->parent->instance, $this->style['font'], $this->parent->x, $this->parent->y, $this->text, imagecolorallocate( $this->parent->instance, $this->parent->HexRGB( $this->style['color'], 0 ), $this->parent->HexRGB( $this->style['color'], 1 ), $this->parent->HexRGB( $this->style['color'], 2 ) ) );
			}
			else
			{
				if ( $this->style['shadow'] )
				{
					imagettftext( $this->parent->instance, $this->style['size'], 0, $this->parent->x + 1, $this->parent->y + 11, imagecolorallocate( $this->parent->instance, 0, 0, 0 ), $this->style['font'], $this->text );
				}
				imagettftext( $this->parent->instance, $this->style['size'], 0, $this->parent->x, $this->parent->y + 10, imagecolorallocate( $this->parent->instance, $this->parent->HexRGB( $this->style['color'], 0 ), $this->parent->HexRGB( $this->style['color'], 1 ), $this->parent->HexRGB( $this->style['color'], 2 ) ), $this->style['font'], $this->text );
			}
		}
	}


	class MadGDIcon
	{
		public $extension = null;
		public $instance  = null;
		public $parent    = null;
		public $height    = null;
		public $width     = null;
		public $icon      = null;

		/**
		 * @param instance $parent
		 * @param string $icon
		 * @param int $width
		 * @param int $height
		 * @access public
		 * @return null
		**/
		public function __construct( $parent, $icon, $width, $height )
		{
			$this->parent    = $parent;
			$this->height    = $height;
			$this->width     = $width;
			$this->icon      = $icon;
			$this->extension = strtolower( pathinfo( $this->icon, PATHINFO_EXTENSION ) );
		}


		/**
		 * @param int $x
		 * @param int $y
		 * @access public
		 * @return null
		**/
		public function setPosition( $x = MADGD_STACK, $y = 5 )
		{
			$this->parent->x = ( $x === MADGD_STACK ? $this->parent->x + $this->parent->l + $y : $x );
			$this->parent->y = ( $x === MADGD_STACK ? $this->parent->y : $y );

			list( $imageWidth, $imageHeight ) = getimagesize( $this->icon );
			$this->parent->l = $imageWidth;

			switch( $this->extension )
			{
				case MADGD_PNG:
					$this->instance = imagecreatefrompng( $this->icon );
					break;

				case MADGD_GIF:
					$this->instance = imagecreatefromgif( $this->icon );
					break;

				case MADGD_JPG:
				case MADGD_JPEG:
					$this->instance = imagecreatefromjpeg( $this->icon );
					break;
			}
			return imagecopyresampled( $this->parent->instance, $this->instance, $this->parent->x, $this->parent->y, 0, 0, ( $this->width != null ? $this->width : $imageWidth ), ( $this->height != null ? $this->height : $imageHeight ), $imageWidth, $imageHeight );
		}
	}

	define( 'MADGD_PNG', 'png' );
	define( 'MADGD_JPG', 'jpg' );
	define( 'MADGD_JPEG', 'jpeg' );
	define( 'MADGD_GIF', 'gif' );
	define( 'MADGD_STACK', 'stack' );
	define( 'X_SLOT', 'X_SLOT_' );
	define( 'Y_SLOT', 'Y_SLOT_' );
