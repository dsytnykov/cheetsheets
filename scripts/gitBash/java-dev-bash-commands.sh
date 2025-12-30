#!/bin/bash
# ~/.bash/java-dev.sh
# Custom bash functions for Java developers

# ============================================
# PROJECT MANAGEMENT
# ============================================

# Quick start a Java project with Maven or Gradle
jstart() {
    if [ -z "$1" ]; then
        echo "Usage: jstart <project-name>"
        return 1
    fi
    
    cd ~/Projects
    if [ -f "pom.xml" ]; then
        echo "Starting Maven project..."
        cd "$1" && code . && mvn clean install
    elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
        echo "Starting Gradle project..."
        cd "$1" && code . && gradle build
    else
        echo "No Maven or Gradle project found"
        cd "$1" && code .
    fi
}

# ============================================
# MAVEN COMMANDS
# ============================================

# Maven clean install (skip tests)
mci() {
    echo "Running: mvn clean install -DskipTests"
    mvn clean install -DskipTests
}

# Maven clean install with tests
mcit() {
    echo "Running: mvn clean install"
    mvn clean install
}

# Maven run specific test class
mtest() {
    if [ -z "$1" ]; then
        echo "Usage: mtest <TestClassName>"
        echo "Example: mtest UserServiceTest"
        return 1
    fi
    mvn test -Dtest="$1"
}

# Maven dependency tree
mdep() {
    mvn dependency:tree
}

# Maven check for dependency updates
mupdate() {
    mvn versions:display-dependency-updates
}

# Maven run Spring Boot application
mrun() {
    mvn spring-boot:run
}

# Maven package without tests
mpackage() {
    mvn clean package -DskipTests
}

# ============================================
# GRADLE COMMANDS
# ============================================

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

# Gradle run application
grun() {
    gradle bootRun
}

# Gradle show dependencies
gdep() {
    gradle dependencies
}

# Gradle check for updates
gupdate() {
    gradle dependencyUpdates
}

# ============================================
# JAVA PROCESS MANAGEMENT
# ============================================

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
        kill -9 "$pid"
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

# ============================================
# CODE NAVIGATION & SEARCH
# ============================================

# Find Java files by name
jfind() {
    if [ -z "$1" ]; then
        echo "Usage: jfind <filename-pattern>"
        return 1
    fi
    find . -name "*$1*.java" -type f
}

# Search in Java files
jsearch() {
    if [ -z "$1" ]; then
        echo "Usage: jsearch <search-term>"
        return 1
    fi
    grep -r --include="*.java" "$1" .
}

# Count lines of Java code
jlines() {
    find . -name "*.java" -type f -exec wc -l {} + | sort -n
    echo "---"
    echo "Total lines:"
    find . -name "*.java" -type f -exec cat {} + | wc -l
}

# Find TODO/FIXME in Java code
jtodo() {
    echo "=== TODO ==="
    grep -rn --include="*.java" "TODO" .
    echo ""
    echo "=== FIXME ==="
    grep -rn --include="*.java" "FIXME" .
}

# ============================================
# DATABASE UTILITIES
# ============================================

# Quick PostgreSQL connection
pgconnect() {
    if [ -z "$1" ]; then
        echo "Usage: pgconnect <database-name>"
        return 1
    fi
    psql -h localhost -U postgres -d "$1"
}

# Quick MySQL connection
myconnect() {
    if [ -z "$1" ]; then
        echo "Usage: myconnect <database-name>"
        return 1
    fi
    mysql -u root -p "$1"
}

# ============================================
# DOCKER HELPERS FOR JAVA APPS
# ============================================

# Build and run Docker container for Java app
jdocker-build() {
    if [ -z "$1" ]; then
        echo "Usage: jdocker-build <image-name>"
        return 1
    fi
    
    docker build -t "$1" .
    echo "Image built: $1"
    echo "Run with: docker run -p 8080:8080 $1"
}

# Start common Java development services
jservices-up() {
    echo "Starting development services..."
    docker-compose up -d postgres redis kafka
    echo "Services started!"
}

# Stop development services
jservices-down() {
    docker-compose down
}

# ============================================
# GIT HELPERS FOR JAVA PROJECTS
# ============================================

# Create feature branch
jfeature() {
    if [ -z "$1" ]; then
        echo "Usage: jfeature <feature-name>"
        return 1
    fi
    
    git checkout -b "feature/$1"
    echo "Created and switched to branch: feature/$1"
}

# Create bugfix branch
jbugfix() {
    if [ -z "$1" ]; then
        echo "Usage: jbugfix <bug-name>"
        return 1
    fi
    
    git checkout -b "bugfix/$1"
    echo "Created and switched to branch: bugfix/$1"
}

# Quick commit with conventional commit format
jcommit() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: jcommit <type> <message>"
        echo "Types: feat, fix, docs, style, refactor, test, chore"
        echo "Example: jcommit feat 'add user authentication'"
        return 1
    fi
    
    git add .
    git commit -m "$1: $2"
}

