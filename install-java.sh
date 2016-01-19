#!/usr/bin/env bash

source ./privileges.sh

function download () 
{
    # For server download, try:
    # http://download.oracle.com/otn-pub/java/jdk/8u45-b14/server-jre-8u45-linux-x64.tar.gz
    NAME=jdk
    VERSION=8u45
    BUILD=b14
    DISTRIBUTION=linux-x64
    FILENAME=$NAME-$VERSION-$DISTRIBUTION.tar.gz
    URL=http://download.oracle.com/otn-pub/java/jdk/$VERSION-$BUILD/$FILENAME
    TMP_DIR=/tmp
    INSTALL_PREFIX=/opt

    if [ -f "$TMP_DIR/$FILENAME" ]; then
        echo "$TMP_DIR/$FILENAME already exists."
        echo "If there is a problem with this file, delete and re-run the script."
    else
        wget --no-check-certificate \
             --no-cookies \
             --header "Cookie: oraclelicense=accept-securebackup-cookie" \
             "$URL" \
             -r \
             -P "$TMP_DIR" \
             -O "$TMP_DIR/$FILENAME"
    fi

}

function is_valid_archive () 
{
    local response=0

    # Check that the file is a JDK archive.
    if [[ ! $1 =~ jdk-[0-9]{1}u[0-9]{1,2}.*\.tar\.gz ]]; then
        echo "'$1' doesn't look like a JDK archive."
        echo "The file name should begin 'jdk-XuYY',  where X is the version numbr nd YY is the updte number."
        echo "Please re-name the file, or download the JDK gain and keep the default file name."
        response=2
    fi

    return $response
}

function installed ()
{
    local response=0

    JDK_VER=`echo $1 | sed -r 's/jdk-([0-9]{1}u[0-9]{1,2}).*\.tar\.gz/\1/g'`
    export JDK_PATH=`echo $JDK_VER | sed -r 's/([0-9]{1})u([0-9]{1,2})/jdk1.\1.0_\2/g'`

    if [ -d "$JDK_PATH" ]; then
        response=1
    fi

    return $response
}

function extract_archive () 
{
    # Unpack the JDK and get the name of the unpacked folder.
    echo "Unpacking '$1'..."
    tar -xf $1 -C '/tmp'
}

function install_jdk () 
{
    # Create a location to save the JDK, and move it there.
    mkdir -p /usr/local/java
    # touch /usr/bin/java /usr/bin/javac /usr/bin/javaws /usr/bin/jar
    mv $JDK_PATH /usr/local/java
    JDK_NAME=${JDK_PATH##*/}
    JAVA_HOME=/usr/local/java/$JDK_NAME

    chmod a+x /usr/bin/java
    chmod a+x /usr/bin/javac
    chmod a+x /usr/bin/javaws
    chmod a+x /usr/bin/jar
    chown -R root:root $JAVA_HOME

    # Place links to java commnads in /usr/bin, and set preferred sources.
    update-alternatives --install "/usr/bin/java" "java" "$JAVA_HOME/bin/java" 1
    update-alternatives --set "java" "$JAVA_HOME/bin/java"

    update-alternatives --install "/usr/bin/javac" "javac" "$JAVA_HOME/bin/javac" 1
    update-alternatives --set "javac" "$JAVA_HOME/bin/javac"

    update-alternatives --install "/usr/bin/javaws" "javaws" "$JAVA_HOME/javaws" 1
    update-alternatives --set "javaws" "$JAVA_HOME/bin/javaws"

    update-alternatives --install "/usr/bin/jar" "jar" "$JAVA_HOME/bin/jar" 1
    update-alternatives --set "jar" "$JAVA_HOME/bin/jar"

    # Affirm completion, optionally delete archive, and exit
    echo "Java Development Kit version $JDK_VER successfully installed!"
    echo -n "Delete the archive file '$1'? [y/N] "
    confirm=""
    while [[ $confirm != "n" && $confirm != "N" && $confirm != "y" && $confirm != "Y" ]]; do
        read confirm
        if [[ $confirm = "y" || $confirm = "Y" ]]; then
            rm $1
        fi
    done
    exit 0 
}

function uninstall_jdk () 
{
    rm -rf /usr/local/java
    rm -f /usr/bin/java
    rm -f /usr/bin/javac
    rm -f /usr/bin/javaws
    rm -f /usr/bin/jar
}

if has_root_permissions; then

    while getopts ":i:" opt; do
        case $opt in
            i)
                echo "-i was triggered. Parameter: $OPTARG" >&2
                ;;
            \?)
                echo "Invalid option" -$OPTARG" >&2
                exit 1
                ;;
            :)
                echo "Option -$OPTARG requires an argument." >&2
                exit 1
                ;;
        esac
    done    

    if [ $1 ]; then
      if $1 = "-i jdk"; then
      
      fi
    fi

    download

    if is_valid_archive $TMP_DIR/$FILENAME; then
      #if installed; then
      #  echo 'This version of Java appears to be installed already.'
      #else
        extract_archive $TMP_DIR/$FILENAME
        install_jdk $TMP_DIR/$FILENAME
      #fi
    fi

    exit 0
else
    exit 1
fi
