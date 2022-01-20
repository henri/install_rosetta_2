#!/usr/bin/env bash

# (C) 2022 Henri Shustak
# Licenced under the Apache Licence
# http://www.apache.org/licenses/LICENSE-2.0
# Latest copy of this script is available from :

# User varibales
package_identifier="com.yourdomain.install_rosetta_2"
package_version="1.0"
package_output_name="install_rosetta_2.pkg"

# Intenral variables
exit_status=0
parent_directory="`dirname \"${0}\"`" ; if [ "`echo "${parent_directory}" | grep -e "^/"`" == "" ] ; then parent_directory="`pwd`/${parent_directory}" ; fi
temporary_build_directory=`mktemp -d /tmp/bluetoothoff_build_directory.XXXXXXXXXXXXX`
realitve_package_output_directory="build_output/`date \"+%Y-%m-%d_%H.%M.%S\"`"
absolute_path_to_package_build_directory="${parent_directory}/${realitve_package_output_directory}"
absolute_path_to_package_build="${absolute_path_to_package_build_directory}/${package_output_name}"
realitve_script_diectory_name="scripts"


function clean_exit {
	cd /
	rm -Rf "${temporary_build_directory}"
	exit ${exit_status}
}

# change directory to the temporary build directory
cd "${temporary_build_directory}"
if [ $? != 0 ] ; then echo "ERROR! : Unable to swtich to temporary build directory." ; exit_status=1 ; clean_exit ; fi

# populate temporary build directory with approriate files
rsync -aE "${parent_directory}/root" "${parent_directory}/scripts" "./"
if [ $? != 0 ] ; then echo "ERROR! : Unable to copy files to temporary build directory." ; exit_status=1 ; clean_exit ; fi

# generate build output directory
mkdir "${absolute_path_to_package_build_directory}"
if [ $? != 0 ] ; then echo "ERROR! : Unable to generate output build directory." ; exit_status=1 ; clean_exit ; fi

# build that package
pkgbuild --identifier ${package_identifier} --version ${package_version} --root ./root --scripts ./scripts --install-location / "${absolute_path_to_package_build}"

clean_exit
