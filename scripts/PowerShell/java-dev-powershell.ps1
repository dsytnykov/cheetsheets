# Java-Dev-Functions.ps1

# Custom PowerShell functions for Java developers

# Save this file and add to your PowerShell profile

# ============================================

# PROJECT MANAGEMENT

# ============================================

function jstart {
param(
[Parameter(Mandatory=$true)]
[string]$ProjectName
)

    Set-Location ~\Projects
    if (Test-Path "pom.xml") {
        Write-Host "Starting Maven project..." -ForegroundColor Green
        Set-Location $ProjectName
        code .
        mvn clean install
    }
    elseif ((Test-Path "build.gradle") -or (Test-Path "build.gradle.kts")) {
        Write-Host "Starting Gradle project..." -ForegroundColor Green
        Set-Location $ProjectName
        code .
        .\gradlew build
    }
    else {
        Write-Host "No Maven or Gradle project found" -ForegroundColor Yellow
        Set-Location $ProjectName
        code .
    }

}

# ============================================

# MAVEN COMMANDS

# ============================================

function mci {
Write-Host "Running: mvn clean install -DskipTests" -ForegroundColor Cyan
mvn clean install -DskipTests
}

function mcit {
Write-Host "Running: mvn clean install" -ForegroundColor Cyan
mvn clean install
}

function mtest {
param(
[Parameter(Mandatory=$true)]
[string]$TestClass
)

    mvn test -Dtest="$TestClass"

}

function mdep {
mvn dependency:tree
}

function mupdate {
mvn versions:display-dependency-updates
}

function mrun {
mvn spring-boot:run
}

function mpackage {
mvn clean package -DskipTests
}

# ============================================

# GRADLE COMMANDS

# ============================================

function gbuild {
gradle build -x test
}

function gbuildt {
gradle build
}

function gclean {
gradle clean build
}

function gtest {
param(
[Parameter(Mandatory=$true)]
[string]$TestClass
)

    gradle test --tests "$TestClass"

}

function grun {
gradle bootRun
}

function gdep {
gradle dependencies
}

function gupdate {
gradle dependencyUpdates
}

# ============================================

# JAVA PROCESS MANAGEMENT

# ============================================

function jps-custom {
Write-Host "Java Processes:" -ForegroundColor Green
jps -l
}

function jkill {
param(
[Parameter(Mandatory=$false)]
[string]$ProcessPattern
)

    if (-not $ProcessPattern) {
        Write-Host "Usage: jkill <process-name-pattern>" -ForegroundColor Yellow
        Write-Host "Current Java processes:" -ForegroundColor Cyan
        jps -l
        return
    }

    $processes = Get-Process -Name java -ErrorAction SilentlyContinue | Where-Object {
        $_.MainWindowTitle -match $ProcessPattern -or $_.ProcessName -match $ProcessPattern
    }

    if ($processes) {
        $processes | ForEach-Object {
            Write-Host "Killing process $($_.Id): $($_.ProcessName)" -ForegroundColor Red
            Stop-Process -Id $_.Id -Force
        }
    }
    else {
        Write-Host "No process found matching: $ProcessPattern" -ForegroundColor Yellow
    }

}

function jport {
param(
[Parameter(Mandatory=$true)]
[int]$Port
)

    Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue |
        Select-Object LocalAddress, LocalPort, RemoteAddress, State,
        @{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}}

}

# ============================================

# CODE NAVIGATION & SEARCH

# ============================================

function jfind {
param(
[Parameter(Mandatory=$true)]
[string]$Pattern
)

    Get-ChildItem -Recurse -Filter "*$Pattern*.java" | Select-Object FullName

}

function jsearch {
param(
[Parameter(Mandatory=$true)]
[string]$SearchTerm
)

    Get-ChildItem -Recurse -Filter "*.java" | Select-String -Pattern $SearchTerm

}

function jlines {
Write-Host "Counting lines in Java files..." -ForegroundColor Cyan
$files = Get-ChildItem -Recurse -Filter "\*.java"
$totalLines = 0

    $files | ForEach-Object {
        $lines = (Get-Content $_.FullName | Measure-Object -Line).Lines
        Write-Host "$($_.FullName): $lines lines"
        $totalLines += $lines
    }

    Write-Host "---" -ForegroundColor Yellow
    Write-Host "Total lines: $totalLines" -ForegroundColor Green

}

function jtodo {
Write-Host "=== TODO ===" -ForegroundColor Yellow
Get-ChildItem -Recurse -Filter "_.java" | Select-String -Pattern "TODO"
Write-Host ""
Write-Host "=== FIXME ===" -ForegroundColor Red
Get-ChildItem -Recurse -Filter "_.java" | Select-String -Pattern "FIXME"
}

# ============================================

# DATABASE UTILITIES

# ============================================

function pgconnect {
param(
[Parameter(Mandatory=$true)]
[string]$DatabaseName
)

    psql -h localhost -U postgres -d $DatabaseName

}

function myconnect {
param(
[Parameter(Mandatory=$true)]
[string]$DatabaseName
)

    mysql -u root -p $DatabaseName

}

# ============================================