# ============================================
# TESTING & CODE QUALITY
# ============================================

# Run tests and generate coverage report (Maven)
mcoverage() {
    mvn clean test jacoco:report
    echo "Coverage report generated at: target/site/jacoco/index.html"
}

# Run tests and generate coverage report (Gradle)
gcoverage() {
    gradle test jacocoTestReport
    echo "Coverage report generated at: build/reports/jacoco/test/html/index.html"
}

# Run SonarQube analysis (Maven)
msonar() {
    mvn clean verify sonar:sonar
}

# Run SonarQube analysis (Gradle)
gsonar() {
    gradle sonarqube
}

# ============================================
# LOGS & DEBUGGING
# ============================================

# Tail application logs
jlogs() {
    if [ -f "application.log" ]; then
        tail -f application.log
    elif [ -f "logs/application.log" ]; then
        tail -f logs/application.log
    elif [ -f "target/logs/application.log" ]; then
        tail -f target/logs/application.log
    else
        echo "No application.log found"
        echo "Searching for log files..."
        find . -name "*.log" -type f
    fi
}

# Clear all logs
jlogs-clear() {
    find . -name "*.log" -type f -delete
    echo "All log files deleted"
}

# ============================================
# PERFORMANCE & MONITORING
# ============================================

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

# ============================================
# PROJECT CLEANUP
# ============================================

# Clean all build artifacts
jclean() {
    echo "Cleaning Maven artifacts..."
    rm -rf target/
    
    echo "Cleaning Gradle artifacts..."
    rm -rf build/
    rm -rf .gradle/
    
    echo "Cleaning IDE files..."
    rm -rf .idea/
    rm -rf *.iml
    rm -rf .vscode/
    
    echo "Cleaning logs..."
    find . -name "*.log" -type f -delete
    
    echo "Cleanup complete!"
}

# ============================================
# UTILITY FUNCTIONS
# ============================================

# Quick switch between Java versions (if using jenv or similar)
jswitch() {
    if [ -z "$1" ]; then
        echo "Current Java version:"
        java -version
        echo ""
        echo "Available versions:"
        ls /c/Program\ Files/Java/ 2>/dev/null || echo "JAVA_HOME not found"
        return 1
    fi
    
    export JAVA_HOME="/c/Program Files/Java/jdk-$1"
    export PATH="$JAVA_HOME/bin:$PATH"
    echo "Switched to Java $1"
    java -version
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

# Create .gitignore for Java projects
jgitignore() {
    cat > .gitignore << 'EOF'
# Compiled class files
*.class

# Log files
*.log

# BlueJ files
*.ctxt

# Mobile Tools for Java (J2ME)
.mtj.tmp/

# Package Files
*.jar
*.war
*.nar
*.ear
*.zip
*.tar.gz
*.rar

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
*.iws
*.iml
*.ipr
.vscode/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Application logs
logs/
*.log.*

# H2 Database
*.db
EOF
    echo ".gitignore created for Java project"
}

# Show help for all Java commands
jhelp() {
    echo "=== Java Developer Bash Commands ==="
    echo ""
    echo "PROJECT MANAGEMENT:"
    echo "  jstart <name>        - Start Java project (Maven/Gradle)"
    echo "  spring-init <name>   - Create Spring Boot structure"
    echo ""
    echo "MAVEN:"
    echo "  mci                  - Clean install (skip tests)"
    echo "  mcit                 - Clean install (with tests)"
    echo "  mtest <class>        - Run specific test"
    echo "  mdep                 - Show dependency tree"
    echo "  mrun                 - Run Spring Boot app"
    echo "  mcoverage            - Generate coverage report"
    echo ""
    echo "GRADLE:"
    echo "  gbuild               - Build (skip tests)"
    echo "  gbuildt              - Build (with tests)"
    echo "  gtest <class>        - Run specific test"
    echo "  grun                 - Run application"
    echo "  gcoverage            - Generate coverage report"
    echo ""
    echo "PROCESS MANAGEMENT:"
    echo "  jps-custom           - List Java processes"
    echo "  jkill <pattern>      - Kill Java process"
    echo "  jport <port>         - Check port usage"
    echo ""
    echo "CODE SEARCH:"
    echo "  jfind <pattern>      - Find Java files"
    echo "  jsearch <term>       - Search in Java files"
    echo "  jtodo                - Find TODO/FIXME"
    echo "  jlines               - Count lines of code"
    echo ""
    echo "GIT:"
    echo "  jfeature <name>      - Create feature branch"
    echo "  jbugfix <name>       - Create bugfix branch"
    echo "  jcommit <type> <msg> - Conventional commit"
    echo ""
    echo "UTILITIES:"
    echo "  jclean               - Clean all build artifacts"
    echo "  jlogs                - Tail application logs"
    echo "  jenv-show            - Show Java environment"
    echo "  jgitignore           - Create Java .gitignore"
    echo ""
    echo "Type 'jhelp' anytime to see this help message"
}