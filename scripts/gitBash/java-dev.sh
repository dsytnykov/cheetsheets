#!/bin/bash
# ~/.bash/java-dev.sh
# Custom bash functions for developing

# ========================================
# PROJECT MANAGEMENT
# ========================================

# Navigation
alias projects='cd /c/your-applications'
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'
alias -- -='cd -' # go back to previous folder

# List files
alias ll='ls -la'
alias la='ls -A'
alias lt='ls -ltr'          # list by time, newest last

# Safety net (ask before overwriting)
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Other
alias c='clear'
alias h='history'

alias reload='source ~/.bashrc'

function cl() {
    cd "$1" && ls -la
}

# ========================================
# GIT COMMANDS
# ========================================

# Git shortcuts
alias gst='git status'
alias ga='git add'
alias gc='git commit -m'
alias gpu='git push'
alias gco='git checkout'
alias gcom='git checkout master'
alias gb='git branch'
alias gpull='git pull'
alias glog='git log --oneline --graph --decorate'

# Remove unused branches by pattern (default all local feature branches)
grlb() {
    local pattern="${1:-feature/}"
    git branch -D $(git branch | grep "$pattern")
}

# Create feature branch
gfeature() {
    if [ -z "$1" ]; then
        echo "Usage: gfeature <feature-name>"
        return 1
    fi

    git checkout -b "feature/$1"
    echo "Created and switched to branch: feature/$1"
}

# Create bugfix branch
gfix() {
    if [ -z "$1" ]; then
        echo "Usage: gfix <bug-name>"
        return 1
    fi

    git checkout -b "fix/$1"
    echo "Created and switched to branch: fix/$1"
}

# Create patch file from changes
# Usage:
#   gpatch                                  → patch from all changes, named after current branch, saved to Z:\patches
#   gpatch myfix                            → named "myfix.patch"
#   gpatch myfix -i "src/main/file1 file2"  → patch only file1 and file2
#   gpatch myfix -i "src/main/"             → patch everything in main folder
#   gpatch myfix -i "src/main/*.java"       → patch every java file in main folder
#   gpatch myfix -e "file1 file2"           → patch all except file1 and file2
#   gpatch myfix -i "file1" -e "file2"      → include file1, exclude file2
#   gpatch myfix -p /tmp                    → save to /tmp/myfix.patch
#   gpatch -i "file1" -p /tmp               → include only, named after branch, saved to /tmp
gpatch() {
    local name=""
    local includes=""
    local excludes=""
    local outdir="/z/patches"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -i) includes="$2"; shift 2 ;;
            -e) excludes="$2"; shift 2 ;;
            -p) outdir="$2"; shift 2 ;;
            *) name="$1"; shift ;;
        esac
    done

    # Default name: current branch (slashes replaced with dashes)
    if [ -z "$name" ]; then
        name=$(git rev-parse --abbrev-ref HEAD | tr '/' '-')
    fi

    # Ensure output directory exists
    if [ ! -d "$outdir" ]; then
        mkdir -p "$outdir"
        if [ $? -ne 0 ]; then
            echo "Error: could not create directory $outdir"
            return 1
        fi
    fi

    local patch_file="${outdir}/${name}.patch"

    # Generate the patch
    if [ -n "$includes" ] && [ -n "$excludes" ]; then
        git diff -- $includes $(for ef in $excludes; do echo ":(exclude)$ef"; done) > "$patch_file"
    elif [ -n "$includes" ]; then
        git diff -- $includes > "$patch_file"
    elif [ -n "$excludes" ]; then
        git diff -- . $(for ef in $excludes; do echo ":(exclude)$ef"; done) > "$patch_file"
    else
        git diff > "$patch_file"
    fi

    if [ $? -eq 0 ] && [ -s "$patch_file" ]; then
        echo "Created patch: $patch_file ($(wc -l < "$patch_file") lines)"
    elif [ ! -s "$patch_file" ]; then
        rm -f "$patch_file"
        echo "No changes found — patch file not created."
        return 1
    else
        echo "Error creating patch."
        return 1
    fi
}

