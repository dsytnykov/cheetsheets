## 🧭 Step-by-step fix

### 🧪 1. Confirm your script exists

Run:

```powershell
notepad C:\MyCommands\mytools.ps1
```

Make sure it contains something like:

```powershell
function hello {
Write-Host "Hello!"
}
```

Save and close.

###🔌 2. Load it manually (test)

In PowerShell:

```powershell
. C:\MyCommands\mytools.ps1
```

⚠️ Note the dot + space before the path — this is mandatory.

Now test:

```powershell
hello
```

If it works now → your script is correct 👍
If not, tell me what error you get.

### 🧷 3. Make it load automatically (permanent fix)

Open your PowerShell profile:

```powershell
notepad $PROFILE
```

Add this line:

```powershell
. C:\MyCommands\mytools.ps1
```

Save. Close PowerShell completely. Open it again.

Now test:

```powershell
hello
```

It should work forever now.

🧠 Why that error happened

PowerShell doesn’t automatically load .ps1 files.
Functions only exist after the file defining them is dot-sourced into the session.

## Optional things that can help

```powershell
notepad $PROFILE
## If it says the file doesn't exist, create it:
New-Item -Type File -Path $PROFILE -Force
notepad $PROFILE
```

### Allow script execution (one time only)

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Add the folder with a script to PATH

```powershell
setx PATH "$env:PATH;C:\MyCommands"
```

# 🧱 Option 1 — Multiple commands inside one script

Let’s create one file that contains many custom commands.

## 🗂️ Example: mytools.ps1

```powershell
# ====== MY CUSTOM COMMANDS ======

function hello {
Write-Host "Hello!"
}

function greet($name) {
Write-Host "Hello, $name!"
}

function cleanup {
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Temp cleaned."
}

function startdev {
code .
npm run dev
}
```

Save this as: C:\MyCommands\mytools.ps1

## 🧷 Make all commands available at once

Add this line to your PowerShell profile:

```powershell
. C:\MyCommands\mytools.ps1
```

(the dot at the start is important — it’s called dot-sourcing)

Restart PowerShell.

Now you can run:

hello
greet John
cleanup
startdev

All from one file. 🧙‍♂️

# 🧩 Option 2 — Combine multiple scripts

Suppose you have:

```powershell
C:\MyCommands\backup.ps1
C:\MyCommands\cleanup.ps1
C:\MyCommands\dev.ps1
```

Create a loader script:

```powershell
🗂️ loadtools.ps1
. C:\MyCommands\backup.ps1
. C:\MyCommands\cleanup.ps1
. C:\MyCommands\dev.ps1
```

Then in your profile:

```powershell
. C:\MyCommands\loadtools.ps1
```

Boom — everything loads automatically.

## 🧠 Professional pattern

Many PowerShell users structure their personal commands like this:

```powershell
C:\MyCommands\
 tools.ps1
backup.ps1
network.ps1
dev.ps1
```

with one loader script that imports them all.
