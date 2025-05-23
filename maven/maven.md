# Maven Cheatsheet for Senior Java Developers

## Project Setup and Structure

### Creating Projects with Archetypes
```bash
# Create a standard Java project
mvn archetype:generate -DgroupId=com.example -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false

# Create a webapp project
mvn archetype:generate -DgroupId=com.example -DartifactId=my-webapp -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false

# Create a multi-module project
mvn archetype:generate -DgroupId=com.example -DartifactId=parent -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

### Standard Directory Structure
```
src/main/java/         # Java source code
src/main/resources/    # Resources for the main code
src/test/java/         # Test source code
src/test/resources/    # Resources for tests
target/                # Compiled output
pom.xml                # Project configuration
```

## Dependency Management

### Dependency Scopes
```xml
<!-- Available during all phases -->
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.12.0</version>
    <scope>compile</scope> <!-- default scope -->
</dependency>

<!-- Available only during testing -->
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter</artifactId>
    <version>5.9.2</version>
    <scope>test</scope>
</dependency>

<!-- Available during compile but not included in final artifact -->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.26</version>
    <scope>provided</scope>
</dependency>

<!-- Available at runtime but not compile time -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
    <scope>runtime</scope>
</dependency>

<!-- Not included in transitive dependencies -->
<dependency>
    <groupId>log4j</groupId>
    <artifactId>log4j</artifactId>
    <version>1.2.17</version>
    <scope>import</scope>
</dependency>
```

### Dependency Exclusions
```xml
<dependency>
    <groupId>com.example</groupId>
    <artifactId>example-lib</artifactId>
    <version>1.0.0</version>
    <exclusions>
        <exclusion>
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

### Bill of Materials (BOM)
```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>3.1.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>

<!-- Now you can define dependencies without versions -->
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```

### Analyzing Dependencies
```bash
# Show dependency tree
mvn dependency:tree

# Check for dependency conflicts
mvn dependency:analyze

# Check for newer versions of dependencies
mvn versions:display-dependency-updates

# Check for newer plugin versions
mvn versions:display-plugin-updates
```

## Build Lifecycle and Plugins

### Core Build Lifecycle Phases
```bash
# Clean previous builds
mvn clean

# Compile main source code
mvn compile

# Run tests
mvn test

# Package the compiled code
mvn package

# Install the package into local repository
mvn install

# Deploy the package to a remote repository
mvn deploy
```

### Skip Tests
```bash
# Skip test execution
mvn package -DskipTests

# Skip test compilation and execution
mvn package -Dmaven.test.skip=true
```

### Build Profiles
```xml
<profiles>
    <!-- Development profile -->
    <profile>
        <id>dev</id>
        <activation>
            <activeByDefault>true</activeByDefault>
        </activation>
        <properties>
            <env>dev</env>
            <logLevel>DEBUG</logLevel>
        </properties>
    </profile>
    
    <!-- Production profile -->
    <profile>
        <id>prod</id>
        <properties>
            <env>prod</env>
            <logLevel>INFO</logLevel>
        </properties>
    </profile>
</profiles>
```

```bash
# Activate specific profile
mvn package -P prod
```

### Properties
```xml
<properties>
    <!-- Java version -->
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
    
    <!-- Project encoding -->
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    
    <!-- Dependencies versions -->
    <spring.version>6.0.9</spring.version>
    <junit.version>5.9.2</junit.version>
</properties>
```

## Plugin Configuration

### Compiler Plugin
```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.11.0</version>
    <configuration>
        <source>17</source>
        <target>17</target>
        <compilerArgs>
            <arg>--enable-preview</arg>
            <arg>-Xlint:all</arg>
        </compilerArgs>
        <annotationProcessorPaths>
            <path>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
                <version>1.18.26</version>
            </path>
        </annotationProcessorPaths>
    </configuration>
</plugin>
```

### Surefire Plugin (Testing)
```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.1.0</version>
    <configuration>
        <includes>
            <include>**/*Test.java</include>
        </includes>
        <excludes>
            <exclude>**/*IntegrationTest.java</exclude>
        </excludes>
        <argLine>
            --enable-preview
            -Xmx1024m 
            -Duser.timezone=UTC
        </argLine>
        <parallel>methods</parallel>
        <threadCount>10</threadCount>
    </configuration>
</plugin>
```

### Failsafe Plugin (Integration Testing)
```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-failsafe-plugin</artifactId>
    <version>3.1.0</version>
    <executions>
        <execution>
            <goals>
                <goal>integration-test</goal>
                <goal>verify</goal>
            </goals>
        </execution>
    </executions>
    <configuration>
        <includes>
            <include>**/*IntegrationTest.java</include>
        </includes>
    </configuration>
</plugin>
```

### JAR Plugin
```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-jar-plugin</artifactId>
    <version>3.3.0</version>
    <configuration>
        <archive>
            <manifest>
                <addClasspath>true</addClasspath>
                <classpathPrefix>lib/</classpathPrefix>
                <mainClass>com.example.MainApp</mainClass>
            </manifest>
            <manifestEntries>
                <Build-Time>${maven.build.timestamp}</Build-Time>
                <Implementation-Version>${project.version}</Implementation-Version>
                <Implementation-Title>${project.name}</Implementation-Title>
            </manifestEntries>
        </archive>
    </configuration>
</plugin>
```