# Revert (discard) unstaged changes
# Usage:
#   grevert                                        → revert ALL unstaged changes
#   grevert -i "file1 file2"                       → revert only specific files
#   grevert -e "file1 file2"                       → revert everything except these files
#   grevert -i "src/main/" -e "src/main/resources/" → revert src/main/ but keep resources
grevert() {
    local includes=""
    local excludes=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -i) includes="$2"; shift 2 ;;
            -e) excludes="$2"; shift 2 ;;
            *) echo "Unknown parameter: $1"; echo "Usage: grevert [-i \"files...\"] [-e \"files...\"]"; return 1 ;;
        esac
    done

    # Confirmation
    if [ -z "$includes" ] && [ -z "$excludes" ]; then
        echo "This will discard ALL unstaged changes. Are you sure? (y/n)"
        read -r confirm
        if [[ "$confirm" != "y" ]]; then
            echo "Aborted."
            return 0
        fi
    fi

    # Perform the revert
    if [ -n "$includes" ] && [ -n "$excludes" ]; then
        git checkout -- $includes $(for ef in $excludes; do echo ":(exclude)$ef"; done)
    elif [ -n "$includes" ]; then
        git checkout -- $includes
    elif [ -n "$excludes" ]; then
        git checkout -- . $(for ef in $excludes; do echo ":(exclude)$ef"; done)
    else
        git checkout -- .
    fi

    if [ $? -eq 0 ]; then
        echo "Changes reverted successfully."
    else
        echo "Error reverting changes."
        return 1
    fi
}

# Apply a patch file
# Usage:
#   gapply mypatch                → applies Z:\patches\mypatch.patch
#   gapply mypatch -p /tmp        → applies /tmp/mypatch.patch
#   gapply mypatch.patch          → works with or without .patch extension
gapply() {
    local name=""
    local patchdir="/z/patches"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -p) patchdir="$2"; shift 2 ;;
            *) name="$1"; shift ;;
        esac
    done

    # Name is mandatory
    if [ -z "$name" ]; then
        echo "Usage: gapply <patch-name> [-p <path>]"
        echo "  Default path: Z:\\patches"
        return 1
    fi

    # Append .patch extension if not already present
    if [[ "$name" != *.patch ]]; then
        name="${name}.patch"
    fi

    local patch_file="${patchdir}/${name}"

    # Check file exists
    if [ ! -f "$patch_file" ]; then
        echo "Patch file not found: $patch_file"
        return 1
    fi

    # Dry run first
    git apply --check "$patch_file" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "Patch cannot be applied cleanly. Conflicts detected."
        echo "Run with --3way? (y/n)"
        read -r confirm
        if [[ "$confirm" == "y" ]]; then
            git apply --3way "$patch_file"
        else
            echo "Aborted."
            return 1
        fi
    else
        git apply "$patch_file"
        if [ $? -eq 0 ]; then
            echo "Patch applied: $patch_file"
        else
            echo "Error applying patch."
            return 1
        fi
    fi
}

# ========================================
# GRADLE COMMANDS
# ========================================

# Gradle shortcuts
alias g='gradle'

# Gradle build without tests
gbuild() {
    gradle build -x test
}

# Gradle build with tests
gbuildt() {
    gradle build
}

# Gradle clean build
gclean() {
    gradle clean build
}

# Gradle run specific test
gtest() {
    if [ -z "$1" ]; then
        echo "Usage: gtest <TestClassName>"
        return 1
    fi
    gradle test --tests "$1"
}

# Run SonarQube analysis (Gradle)
gsonar() {
    gradle sonar
}

# ========================================
# JAVA PROCESS MANAGEMENT
# ========================================

# Find Java processes
jps-custom() {
    echo "Java Processes:"
    jps -l
}

# Kill Java process by name
jkill() {
    if [ -z "$1" ]; then
        echo "Usage: jkill <process-name-pattern>"
        echo "Current Java processes:"
        jps -l
        return 1
    fi

    pid=$(jps -l | grep "$1" | awk '{print $1}')
    if [ -z "$pid" ]; then
        echo "No process found matching: $1"
    else
        echo "Killing process $pid"
        /c/Windows/System32/taskkill.exe /PID "$pid" /F
    fi
}

