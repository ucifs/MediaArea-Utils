# MOVMetaEdit/Release/UpgradeVersion.sh
# Upgrade the version number of MOVMetaEdit

# Copyright (c) MediaArea.net SARL. All Rights Reserved.
# Use of this source code is governed by a BSD-style license that
# can be found in the License.txt file in the root of the source
# tree.

function btask.UpgradeVersion.run () {

    local Source Files index

    if [ $(b.opt.get_opt --source-path) ]; then
        Source="$SDir"
    else
        getRepo $Repo "$WDir"
        Source="$WDir/$Project"
        # For lisibility after git
        echo
    fi

    if [ $(b.opt.get_opt --git-state) ]; then
        pushd "$Source"
        git checkout $(sanitize_arg $(b.opt.get_opt --git-state))
        popd
    fi

    # Populate Version_old_* variables
    getOld "$Source/Project/version.txt"

    echo "Update version.txt"
    echo "${Version_new}" > "$Source/Project/version.txt"

    echo
    echo "Passage for version with dots..."
    index=0
    Files[((index++))]="Project/GNU/movmetaedit.spec"
    Files[((index++))]="Project/GNU/movmetaedit.dsc"
    Files[((index++))]="Project/GNU/PKGBUILD"
    Files[((index++))]="Project/Mac/Info.plist"
    Files[((index++))]="Project/OBS/deb7.dsc"
    Files[((index++))]="Project/OBS/deb7.debian/changelog"
    Files[((index++))]="debian/changelog"
    Files[((index++))]="Source/Common/config.h"
    Files[((index++))]="Source/Install/MOV_MetaEdit_GUI_Windows_i386.nsi"
    Files[((index++))]="Source/Install/MOV_MetaEdit_GUI_Windows_x64.nsi"

    # Make the replacements
    for File in ${Files[@]}
    do
        echo "${Source}/${File}"
        updateFile "$Version_old_escaped" $Version_new "${Source}/${File}"
    done

    echo
    echo "Passage for version AA,BB,CC,DD ..."
    unset -v Files
    index=0
    Files[((index++))]="Project/Qt/movmetaedit-gui.rc"

    for File in ${Files[@]}
    do
        echo "${Source}/${File}"
        updateFile $Version_old_major,$Version_old_minor,$Version_old_patch,$Version_old_build $Version_new_major,$Version_new_minor,$Version_new_patch,$Version_new_build "${Source}/${File}"
    done
}