# DOCKER HELPERS FOR JAVA APPS

# ============================================

function jdocker-build {
param(
[Parameter(Mandatory=$true)]
[string]$ImageName
)

    docker build -t $ImageName .
    Write-Host "Image built: $ImageName" -ForegroundColor Green
    Write-Host "Run with: docker run -p 8080:8080 $ImageName" -ForegroundColor Cyan

}

function jservices-up {
Write-Host "Starting development services..." -ForegroundColor Green
docker-compose up -d postgres redis kafka
Write-Host "Services started!" -ForegroundColor Green
}

function jservices-down {
docker-compose down
}

# ============================================

# GIT HELPERS FOR JAVA PROJECTS

# ============================================

function jfeature {
param(
[Parameter(Mandatory=$true)]
[string]$FeatureName
)

    git checkout -b "feature/$FeatureName"
    Write-Host "Created and switched to branch: feature/$FeatureName" -ForegroundColor Green

}

function jbugfix {
param(
[Parameter(Mandatory=$true)]
[string]$BugName
)

    git checkout -b "bugfix/$BugName"
    Write-Host "Created and switched to branch: bugfix/$BugName" -ForegroundColor Green

}

function jcommit {
param(
[Parameter(Mandatory=$true)]
[string]$Type,
        [Parameter(Mandatory=$true)]
[string]$Message
)

    if ($Type -notin @('feat', 'fix', 'docs', 'style', 'refactor', 'test', 'chore')) {
        Write-Host "Valid types: feat, fix, docs, style, refactor, test, chore" -ForegroundColor Yellow
        return
    }

    git add .
    git commit -m "${Type}: $Message"

}

# ============================================

# TESTING & CODE QUALITY

# ============================================

function mcoverage {
mvn clean test jacoco:report
Write-Host "Coverage report generated at: target\site\jacoco\index.html" -ForegroundColor Green
}

function gcoverage {
.\gradlew test jacocoTestReport
Write-Host "Coverage report generated at: build\reports\jacoco\test\html\index.html" -ForegroundColor Green
}

function msonar {
mvn clean verify sonar:sonar
}

function gsonar {
.\gradlew sonarqube
}

# ============================================

# LOGS & DEBUGGING

# ============================================

function jlogs {
$logPaths = @(
"application.log",
"logs\application.log",
"target\logs\application.log"
)

    $foundLog = $false
    foreach ($path in $logPaths) {
        if (Test-Path $path) {
            Write-Host "Tailing: $path" -ForegroundColor Green
            Get-Content $path -Wait -Tail 50
            $foundLog = $true
            break
        }
    }

    if (-not $foundLog) {
        Write-Host "No application.log found" -ForegroundColor Yellow
        Write-Host "Searching for log files..." -ForegroundColor Cyan
        Get-ChildItem -Recurse -Filter "*.log" | Select-Object FullName
    }

}

function jlogs-clear {
Get-ChildItem -Recurse -Filter "\*.log" | Remove-Item -Force
Write-Host "All log files deleted" -ForegroundColor Green
}

# ============================================

# PERFORMANCE & MONITORING

# ============================================

function jheap-dump {
param(
[Parameter(Mandatory=$false)]
[int]$ProcessId
)

    if (-not $ProcessId) {
        Write-Host "Usage: jheap-dump <pid>" -ForegroundColor Yellow
        Write-Host "Current Java processes:" -ForegroundColor Cyan
        jps -l
        return
    }

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $filename = "heapdump_$timestamp.hprof"
    jmap -dump:format=b,file=$filename $ProcessId
    Write-Host "Heap dump created: $filename" -ForegroundColor Green

}

function jmem {
param(
[Parameter(Mandatory=$false)]
[int]$ProcessId
)

    if (-not $ProcessId) {
        Write-Host "Usage: jmem <pid>" -ForegroundColor Yellow
        Write-Host "Current Java processes:" -ForegroundColor Cyan
        jps -l
        return
    }

    jstat -gc $ProcessId 1000 5

}

# ============================================

# PROJECT CLEANUP

# ============================================

function jclean {
Write-Host "Cleaning Maven artifacts..." -ForegroundColor Cyan
if (Test-Path "target") { Remove-Item -Recurse -Force "target" }

    Write-Host "Cleaning Gradle artifacts..." -ForegroundColor Cyan
    if (Test-Path "build") { Remove-Item -Recurse -Force "build" }
    if (Test-Path ".gradle") { Remove-Item -Recurse -Force ".gradle" }

    Write-Host "Cleaning IDE files..." -ForegroundColor Cyan
    if (Test-Path ".idea") { Remove-Item -Recurse -Force ".idea" }
    Get-ChildItem -Filter "*.iml" -Recurse | Remove-Item -Force
    if (Test-Path ".vscode") { Remove-Item -Recurse -Force ".vscode" }

    Write-Host "Cleaning logs..." -ForegroundColor Cyan
    Get-ChildItem -Filter "*.log" -Recurse | Remove-Item -Force

    Write-Host "Cleanup complete!" -ForegroundColor Green

}

# ============================================

# UTILITY FUNCTIONS

# ============================================