# Check which port is using Java application
jport() {
    if [ -z "$1" ]; then
        echo "Usage: jport <port-number>"
        echo "Example: jport 8080"
        return 1
    fi

    netstat -ano | grep ":$1"
}

# Generate heap dump for Java process
jheap-dump() {
    if [ -z "$1" ]; then
        echo "Usage: jheap-dump <pid>"
        echo "Current Java processes:"
        jps -l
        return 1
    fi

    timestamp=$(date +%Y%m%d_%H%M%S)
    jmap -dump:format=b,file=heapdump_${timestamp}.hprof "$1"
    echo "Heap dump created: heapdump_${timestamp}.hprof"
}

# Show Java process memory usage
jmem() {
    if [ -z "$1" ]; then
        echo "Usage: jmem <pid>"
        echo "Current Java processes:"
        jps -l
        return 1
    fi

    jstat -gc "$1" 1000 5
}

# Show current Java environment
jenv-show() {
    echo "JAVA_HOME: $JAVA_HOME"
    echo "Java Version:"
    java -version
    echo ""
    echo "Maven Version:"
    mvn -version
    echo ""
    echo "Gradle Version:"
    gradle -version 2>/dev/null || echo "No Gradle wrapper found"
}

# ========================================
# Search in TERMINAL
# ========================================
# Search in Java files in your-applications
jgrep() {
    grep -rn "$1" /c/your-applications --include="*.java" --exclude-dir={build,target,.git,node_modules}
}

# Search only Files variant
jgrepf() {
    grep -rl "$1" /c/your-applications --include="*.java" --exclude-dir={build,target,.git,node_modules}
}

# Usage: search "term" [path] [extension]
search() {
    local term="$1"
    local path="${2:-/c/your-applications}"
    local ext="${3:-java}"
    grep -rn "$term" "$path" --include="*.$ext" --exclude-dir={build,target,.git,node_modules}
}

# Find files by name pattern
# ffind "changelog*" -  find files starting with "changelog"
# ffind "*.properties" /c/your-applications/external  - custom path
ffind() {
    local pattern="$1"
    local path="${2:-/c/your-applications}"
    find "$path" -name "$pattern" -not -path "*/build/*" -not -path "*/.git/*" -not -path "*/target/*"
}

# Find files by name, then search inside them
# fgrep "*.conf" "timeout" - list conf files containing "timeout"
# fgrep "*.xml" "liquibase" - list XML files containing "liquibase"
fgrep() {
    local filename="$1"
    local term="$2"
    local path="${3:-/c/your-applications}"
    find "$path" -name "$filename" -not -path "*/build/*" -not -path "*/.git/*" -not -path "*/target/*" -exec grep -ln "$term" {} \;
}

# Same but show matching lines with line numbers
# fgrepn "*.properties" "datasource" - show matching lines in .properties files
# fgrepn "*.yaml" "port" /c/your-applications/external - custom path
fgrepn() {
    local filename="$1"
    local term="$2"
    local path="${3:-/c/your-applications}"
    find "$path" -name "$filename" -not -path "*/build/*" -not -path "*/.git/*" -not -path "*/target/*" | xargs grep -n "$term"
}

