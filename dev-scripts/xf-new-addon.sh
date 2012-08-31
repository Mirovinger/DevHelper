#!/bin/bash

if [ $# -ge 2 ]; then

    ADDON_ID="$1"
    PATH_TO_XENFORO="$2"
    ADDON_EXISTS=0
    ADDON_EXISTS_IN_XENFORO=0

    # get the addon directory by replace all "_" with "/"
    # we will get a sub directory structure with this kind of subsitution
    # the DevHelper add-on uses a similar structure...
    ADDON_DIR=${ADDON_ID//_/\/}

    if [ -d "${ADDON_DIR}" ]; then
        ADDON_EXISTS=1
    fi

    if [ -d "${PATH_TO_XENFORO}" ]; then
        if [ -d "${PATH_TO_XENFORO}/library/" ]; then
            if [ -d "${PATH_TO_XENFORO}/library/${ADDON_ID}" ]; then
                ADDON_EXISTS_IN_XENFORO=1
            fi
        else
            echo "${PATH_TO_XENFORO}/library/" does not exists! Quit now...
            exit 1
        fi
    else
        echo "${PATH_TO_XENFORO}" does not exists! Quit now...
        exit 1
    fi

    if [ $ADDON_EXISTS -eq 0 ]; then
        echo Creating add-on directory, enter UNIX user password if asked...
        sudo mkdir -p -m 0777 "${ADDON_DIR}"
        sudo mkdir -p -m 0777 "${ADDON_DIR}/repo/library/${ADDON_DIR}"
        sudo mkdir -p -m 0777 "${ADDON_DIR}/repo/js/${ADDON_DIR}"
        sudo chown -R $USER "${ADDON_DIR}"
    fi
    
    if [ $ADDON_EXISTS_IN_XENFORO -eq 0 ]; then
        echo Creating add-on symbolic links in XenForo directory, enter UNIX user password if asked...
        sudo ln -s "${PWD}/${ADDON_DIR}/repo/library/${ADDON_DIR}" "${PATH_TO_XENFORO}/library/${ADDON_DIR}"
        sudo ln -s "${PWD}/${ADDON_DIR}/repo/js/${ADDON_DIR}" "${PATH_TO_XENFORO}/js/${ADDON_DIR}"
        sudo chown -h $USER "${PATH_TO_XENFORO}/library/${ADDON_DIR}"
        sudo chown -h $USER "${PATH_TO_XENFORO}/js/${ADDON_DIR}"
        sudo echo "${ADDON_DIR}/*" >> "${PATH_TO_XENFORO}/library/.gitignore"
        sudo echo "${ADDON_DIR}/*" >> "${PATH_TO_XENFORO}/js/.gitignore"
    fi

    if [ ! -d "${ADDON_DIR}/repo/.git" ]; then
        echo Initializing git repo...
        cd "${ADDON_DIR}/repo/"
        git init
        echo '.DS_Store' >> .gitignore
        # ignore the files generated by DevHelper
        echo '*.devhelper' >> .gitignore
        echo "library/${ADDON_DIR}/DevHelper/Generated/*" >> .gitignore
        git add .
        git commit -m 'Initialized by xf-new-addon script'
    fi

    echo Done!
else
    echo USAGE: $0 [addOnId] [path/to/xenforo/root]
fi