### Assembly Plugin (fat/uber JARs)
```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-assembly-plugin</artifactId>
    <version>3.5.0</version>
    <configuration>
        <descriptorRefs>
            <descriptorRef>jar-with-dependencies</descriptorRef>
        </descriptorRefs>
        <archive>
            <manifest>
                <mainClass>com.example.MainApp</mainClass>
            </manifest>
        </archive>
    </configuration>
    <executions>
        <execution>
            <id>make-assembly</id>
            <phase>package</phase>
            <goals>
                <goal>single</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

### Shade Plugin (alternative for uber JARs)
```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-shade-plugin</artifactId>
    <version>3.4.1</version>
    <executions>
        <execution>
            <phase>package</phase>
            <goals>
                <goal>shade</goal>
            </goals>
            <configuration>
                <transformers>
                    <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                        <mainClass>com.example.MainApp</mainClass>
                    </transformer>
                    <!-- Merge service files (for SPI) -->
                    <transformer implementation="org.apache.maven.plugins.shade.resource.ServicesResourceTransformer"/>
                </transformers>
                <filters>
                    <filter>
                        <artifact>*:*</artifact>
                        <excludes>
                            <exclude>META-INF/*.SF</exclude>
                            <exclude>META-INF/*.DSA</exclude>
                            <exclude>META-INF/*.RSA</exclude>
                        </excludes>
                    </filter>
                </filters>
                <relocations>
                    <relocation>
                        <pattern>com.google</pattern>
                        <shadedPattern>com.example.shaded.google</shadedPattern>
                    </relocation>
                </relocations>
            </configuration>
        </execution>
    </executions>
</plugin>
```

### Code Coverage (JaCoCo)
```xml
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.10</version>
    <executions>
        <execution>
            <id>prepare-agent</id>
            <goals>
                <goal>prepare-agent</goal>
            </goals>
        </execution>
        <execution>
            <id>report</id>
            <phase>test</phase>
            <goals>
                <goal>report</goal>
            </goals>
        </execution>
        <execution>
            <id>check</id>
            <goals>
                <goal>check</goal>
            </goals>
            <configuration>
                <rules>
                    <rule>
                        <element>BUNDLE</element>
                        <limits>
                            <limit>
                                <counter>LINE</counter>
                                <value>COVEREDRATIO</value>
                                <minimum>0.80</minimum>
                            </limit>
                        </limits>
                    </rule>
                </rules>
            </configuration>
        </execution>
    </executions>
</plugin>
```

### Static Analysis (SpotBugs)
```xml
<plugin>
    <groupId>com.github.spotbugs</groupId>
    <artifactId>spotbugs-maven-plugin</artifactId>
    <version>4.7.3.4</version>
    <dependencies>
        <dependency>
            <groupId>com.github.spotbugs</groupId>
            <artifactId>spotbugs</artifactId>
            <version>4.7.3</version>
        </dependency>
    </dependencies>
    <configuration>
        <effort>Max</effort>
        <threshold>Medium</threshold>
        <xmlOutput>true</xmlOutput>
        <excludeFilterFile>${project.basedir}/spotbugs-exclude.xml</excludeFilterFile>
    </configuration>
    <executions>
        <execution>
            <goals>
                <goal>check</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

### Enforcer Plugin (build policy)
```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-enforcer-plugin</artifactId>
    <version>3.3.0</version>
    <executions>
        <execution>
            <id>enforce-rules</id>
            <goals>
                <goal>enforce</goal>
            </goals>
            <configuration>
                <rules>
                    <requireMavenVersion>
                        <version>[3.8.0,)</version>
                    </requireMavenVersion>
                    <requireJavaVersion>
                        <version>[17,)</version>
                    </requireJavaVersion>
                    <banDuplicatePomDependencyVersions/>
                    <dependencyConvergence/>
                    <reactorModuleConvergence/>
                    <bannedDependencies>
                        <excludes>
                            <exclude>commons-logging:commons-logging</exclude>
                            <exclude>log4j:log4j</exclude>
                        </excludes>
                    </bannedDependencies>
                </rules>
            </configuration>
        </execution>
    </executions>
</plugin>
```

## Advanced Features

### Maven Wrapper
```bash
# Install Maven Wrapper
mvn wrapper:wrapper

# Specify Maven version for wrapper
mvn wrapper:wrapper -Dmaven=3.9.2
```

### Multi-Module Project Structure
```
my-parent/
  ├── pom.xml (parent)
  ├── common/
  │    └── pom.xml
  ├── service/
  │    └── pom.xml
  └── web/
       └── pom.xml
```

Parent POM:
```xml
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>my-parent</artifactId>
    <version>1.0.0</version>
    <packaging>pom</packaging>
    
    <modules>
        <module>common</module>
        <module>service</module>
        <module>web</module>
    </modules>
    
    <!-- Common dependencies and plugins -->
</project>
```

Child POM:
```xml
<project>
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.example</groupId>
        <artifactId>my-parent</artifactId>
        <version>1.0.0</version>
    </parent>
    <artifactId>common</artifactId>
    
    <!-- Module-specific configuration -->
</project>
```

### Flatten Maven Plugin (CI-friendly versions)
```xml
<plugin>
    <groupId>org.codehaus.mojo</groupId>
    <artifactId>flatten-maven-plugin</artifactId>
    <version>1.5.0</version>
    <configuration>
        <updatePomFile>true</updatePomFile>
        <flattenMode>resolveCiFriendliesOnly</flattenMode>
    </configuration>
    <executions>
        <execution>
            <id>flatten</id>
            <phase>process-resources</phase>
            <goals>
                <goal>flatten</goal>
            </goals>
        </execution>
        <execution>
            <id>flatten.clean</id>
            <phase>clean</phase>
            <goals>
                <goal>clean</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

### Maven Release Plugin
```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-release-plugin</artifactId>
    <version>3.0.0</version>
    <configuration>
        <tagNameFormat>v@{project.version}</tagNameFormat>
        <autoVersionSubmodules>true</autoVersionSubmodules>
        <releaseProfiles>release</releaseProfiles>
        <goals>deploy</goals>
    </configuration>
</plugin>
```

```bash
# Prepare release
mvn release:prepare

# Perform release
mvn release:perform

# Rollback a failed release
mvn release:rollback
```

### Repository Configuration
```xml
<repositories>
    <repository>
        <id>central</id>
        <url>https://repo.maven.apache.org/maven2</url>
    </repository>
    <repository>
        <id>company-repo</id>
        <url>https://repo.example.com/maven</url>
        <releases>
            <enabled>true</enabled>
        </releases>
        <snapshots>
            <enabled>false</enabled>
        </snapshots>
    </repository>
</repositories>

<distributionManagement>
    <repository>
        <id>internal.repo</id>
        <name>Internal Repository</name>
        <url>https://repo.example.com/maven-releases</url>
    </repository>
    <snapshotRepository>
        <id>internal.repo.snapshots</id>
        <name>Internal Snapshot Repository</name>
        <url>https://repo.example.com/maven-snapshots</url>
    </snapshotRepository>
</distributionManagement>
```

### Settings.xml Configuration
```xml
<settings>
    <servers>
        <server>
            <id>internal.repo</id>
            <username>username</username>
            <password>password</password>
        </server>
    </servers>
    
    <mirrors>
        <mirror>
            <id>nexus</id>
            <mirrorOf>*</mirrorOf>
            <url>https://nexus.example.com/repository/maven-public/</url>
        </mirror>
    </mirrors>
    
    <profiles>
        <profile>
            <id>default</id>
            <properties>
                <downloadSources>true</downloadSources>
                <downloadJavadocs>true</downloadJavadocs>
            </properties>
        </profile>
    </profiles>
    
    <activeProfiles>
        <activeProfile>default</activeProfile>
    </activeProfiles>
</settings>
```

## Performance Tips

### Parallel Build
```bash
# Enable parallel build
mvn -T 4 clean install  # 4 threads
mvn -T 1C clean install # 1 thread per CPU core
```

### Offline Mode
```bash
# Build without checking for updates
mvn -o clean install
```

### Skip Unnecessary Goals
```bash
# Skip tests for quick build
mvn clean install -DskipTests

# Skip JavaDoc generation
mvn clean install -Dmaven.javadoc.skip=true
```

### Build Specific Modules
```bash
# Build specific module and its dependencies
mvn clean install -pl module1,module2 -am

# Build specific module without dependencies
mvn clean install -pl module1

# Build everything except specified modules
mvn clean install -pl !module1,!module2
```

### Maven Daemon (mvnd)
```bash
# Installation
mvn archetype:generate -DgroupId=com.example -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

## Debugging

### Debug Maven Build
```bash
# Debug Maven build process
mvn clean install -X

# Debug specific plugin
mvn clean install -Dmaven.plugin.name.debug=true
```

### Analyze Build Performance
```bash
# Build with time info
mvn clean install -T 1C -Dorg.slf4j.simpleLogger.showDateTime=true -Dorg.slf4j.simpleLogger.dateTimeFormat="HH:mm:ss.SSS"
```

## Custom Build Extensions

### Custom Plugins
```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.codehaus.mojo</groupId>
            <artifactId>exec-maven-plugin</artifactId>
            <version>3.1.0</version>
            <executions>
                <execution>
                    <id>run-script</id>
                    <phase>verify</phase>
                    <goals>
                        <goal>exec</goal>
                    </goals>
                    <configuration>
                        <executable>bash</executable>
                        <arguments>
                            <argument>-c</argument>
                            <argument>./post-build.sh</argument>
                        </arguments>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

### Build Extensions
```xml
<build>
    <extensions>
        <extension>
            <groupId>kr.motd.maven</groupId>
            <artifactId>os-maven-plugin</artifactId>
            <version>1.7.1</version>
        </extension>
    </extensions>
</build>
```