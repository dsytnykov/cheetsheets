# Creating Custom Bash Commands in Git Bash (Windows)

This guide explains how to create custom bash commands that you can use in Git Bash on Windows.

## Understanding Custom Commands

Custom bash commands are simply executable scripts that you place in a directory that's included in your system's PATH. When you type a command name, bash searches through PATH directories to find and execute it.

## Method 1: Creating Bash Scripts

### Step 1: Choose a Location for Your Scripts

Create a directory for your custom scripts. A common location is:

```bash
mkdir -p ~/bin
```

This creates a `bin` folder in your home directory (`C:\Users\YourUsername\bin`).

### Step 2: Create Your Custom Script

Create a new file without any extension (or with `.sh` if you prefer):

```bash
touch ~/bin/mycommand
```

### Step 3: Write Your Script

Open the file in a text editor and add your script. Always start with a shebang line:

```bash
#!/bin/bash

# Your custom command code here
echo "Hello from my custom command!"
```

**Example - A command to quickly navigate to a project folder:**

```bash
#!/bin/bash
cd /c/Users/YourUsername/Projects
```

**Example - A command with parameters:**

```bash
#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: greet <name>"
    exit 1
fi

echo "Hello, $1! Welcome to custom commands."
```

### Step 4: Make the Script Executable

```bash
chmod +x ~/bin/mycommand
```

### Step 5: Add the Directory to Your PATH

Edit your `~/.bashrc` file:

```bash
nano ~/.bashrc
```

Add this line at the end:

```bash
export PATH="$HOME/bin:$PATH"
```

Save and exit (Ctrl+X, then Y, then Enter in nano).

### Step 6: Reload Your Configuration

```bash
source ~/.bashrc
```

### Step 7: Test Your Command

```bash
mycommand
```

## Method 2: Creating Bash Aliases (Simpler for Short Commands)

For simple commands, you can create aliases instead of scripts.

### Step 1: Edit Your .bashrc File

```bash
nano ~/.bashrc
```

### Step 2: Add Your Aliases

Add lines like these:

```bash
# Navigate to projects folder
alias projects='cd /c/Users/YourUsername/Projects'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

# List files with details
alias ll='ls -la'

# Clear screen
alias c='clear'
```

### Step 3: Reload Configuration

```bash
source ~/.bashrc
```

### Step 4: Use Your Aliases

```bash
projects
gs
ll
```

## Method 3: Bash Functions (For More Complex Logic)

For commands that need more logic than aliases but don't warrant separate files:

### Edit .bashrc and Add Functions

```bash
nano ~/.bashrc
```

Add functions like:

```bash
# Create a directory and navigate into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Quick git commit with message
qcommit() {
    if [ -z "$1" ]; then
        echo "Usage: qcommit <message>"
        return 1
    fi
    git add .
    git commit -m "$1"
}

# Search in files
search() {
    if [ -z "$1" ]; then
        echo "Usage: search <pattern>"
        return 1
    fi
    grep -r "$1" .
}
```

Reload and use:

```bash
source ~/.bashrc
mkcd mynewfolder
qcommit "Initial commit"
search "TODO"
```

## Method 4: Organizing Functions in Separate Files (Recommended!)

For better organization, you can keep your functions and aliases in separate files and source them from `.bashrc`.

### Step 1: Create a Directory Structure

```bash
mkdir -p ~/.bash
```

### Step 2: Create Separate Files for Different Categories

**Create `~/.bash/functions.sh`:**

```bash
nano ~/.bash/functions.sh
```

Add your functions:

```bash
#!/bin/bash

# Create a directory and navigate into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Quick git commit with message
qcommit() {
    if [ -z "$1" ]; then
        echo "Usage: qcommit <message>"
        return 1
    fi
    git add .
    git commit -m "$1"
}

# Search in files
search() {
    if [ -z "$1" ]; then
        echo "Usage: search <pattern>"
        return 1
    fi
    grep -r "$1" .
}

# Backup a file
backup() {
    if [ -z "$1" ]; then
        echo "Usage: backup <file>"
        return 1
    fi
    cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Backed up: $1"
}
```

**Create `~/.bash/aliases.sh`:**

```bash
nano ~/.bash/aliases.sh
```

Add your aliases:

```bash
#!/bin/bash

# Navigation
alias projects='cd /c/Users/YourUsername/Projects'
alias ..='cd ..'
alias ...='cd ../..'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# List files
alias ll='ls -la'
alias la='ls -A'

# Other
alias c='clear'
alias h='history'
```

**Create `~/.bash/work.sh` (for work-specific functions):**

```bash
nano ~/.bash/work.sh
```

