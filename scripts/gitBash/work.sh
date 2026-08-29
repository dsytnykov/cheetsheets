#!/bin/bash

# Start development environment
devstart() {
    if [ -z "$1" ]; then
        echo "Usage: devstart <project-name>"
        ls ~/Projects
        return 1
    fi
    cd /c/your-applications/$1 && code . && git status
}

# Start Intellij with a project
# for new version of intellij change %Path% in envs accordingly
idea() {
    local RESET='\033[0m'
    local SECTION='\033[1;33m'
    local CMD='\033[1;97m'
    local PATH_C='\033[0;90m'

    local -a project_data=(
        "GROUP|service1|/c/your-applications/service1"
        "GROUP|service2|/c/your-applications/service2"
        "GROUP > SUBGROUP|service3|/c/your-applications/subgroup/service3"
    )

    # Build lookup map from project_data
    declare -A projects
    local entry cat name path
    for entry in "${project_data[@]}"; do
        name="${entry#*|}";  name="${name%%|*}"
        path="${entry##*|}"
        projects["$name"]="$path"
    done

    if [ -z "$1" ]; then
        local current_cat=""
        echo ""
        echo -e "  Usage: ${CMD}idea <service-name | path | .>${RESET}"
        echo ""
        for entry in "${project_data[@]}"; do
            cat="${entry%%|*}"
            name="${entry#*|}";  name="${name%%|*}"
            path="${entry##*|}"
            if [[ "$cat" != "$current_cat" ]]; then
                [[ -n "$current_cat" ]] && echo ""
                echo -e "  ${SECTION}${cat}${RESET}"
                current_cat="$cat"
            fi
            printf "    ${CMD}%-16s${RESET}  ${PATH_C}%s${RESET}\n" "$name" "$path"
        done
        echo ""
        return 1
    fi

    local target="$1"
    if [[ -n "${projects[$1]}" ]]; then
        target="${projects[$1]}"
    fi

    # path in env variables set to IDE
    idea64.exe "$target" >/dev/null 2>&1 & disown
}


eclipse