function jswitch {
param(
[Parameter(Mandatory=$false)]
[string]$Version
)

    if (-not $Version) {
        Write-Host "Current Java version:" -ForegroundColor Cyan
        java -version
        Write-Host ""
        Write-Host "Available versions:" -ForegroundColor Cyan
        Get-ChildItem "C:\Program Files\Java" -ErrorAction SilentlyContinue | Select-Object Name
        return
    }

    $javaPath = "C:\Program Files\Java\jdk-$Version"
    if (Test-Path $javaPath) {
        $env:JAVA_HOME = $javaPath
        $env:PATH = "$javaPath\bin;$env:PATH"
        Write-Host "Switched to Java $Version" -ForegroundColor Green
        java -version
    }
    else {
        Write-Host "Java version $Version not found at $javaPath" -ForegroundColor Red
    }

}

function jenv-show {
Write-Host "JAVA_HOME: $env:JAVA_HOME" -ForegroundColor Cyan
Write-Host ""
Write-Host "Java Version:" -ForegroundColor Cyan
java -version
Write-Host ""
Write-Host "Maven Version:" -ForegroundColor Cyan
mvn -version
Write-Host ""
Write-Host "Gradle Version:" -ForegroundColor Cyan
if (Test-Path ".\gradlew.bat") {
.\gradlew -version
}
else {
Write-Host "No Gradle wrapper found" -ForegroundColor Yellow
}
}

function jgitignore {
$gitignoreContent = @'

# Compiled class files

\*.class

# Log files

\*.log

# BlueJ files

\*.ctxt

# Mobile Tools for Java (J2ME)

.mtj.tmp/

# Package Files

_.jar
_.war
_.nar
_.ear
_.zip
_.tar.gz
\*.rar

# Maven

target/
pom.xml.tag
pom.xml.releaseBackup
pom.xml.versionsBackup
pom.xml.next
release.properties
dependency-reduced-pom.xml
buildNumber.properties
.mvn/timing.properties

# Gradle

.gradle
build/
!gradle/wrapper/gradle-wrapper.jar

# IDE

.idea/
_.iws
_.iml
_.ipr
.vscode/
_.swp
_.swo
_~

# OS

.DS_Store
Thumbs.db

# Application logs

logs/
_.log._

# H2 Database

\*.db
'@

    Set-Content -Path ".gitignore" -Value $gitignoreContent
    Write-Host ".gitignore created for Java project" -ForegroundColor Green

}

# ============================================

# HELP FUNCTION

# ============================================

function jhelp {
Write-Host "=== Java Developer PowerShell Commands ===" -ForegroundColor Green
Write-Host ""
Write-Host "PROJECT MANAGEMENT:" -ForegroundColor Yellow
Write-Host " jstart <name> - Start Java project (Maven/Gradle)"
Write-Host " spring-init <name> - Create Spring Boot structure"
Write-Host ""
Write-Host "MAVEN:" -ForegroundColor Yellow
Write-Host " mci - Clean install (skip tests)"
Write-Host " mcit - Clean install (with tests)"
Write-Host " mtest <class> - Run specific test"
Write-Host " mdep - Show dependency tree"
Write-Host " mrun - Run Spring Boot app"
Write-Host " mcoverage - Generate coverage report"
Write-Host ""
Write-Host "GRADLE:" -ForegroundColor Yellow
Write-Host " gbuild - Build (skip tests)"
Write-Host " gbuildt - Build (with tests)"
Write-Host " gtest <class> - Run specific test"
Write-Host " grun - Run application"
Write-Host " gcoverage - Generate coverage report"
Write-Host ""
Write-Host "PROCESS MANAGEMENT:" -ForegroundColor Yellow
Write-Host " jps-custom - List Java processes"
Write-Host " jkill <pattern> - Kill Java process"
Write-Host " jport <port> - Check port usage"
Write-Host ""
Write-Host "CODE SEARCH:" -ForegroundColor Yellow
Write-Host " jfind <pattern> - Find Java files"
Write-Host " jsearch <term> - Search in Java files"
Write-Host " jtodo - Find TODO/FIXME"
Write-Host " jlines - Count lines of code"
Write-Host ""
Write-Host "GIT:" -ForegroundColor Yellow
Write-Host " jfeature <name> - Create feature branch"
Write-Host " jbugfix <name> - Create bugfix branch"
Write-Host " jcommit <type> <msg> - Conventional commit"
Write-Host ""
Write-Host "UTILITIES:" -ForegroundColor Yellow
Write-Host " jclean - Clean all build artifacts"
Write-Host " jlogs - Tail application logs"
Write-Host " jenv-show - Show Java environment"
Write-Host " jgitignore - Create Java .gitignore"
Write-Host " jswitch <version> - Switch Java version"
Write-Host ""
Write-Host "Type 'jhelp' anytime to see this help message" -ForegroundColor Cyan
}

# ============================================

# INITIALIZATION MESSAGE

# ============================================

Write-Host "Java Developer Functions Loaded!" -ForegroundColor Green
Write-Host "Type 'jhelp' to see all available commands" -ForegroundColor Cyan
'@