```bash
#!/bin/bash

# Start development environment
devstart() {
    if [ -z "$1" ]; then
        echo "Usage: devstart <project-name>"
        ls ~/Projects
        return 1
    fi
    cd ~/Projects/$1 && code . && git status
}

# Deploy to staging
deploy-staging() {
    echo "Deploying to staging..."
    # Your deployment commands here
}
```

### Step 3: Source These Files in .bashrc

Edit your `~/.bashrc`:

```bash
nano ~/.bashrc
```

Add these lines at the end:

```bash
# Load custom configurations
if [ -f ~/.bash/aliases.sh ]; then
    source ~/.bash/aliases.sh
fi

if [ -f ~/.bash/functions.sh ]; then
    source ~/.bash/functions.sh
fi

if [ -f ~/.bash/work.sh ]; then
    source ~/.bash/work.sh
fi

# You can add more files as needed
# if [ -f ~/.bash/personal.sh ]; then
#     source ~/.bash/personal.sh
# fi
```

### Step 4: Reload Configuration

```bash
source ~/.bashrc
```

### Benefits of This Approach

1. **Organization**: Keep related functions together in separate files
2. **Maintainability**: Easier to edit and manage specific categories
3. **Portability**: Easy to share or backup specific function sets
4. **Modularity**: Enable/disable entire sets by commenting out one line
5. **Clean .bashrc**: Your main `.bashrc` stays small and readable

### Example Project Structure

```
~/.bash/
├── aliases.sh       # All your aliases
├── functions.sh     # General utility functions
├── work.sh          # Work-related functions
├── git.sh           # Git-specific helpers
└── docker.sh        # Docker-related commands
```

### Advanced: Auto-load All Files from a Directory

You can even auto-load all `.sh` files from your `~/.bash/` directory:

Add this to your `~/.bashrc`:

```bash
# Load all .sh files from ~/.bash/ directory
if [ -d ~/.bash ]; then
    for file in ~/.bash/*.sh; do
        if [ -f "$file" ]; then
            source "$file"
        fi
    done
fi
```

This way, any new `.sh` file you create in `~/.bash/` will automatically be loaded!

## Complete Example: Creating a Productivity Command

Let's create a command called `devstart` that opens your project and starts your dev environment.

### Create the script:

```bash
nano ~/bin/devstart
```

### Add the content:

```bash
#!/bin/bash

# Check if project name was provided
if [ -z "$1" ]; then
    echo "Usage: devstart <project-name>"
    echo "Available projects:"
    ls ~/Projects
    exit 1
fi

PROJECT_PATH="$HOME/Projects/$1"

# Check if project exists
if [ ! -d "$PROJECT_PATH" ]; then
    echo "Project '$1' not found in ~/Projects"
    exit 1
fi

# Navigate to project
cd "$PROJECT_PATH"

# Open VS Code (if installed)
if command -v code &> /dev/null; then
    code .
fi

# Show git status
if [ -d ".git" ]; then
    echo "Git Status:"
    git status
fi

# Start bash in the project directory
bash
```

### Make it executable:

```bash
chmod +x ~/bin/devstart
```

### Use it:

```bash
devstart myproject
```

## Tips and Best Practices

1. **Use descriptive names**: Choose command names that are clear and won't conflict with existing commands.

2. **Check if a command exists**: Before creating a custom command, verify it doesn't already exist:

   ```bash
   which commandname
   ```

3. **Add help text**: Include usage instructions in your scripts for when users provide wrong arguments.

4. **Keep .bashrc organized**: Group related aliases and functions with comments.

5. **Backup your configurations**: Keep your `.bashrc` and custom scripts in version control.

6. **Test in a new terminal**: After making changes, open a new Git Bash window to ensure everything loads correctly.

## Troubleshooting

**Command not found after adding to PATH:**

- Ensure you ran `source ~/.bashrc`
- Verify the script has execute permissions: `ls -l ~/bin/mycommand`
- Check PATH includes your bin directory: `echo $PATH`

**Script runs but doesn't work as expected:**

- Check the shebang line is correct: `#!/bin/bash`
- Verify file has Unix line endings (not Windows CRLF)
- Add `set -x` at the start of your script to debug

**Changes to .bashrc not persisting:**

- Make sure you're editing the correct file: `~/.bashrc` in your home directory
- Check if `.bash_profile` exists and sources `.bashrc`

## Useful Script Templates

**Template for commands with options:**

```bash
#!/bin/bash

show_help() {
    echo "Usage: mycommand [OPTIONS]"
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -v, --version  Show version"
    echo "  -o, --output   Specify output file"
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            echo "mycommand v1.0"
            exit 0
            ;;
        -o|--output)
            OUTPUT="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Your command logic here
```

Happy scripting!
