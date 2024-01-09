# Maven Hello World

Getting started with Maven Release Plugin and Github Action

## Links

Login to your [sonatype](https://s01.oss.sonatype.org/) account to release the version

| Type     | URL                                                                                                     | Description                |
|:---------|:--------------------------------------------------------------------------------------------------------|:---------------------------|
| Snapshot | [sonatype](https://s01.oss.sonatype.org/content/repositories/snapshots/com/chensoul/maven-hello-world/) | Sonatype Snapshot versions |
| Release  | [maven](https://repo.maven.apache.org/maven2/com/chensoul/maven-hello-world/)                           | Maven Release versions     |
| Release  | [central-sonatype](https://central.sonatype.com/artifact/com.chensoul/maven-hello-world/)               | Sonatype Release versions  |

## Documentation

* Well explained blog
  of [How to Publish Artifacts to Maven Central](https://dzone.com/articles/how-to-publish-artifacts-to-maven-central)
* Your Sonatype account [link](https://s01.oss.sonatype.org/)
* Your Jira ticket login [link](https://issues.sonatype.org/)
* Github action to import gpg:
    * [link1](https://github.com/actions/setup-java/blob/ddb82ce8a6ecf5ac3e80c3184839e6661546e4aa/docs/advanced-usage.md?plain=1#L315)
    * [link2](https://github.com/hashicorp/ghaction-import-gpg)
    * [link3](https://github.com/crazy-max/ghaction-import-gpg/tree/master)

## Secrets

* **GPG_PRIVATE_KEY** - Take it from the private.gpg
* **OSSRH_USERNAME** - Created [here](https://issues.sonatype.org/)
* **OSSRH_TOKEN** - Created [here](https://issues.sonatype.org/)
* **GPG_PASSPHRASE** - Create [here](https://central.sonatype.org/publish/requirements/gpg/#generating-a-key-pair)
    * This passphrase and your private key are all that is needed to sign artifacts with your signature.
* **GITHUB_TOKEN** - Github token

## Demo

How do you release a version?

Manually:\
&nbsp;&nbsp;&nbsp;1. Check the version in the pom.xml\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* **<version>0.0.1-SNAPSHOT</version>**\
&nbsp;&nbsp;&nbsp;2. Go to Github action -> Run workflow\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* **Release:** 0.0.1\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* **Snapshot:** 0.0.2-SNAPSHOT

Automatically:\
Push to Github will create a release and a snapshot but it won't publish the release.\
Snapshot will be available through [here](https://central.sonatype.com/artifact/com.chensoul/maven-hello-world/0.0.1)

```bash
<dependency>
    <groupId>com.chenspoul</groupId>
    <artifactId>maven-hello-world</artifactId>
    <version>0.0.1</version>
</dependency>
```

## Maven in 5 Minutes

Follow after the documentation [here](https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html) to
start your first maven.

Expend your `./src/main/java/com/mycompany/app/App.java` with:

```bash
package com.mycompany.app;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class App {
    public static void main( String[] args ) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress(8080), 0);
        server.createContext("/", new MyHandler());
        server.setExecutor(null); // creates a default executor
        server.start();
    }

    static class MyHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange t) throws IOException {
            String response = "<h1> Hello World! </h1>";
            t.sendResponseHeaders(200, response.length());
            OutputStream os = t.getResponseBody();
            os.write(response.getBytes());
            os.close();
        }
    }
}
```

## GPG

After generating gpg key following
by [here](https://central.sonatype.org/publish/requirements/gpg/#generating-a-key-pair)

```bash
gpg --gen-key
```

You can list the local key that you created:

```bash
gpg --list-secret-keys --keyid-format=long
```

Then you can export the private key to your local machine in order to upload it later to Github secret:

```bash
gpg --armor --export-secret-keys <YOUR_KEY> > private.gpg
```

* YOUR_KEY='long number'

## Local commands

Check your maven settings file `～/.m2/settings.xml`:

```bash
    <server>
        <id>gpg.passphrase</id>
        <passphrase><PASSPHRASE_GPG></passphrase>
    </server>
    <server>
        <id>ossrh</id>
        <username><OSSRH_USERNAME></username>
        <password><OSSRH_TOKEN></password>
    </server>
```

According to [publish-maven](https://central.sonatype.org/publish/publish-maven/), you can do these as below.

### Performing a Snapshot Deployment

Snapshot deployment are performed when your version ends in -SNAPSHOT . You do not need to fulfill the requirements when
performing snapshot deployments and can simply run

```bash
mvn -B clean deploy
```

SNAPSHOT versions are not synchronized to the Central Repository. If you wish your users to consume your SNAPSHOT
versions, they would need to add the snapshot repository to their Nexus Repository Manager, settings.xml, or pom.xml.
Successfully deployed SNAPSHOT versions will be found in https://s01.oss.sonatype.org/content/repositories/snapshots/

### Performing a Release Deployment

In order to perform a release deployment you have to edit your version in all your POM files to use release versions.

```bash
mvn versions:set -DnewVersion=1.2.3 versions:commit
```

Install to local repository `~/.m2/repository`:

```bash
mvn clean install
```

Release to the staging repositorywith the release profile:

```bash
mvn clean deploy -P release
```

And then login to the staging repository https://s01.oss.sonatype.org/#stagingRepositories , release and drop the repository.
Wait a few minutes and then you can find the release version in https://central.sonatype.com/artifact/com.chensoul/maven-hello-world/
or https://s01.oss.sonatype.org/service/local/repositories/releases/content/com/chensoul/maven-hello-world/ .


### Manually Publish the site to github pages

Publish to github pages:

```bash
mvn clean site scm-publish:publish-scm
```