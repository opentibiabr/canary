# MyAAC

MyAAC is a free and open-source Automatic Account Creator (AAC) written in PHP. It supports only MySQL databases.

### Requirements

	- PHP 7.4 or later
	- MySQL database
    - Composer
	- PDO PHP Extension
	- XML PHP Extension
	- ZIP PHP Extension
	- (optional) mod_rewrite to use friendly_urls

### Installation

	Just decompress and untar the source (which you should have done by now,
	if you're reading this), into your webserver's document root.

	MyAAC needs proper permissions to handle files correctly.
	If you're using apache2, then your directory needs to have owner set to: www-data, you can do it by using following command:
		chown -R www-data.www-data /var/www/*
			(or any other path your MyAAC installation is located at..)

	  Note: Linux only
		If you're under linux use these commands to set proper permissions:
            sudo chmod 755 -R . && sudo chmod 777 -R outfits/ system/ images/ plugins/ tools/

	Visit http://your_domain/install (http://127.0.0.1/install) and follow instructions in the browser.

### Configuration

Check **config.php** to get more informations.
Use **config.local.php** for your local configuration changes.

### Informations

Changed box shadow image to css

Changed buttons, removed image and added by css

Created new buttons based on colors (green and red)

Added page load, configurable in config.php

Added status bar with configurable social networks

Added slide and collapse status bar, configurable in config.php

Added swipe effect in menu

Created client download page, configurable link in config.php

Created event calendar, getting information directly from events.xml

Char Bazaar with configurable rates in config.php

Changed login by email

## Project supported by JetBrains

We extend our heartfelt gratitude to Jetbrains for generously granting us licenses to collaborate on this and various other open-source initiatives.

[![JetBrains](https://resources.jetbrains.com/storage/products/company/brand/logos/jb_beam.svg)](https://jb.gg/OpenSourceSupport/?from=https://github.com/opentibiabr/myaac)

### License

This program and all associated files are released under the GNU Public License.  
See [LICENSE](https://github.com/opentibiabr/myaac/blob/main/LICENSE) for details.

### Credits

Slawkens [MyAAC](https://github.com/otsoft/myaac)
