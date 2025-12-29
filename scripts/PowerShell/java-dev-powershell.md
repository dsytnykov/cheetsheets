# README section for PowerShell setup
$readmeContent = @'
# Java Developer PowerShell Functions - Setup Guide

## Installation

### Step 1: Locate Your PowerShell Profile

Open PowerShell and type:

```powershell
$PROFILE
```

This shows the path to your profile file (usually: `C:\Users\YourName\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`)

### Step 2: Create Profile Directory (if it doesn't exist)

```powershell
New-Item -ItemType Directory -Path (Split-Path $PROFILE) -Force
```

### Step 3: Save the Java Functions File

Save the `Java-Dev-Functions.ps1` file to a location, for example:
- `C:\Users\YourName\Documents\PowerShell\Java-Dev-Functions.ps1`

### Step 4: Add to Your Profile

Open your PowerShell profile:

```powershell
notepad $PROFILE
```

Add this line to load the functions:

```powershell
# Load Java Developer Functions
. "C:\Users\YourName\Documents\PowerShell\Java-Dev-Functions.ps1"
```

### Step 5: Set Execution Policy (if needed)

PowerShell might block scripts. Run PowerShell as Administrator and execute:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Step 6: Reload Profile

Close and reopen PowerShell, or run:

```powershell
. $PROFILE
```

## Verify Installation

Type:

```powershell
jhelp
```

You should see the list of all available commands!

## Alternative: Module-Based Installation

For a more organized approach, create a PowerShell module:

### Step 1: Create Module Directory

```powershell
$modulePath = "$env:USERPROFILE\Documents\WindowsPowerShell\Modules\JavaDevTools"
New-Item -ItemType Directory -Path $modulePath -Force
```

### Step 2: Save as Module

Save the functions file as:
```
C:\Users\YourName\Documents\WindowsPowerShell\Modules\JavaDevTools\JavaDevTools.psm1
```

### Step 3: Import in Profile

Edit your profile:

```powershell
notepad $PROFILE
```

Add:

```powershell
Import-Module JavaDevTools
```

### Step 4: Reload

```powershell
. $PROFILE
```

## Quick Reference

After installation, use these commands:

- `jhelp` - Show all commands
- `mci` - Maven clean install (no tests)
- `gbuild` - Gradle build (no tests)
- `jkill <name>` - Kill Java process
- `jclean` - Clean all build artifacts
- `jfeature <name>` - Create feature branch
- `jtodo` - Find all TODOs
- `jlogs` - Tail application logs

## Customization

Edit the functions file to:
- Change default paths (Projects folder, etc.)
- Add your own custom commands
- Modify existing commands to match your workflow

## Troubleshooting

**Functions not loading:**
- Check execution policy: `Get-ExecutionPolicy`
- Verify profile path: `Test-Path $PROFILE`
- Check for syntax errors in the script

**Permission denied:**
- Run PowerShell as Administrator
- Set execution policy: `Set-ExecutionPolicy RemoteSigned`

**Commands not found:**
- Ensure profile is loaded: `. $PROFILE`
- Check if file is sourced correctly in profile
- Verify file path in profile matches actual location

## Uninstallation

Remove the line from your PowerShell profile:

```powershell
notepad $PROFILE
```

Delete the import/source line and save.
'@

Write-Output $readmeContent | Out-File -FilePath "PowerShell-Setup-README.md" -Encoding UTF8
