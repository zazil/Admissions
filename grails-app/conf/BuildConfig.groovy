grails.servlet.version = "2.5" // Change depending on target container compliance (2.5 or 3.0)
grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.project.target.level = 1.6
grails.project.source.level = 1.6
//grails.project.war.file = "target/${appName}-${appVersion}.war"

grails.project.dependency.resolution = {
    // inherit Grails' default dependencies
    inherits("global") {
        // specify dependency exclusions here; for example, uncomment this to disable ehcache:
        // excludes 'ehcache'
    }
    log "warn" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
    checksums true // Whether to verify checksums on resolve

    repositories {
        inherits true // Whether to inherit repository definitions from plugins

        grailsPlugins()
        grailsHome()
        grailsCentral()

        mavenLocal()
        mavenCentral()
    }
    dependencies {
        // specify dependencies here under either 'build', 'compile', 'runtime', 'test' or 'provided' scopes eg.

        // runtime 'mysql:mysql-connector-java:5.1.20'
    }

    plugins {
		//Core grails required plugins
		compile ':cache:1.0.0'
        
		runtime ":hibernate:$grailsVersion"
        runtime ":resources:1.1.6"
		runtime ":database-migration:1.1"
		
		build ":tomcat:$grailsVersion"
		
		//Application specific plugins
		compile ":jquery:latest.integration",
				":blueprint:latest.integration",
				":jquery-ui:latest.integration",
				":jqueryui-widget:latest.integration",
				":spring-security-core:latest.integration",
				":spring-security-cas:latest.integration",
				":wslite:latest.integration"
    }
}