# Show help for all Java commands
jhelp() {
    local RESET='\033[0m'
    local TITLE='\033[1;96m'    # bold bright cyan
    local SECTION='\033[1;33m'  # bold yellow
    local CMD='\033[1m'         # bold white
    local HINT='\033[0;90m'     # dark gray

    _jhelp_project() {
        echo -e "${SECTION}  PROJECT MANAGEMENT${RESET}"
        echo -e "${SECTION}  ────────────────────────────────────────────${RESET}"
        echo -e "  ${CMD}idea <project | path | .>${RESET} - start intellij with a project"
        echo -e "  ${CMD}eclipse${RESET}                    - start eclipse with my default workspace"
    }

    _jhelp_git() {
        echo -e "${SECTION}  GIT${RESET}"
        echo -e "${SECTION}  ────────────────────────────────────────────${RESET}"
        echo -e "  ${CMD}gfeature <no_ticket>${RESET} - Create a new feature/no_ticket branch"
        echo -e "  ${CMD}gfix <ticket_no>${RESET}     - Create a new fix/... branch"
        echo -e "  ${CMD}grlb [<pattern>]${RESET}     - Remove local branches by pattern (or all feature branches by default)"
        echo -e "  ${CMD}gpatch [file_name] [-e file1 file2]${RESET} - patch all except file1 and file2 to default folder"
        echo -e "  ${CMD}grevert [-i file3] [-e file1 file2]${RESET} - revert changes (without parameters revert all)"
        echo -e "  ${CMD}gapply <file_name> [-p /tmp]${RESET} - apply patch by filename (path is optional)"
        echo -e "  ${CMD}gst${RESET}                  - git status"
        echo -e "  ${CMD}ga${RESET}                   - git add"
        echo -e "  ${CMD}gc${RESET}                   - git commit -m"
        echo -e "  ${CMD}gco${RESET}                  - git checkout"
        echo -e "  ${CMD}gcom${RESET}                 - git checkout master"
        echo -e "  ${CMD}gb${RESET}                   - git branch"
        echo -e "  ${CMD}gpu${RESET}                  - git push"
        echo -e "  ${CMD}gpull${RESET}                - git pull"
        echo -e "  ${CMD}glog${RESET}                 - git log --oneline --graph --decorate"
    }

    _jhelp_gradle() {
        echo -e "${SECTION}  GRADLE${RESET}"
        echo -e "${SECTION}  ────────────────────────────────────────────${RESET}"
        echo -e "  ${CMD}g${RESET}                    - alias for gradle"
        echo -e "  ${CMD}gbuild${RESET}               - Build without tests"
        echo -e "  ${CMD}gbuildt${RESET}              - Build with tests"
        echo -e "  ${CMD}gclean${RESET}               - Build with clean"
        echo -e "  ${CMD}gtest <class>${RESET}        - Run specific test"
    }

    _jhelp_process() {
        echo -e "${SECTION}  PROCESS MANAGEMENT${RESET}"
        echo -e "${SECTION}  ────────────────────────────────────────────${RESET}"
        echo -e "  ${CMD}jps-custom${RESET}           - List Java processes"
        echo -e "  ${CMD}jkill <pattern>${RESET}      - Kill Java process"
        echo -e "  ${CMD}jport <port>${RESET}         - Check which port is using Java application"
        echo ""
        echo -e "${SECTION}  UTILITIES${RESET}"
        echo -e "${SECTION}  ────────────────────────────────────────────${RESET}"
        echo -e "  ${CMD}jheap-dump <pid>${RESET}     - Generate heap dump for Java process"
        echo -e "  ${CMD}jmem <pid>${RESET}           - Show Java process memory usage"
        echo -e "  ${CMD}jenv-show${RESET}            - Show current Java environment"
    }

    _jhelp_terminal() {
        echo -e "${SECTION}  TERMINAL MANAGEMENT${RESET}"
        echo -e "${SECTION}  ────────────────────────────────────────────${RESET}"
        echo -e "  ${CMD}projects${RESET}             - go to /c/your-applications"
        echo -e "  ${CMD}..${RESET}                   - go to the parent folder"
        echo -e "  ${CMD}...${RESET}                  - go to the parent of parent folder"
        echo -e "  ${CMD}~${RESET}                    - go to the root (/Users)"
        echo -e "  ${CMD}-- -${RESET}                 - go to the previous folder"
        echo -e "  ${CMD}lt${RESET}                   - list by time, newest last"
        echo -e "  ${CMD}c${RESET}                    - clear terminal"
        echo -e "  ${CMD}h${RESET}                    - show history"
        echo -e "  ${CMD}reload${RESET}               - run source ~/.bashrc"
        echo -e "  ${CMD}cl <path>${RESET}            - go to the folder and show list all files"
        echo ""
        echo -e "${SECTION}  TERMINAL SHORTCUTS${RESET}"
        echo -e "${SECTION}  ────────────────────────────────────────────${RESET}"
        echo -e "  ${CMD}Ctrl + A${RESET}             - Jump to beginning of line"
        echo -e "  ${CMD}Ctrl + E${RESET}             - Jump to end of line"
        echo -e "  ${CMD}Ctrl + W${RESET}             - Delete one word backward"
        echo -e "  ${CMD}Ctrl + U${RESET}             - Clear everything before cursor"
        echo -e "  ${CMD}Ctrl + K${RESET}             - Clear everything after cursor"
        echo -e "  ${CMD}Ctrl + L${RESET}             - Clear the screen (same as 'clear')"
        echo -e "  ${CMD}Ctrl + C${RESET}             - Cancel current command"
        echo -e "  ${CMD}Ctrl + Z${RESET}             - Suspend current process (bring back with 'fg')"
        echo -e "  ${CMD}Alt + F${RESET}              - Jump forward one word"
        echo -e "  ${CMD}Alt + B${RESET}              - Jump backward one word"
        echo -e "  ${CMD}!!${RESET}                   - Last used command"
        echo -e "  ${CMD}!\$${RESET}                   - Last argument of the previous command"
        echo -e "  ${CMD}^old^new${RESET}             - Replace old to new in last command"
        echo -e "  ${CMD}Ctrl + R${RESET}             - Reverse search through terminal history"
        echo -e "    - ${CMD}Ctrl + R${RESET}         - Previous (older) match"
        echo -e "    - ${CMD}Ctrl + S${RESET}         - Next (newer) match"
        echo -e "    - ${CMD}Ctrl + G${RESET}         - cancel the search"
    }

    _jhelp_terminal_search() {
        echo -e "${SECTION}  TERMINAL SEARCH${RESET}"
        echo -e "${SECTION}  ────────────────────────────────────────────${RESET}"
        echo -e "  ${CMD}jgrep <searchTerm>${RESET}  - search in java files in /c/your-applications"
        echo -e "  ${CMD}jgrepf <searchTerm>${RESET} - search only java files in /c/your-applications"
        echo -e "  ${CMD}search <term> [path] [extension]${RESET}  - search by default java in /c/your-applications"
        echo -e "  ${CMD}ffind <namePattern>${RESET} - find files by name pattern"
        echo -e "  ${CMD}fgrep <filename> <term>${RESET}             - find files by name, then search inside them"
        echo -e "  ${CMD}fgrepn <filename> <term>${RESET}            - same but show matching lines with line numbers"
        echo ""
    }

    case "$1" in
        project)  echo ""; _jhelp_project ;;
        git)      echo ""; _jhelp_git ;;
        gradle)   echo ""; _jhelp_gradle ;;
        process)  echo ""; _jhelp_process ;;
        terminal) echo ""; _jhelp_terminal ;;
        search)   echo ""; _jhelp_terminal_search ;;
        "")
            echo ""
            echo -e "${TITLE} ══════════════════════════════════════════════════════${RESET}"
            echo -e "${TITLE}          Java Developer Bash Commands          ${RESET}"
            echo -e "${TITLE} ══════════════════════════════════════════════════════${RESET}"
            echo ""
            _jhelp_project;  echo ""
            _jhelp_git;      echo ""
            _jhelp_gradle;   echo ""
            _jhelp_process;  echo ""
            _jhelp_terminal; echo ""
            _jhelp_terminal_search; echo ""
            ;;
        *)
            echo -e "\033[1;31mUnknown section: '$1'${RESET}"
            echo -e "${HINT}Usage: jhelp [project|git|gradle|process|terminal|search]${RESET}"
            return 1
            ;;
    esac
    echo ""
    echo -e "${HINT}  Type 'jhelp [project|git|gradle|process|terminal]' to filter by section${RESET}"
}
