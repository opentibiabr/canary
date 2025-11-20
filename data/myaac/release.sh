#!/bin/bash
#
# myaac release script
#
# places compressed archives into releases/ directory
#

if [ $# -eq 0 ]; then
	echo "No arguments supplied"
	echo "Usage: release.sh prepare/pack"
	exit 1
fi

if [ $1 = "prepare" ]; then
	# define release version
	version=`php system/get_version_for_release.php`

	echo "Preparing to release version $version of the MyAAC Project!"

	# make required directories
	mkdir -p releases
	mkdir -p tmp

	# get myaac from git archive
	git archive --format zip --output tmp/myaac.zip master

	cd tmp/ || exit

	dir="myaac-$version"
	if [ -d "$dir" ] ; then
		echo "Fatal error: Version $version already exists!!"
		exit
	fi

	unzip -q myaac.zip -d $dir
	rm myaac.zip

	echo "Now you can make changes to $dir. When you are ready, type 'release.sh pack'"
	exit
fi

if [ $1 = "pack" ]; then
	# define release version
	version=`php system/get_version_for_release.php`

	cd tmp || exit

	# tar.gz
	echo "Creating .tar.gz package.."
	file="myaac-$version.tar.gz"
	tar -czf $file *
	mv $file ../releases/

	# zip
	echo "Creating .zip package.."
	file="myaac-$version.zip"
	zip -rq $file *
	mv $file ../releases/

	cd ..
	rm -R tmp
	echo "Done. Released files can be found in 'releases' directory."

	exit
fi
