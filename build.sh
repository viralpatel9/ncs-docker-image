#!/bin/bash

function Clean {

    echo
    echo "Cheaning the folder prior to building................................"

    rm -frd /builder
    mkdir /builder

    cd /data
}

function Prepare {

	# Create some functions and execute them to display SCM commit details

        echo
	echo "Preparation -----------------------------------------------------"

        # Change to the folder containing the source files
	
	cd /data

    echo
    echo "Build details:"	
	SCM_SHA_SHORT() { git rev-parse --short HEAD ; }      && echo "SHA Short: "    '"'$(SCM_SHA_SHORT)'"'
	SCM_SHA_LONG()  { git rev-parse HEAD ; }              && echo "SHA Long:  "    '"'$(SCM_SHA_LONG)'"'
	SCM_BRANCH()    { git rev-parse --abbrev-ref HEAD ; } && echo "Branch:    "    '"'$(SCM_BRANCH)'"'
	SCM_DESCRIBE()  { git describe ; }                    && echo "Version:   "    '"'$(SCM_DESCRIBE)'"'
	echo

        # Create an environmental variable holding the SCM version  
	
	export FIRMWARE_VERSION=$(SCM_DESCRIBE)
	
	# Create the commit.h file which contains the SCM details (SHA Short, SHA Complete, Branch, Git description as version 
	
        echo "Creating commit.h file containing the SHA, branch and version"

	echo "#ifndef COMMIT_H" >  test-example/commit.h
	echo "#define COMMIT_H" >> test-example/commit.h

	echo "#define SCM_SHA_SHORT "    '"'$(SCM_SHA_SHORT)'"' >> test-example/commit.h
	echo "#define SCM_SHA_LONG  "    '"'$(SCM_SHA_LONG)'"'  >> test-example/commit.h
	echo "#define SCM_BRANCH    "    '"'$(SCM_BRANCH)'"'    >> test-example/commit.h
	echo "#define SCM_DESCRIBE  "    '"'$(SCM_DESCRIBE)'"'  >> test-example/commit.h

	echo "#endif" >> test-example/commit.h

	# Create a text file holding the firmware version
	
	echo $FIRMWARE_VERSION   > /builder/version.txt
	echo
	echo "Version is: " 
	echo $FIRMWARE_VERSION

        echo
	echo "Preparation complete. Error code is" $?
}

function Build {
	echo "------------------------------------------------"
	echo "Building the Test-example ----------------------"
	echo "------------------------------------------------"
	mkdir output
	docker create --name test viralpatel9/ncs-docker:master
	docker cp test-example/. test:
	docker rm test
	docker run --name test viralpatel9/ncs-docker:master west build --build-dir /output . -p always -b nrf52840dk_nrf52840 --no-sysbuild -- -DCONF_FILE=prj.conf
}
echo Starting build script
Clean
Prepare
Build