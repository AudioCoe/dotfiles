#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && source "utils.sh"

declare -r -a NODE_VERSIONS=(
    "node"
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    declare -r NVM_DIRECTORY="$HOME/.nvm"
    declare -r NVM_GIT_REPO_URL="https://github.com/creationix/nvm.git"

    declare -r CONFIGS="
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Node Version Manager

export NVM_DIR=\"$NVM_DIRECTORY\"

[ -f \"\$NVM_DIR/nvm.sh\" ] \\
    && source \"\$NVM_DIR/nvm.sh\"

[ -f \"\$NVM_DIR/bash_completion\" ] \\
    && source \"\$NVM_DIR/bash_completion\"
"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `Git` is installed

    if ! cmd_exists "git"; then
        print_error "Git is required, please install it!\n"
        exit 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install `nvm` and add the necessary configs to `~/.bash.local`

    if [ ! -d "$NVM_DIRECTORY" ]; then

        execute \
            "git clone --quiet $NVM_GIT_REPO_URL $NVM_DIRECTORY" \
            "nvm"

        if [ $? -eq 0 ]; then
            execute \
                "printf '%s' '$CONFIGS' >> $HOME/.bash.local \
                    && source $HOME/.bash.local" \
                "nvm (update ~/.bash.local)"
        fi

    fi

    if [ -d "$NVM_DIRECTORY" ]; then

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Ensure the latest version of `nvm` is used

        execute \
            "cd $NVM_DIRECTORY \
                && git fetch --quiet origin \
                && git checkout --quiet \$(git describe --abbrev=0 --tags) \
                && source $NVM_DIRECTORY/nvm.sh" \
            "nvm (upgrade)"

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Install the specified `node` versions

        for i in "${NODE_VERSIONS[@]}"; do
            execute \
                "nvm install $i" \
                "nvm (install: $i)"
        done

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # By default, use the latest stable version of `node`

        execute \
            "nvm alias default node" \
            "nvm (set default)"

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    fi

}

main
