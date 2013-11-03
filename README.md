#### About this demo applications:

**Tutorial**  
A tutorial is available for this demo at [keaplogik.blogspot.com](http://keaplogik.blogspot.com/2012/05/atmosphere-websockets-comet-with-spring.html).

**Frameworks**
* Spring MVC
* Atmosphere Framework https://github.com/Atmosphere/atmosphere
* Twitter/Spring social https://github.com/SpringSource/spring-social

**Purpose**
*To demo an implementation of Websockets and Comet, when working with an existing SpringMVC web application.*

This project was intended for testing on Tomcat 7.0.27 which was the only version of 
tomcat supporting websockets at the time this demo was created.

Configure your HTTP connector in Tomcat's conf/server.xml as such:

**Not Required for versions of Tomcat greater than 7.0.27**

```xml
<!-- Resolved an issue with http timeouts when using the tomcat comet adapter. Only an issue in Tomcat 7.0.27 --> 
<Connector port="8080" protocol="org.apache.coyote.http11.Http11NioProtocol"
               connectionTimeout="600000"
               redirectPort="8443" />
```

**Other Notes**
* **AJP protocol does not `currently` support websockets.**
* The Http11NioProtocol does not work with atmosphere unless you have a context.xml in META-INF/context.xml 
     in the following form. For Tomcat applications:

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <Context>
        <Loader delegate="true"/>
    </Context>
    ```

Steps for running on STS or Eclipse
-------------------------------------

I couldn't find a simple way to do this, but here it goes. I used STS. 

Pull down project from github like so:

1. go to File -> Import
2. Select Git -> Projects from Git -> Click Next
3. Select URI -> Click Next
4. URI: https://github.com/keaplogik/springMVC-atmosphere-comet-websockets.git
Host: github.com
Click Next
5. Click Next
6. Specify destination -> Click Next
7. Click Cancel

Now Import the project as a Maven Project like so:

1. File -> Import
2. Maven -> Existing Maven Projects -> Click Next
3. In "Root Directory" Browse to this projects folder
4. Click Finish

Now Add the Tomcat Server:

1. In the Package Explorer -> Right click on Servers -> New -> Other
2. Click Server-> Server -> Click Next
3. Chooses Apache Tomcat 7.0 Server -> Click Next
4. Browse to where you installed Tomcat 7.0.27 or newer -> Click Finish
5. If you haven't downloaded Tomcat here is the link: http://apache.mirrors.tds.net/tomcat/tomcat-7/v7.0.34/bin/apache-tomcat-7.0.34.zip

Finally Run on the Tomcat server

1. Right click on the project in the project explorer. Click Run as -> Run on Server
2. Click the Tomcat Server, and click Finish.

And your up and running!
