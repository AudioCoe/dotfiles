#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && source "../../utils.sh" \
    && source "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    if ! xcode-select --print-path &> /dev/null; then

        # Prompt user to install the XCode Command Line Tools
        xcode-select --install &> /dev/null

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Wait until the XCode Command Line Tools are installed

        until xcode-select --print-path &> /dev/null; do
            sleep 5
        done

        print_result $? "Install XCode Command Line Tools"

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Point the `xcode-select` developer directory to
        # the appropriate directory from within `Xcode.app`
        # https://github.com/alrra/dotfiles/issues/13

        execute \
            "sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer" \
            "Make 'xcode-select' developer directory point to Xcode"

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Automatically agree to the terms of the Xcode license
        # https://github.com/alrra/dotfiles/issues/10

        execute \
            "sudo xcodebuild -license accept" \
            "Agree to the terms of the XCode Command Line Tools licence"

    fi

    print_result $? "XCode Command Line Tools"

}

main
