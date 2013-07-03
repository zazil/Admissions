// locations to search for config files that get merged into the main config;
// config files can be ConfigSlurper scripts, Java properties files, or classes
// in the classpath in ConfigSlurper format

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if (System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }

grails.project.groupId = appName // change this to alter the default package name and Maven publishing destination
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = false
grails.mime.types = [
    all:           '*/*',
    atom:          'application/atom+xml',
    css:           'text/css',
    csv:           'text/csv',
    form:          'application/x-www-form-urlencoded',
    html:          ['text/html','application/xhtml+xml'],
    js:            'text/javascript',
    json:          ['application/json', 'text/json'],
    multipartForm: 'multipart/form-data',
    rss:           'application/rss+xml',
    text:          'text/plain',
    xml:           ['text/xml', 'application/xml']
]

// URL Mapping Cache Max Size, defaults to 5000
//grails.urlmapping.cache.maxsize = 1000

// What URL patterns should be processed by the resources plugin
grails.resources.adhoc.patterns = ['/images/*', '/css/*', '/js/*', '/plugins/*']

// The default codec used to encode data with ${}
grails.views.default.codec = "none" // none, html, base64
grails.views.gsp.encoding = "UTF-8"
grails.converters.encoding = "UTF-8"
// enable Sitemesh preprocessing of GSP pages
grails.views.gsp.sitemesh.preprocess = true
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'

// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder = false
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true
// packages to include in Spring bean scanning
grails.spring.bean.packages = []
// whether to disable processing of multi part requests
grails.web.disable.multipart=false

// request parameters to mask when logging exceptions
grails.exceptionresolver.params.exclude = ['password']

// configure auto-caching of queries by default (if false you can cache individual queries with 'cache: true')
grails.hibernate.cache.queries = false

environments {
    production {
        grails.serverURL = "https://prodapps.conncoll.edu"
    }
    development {
        grails.serverURL = "http://localhost:8080/${appName}"
    }
    test {
        grails.serverURL = "http://testapps.conncoll.edu/${appName}"
    }
}

// log4j configuration
log4j = {

	//disable stacktrace file
	'null' name:'stacktrace'
		
	environments{
		production {
			appenders {
				rollingFile name:'appLog', file:'/var/log/tomcat6/admissions.log', maxFileSize:1024
			}
			
			error 	'org.codehaus.groovy.grails.web.servlet',  //  controllers
					'org.codehaus.groovy.grails.web.pages', //  GSP
					'org.codehaus.groovy.grails.web.sitemesh', //  layouts
					'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
					'org.codehaus.groovy.grails.web.mapping', // URL mapping
					'org.codehaus.groovy.grails.commons', // core / classloading
					'org.codehaus.groovy.grails.plugins', // plugins
					'org.codehaus.groovy.grails.orm.hibernate', // hibernate integration
					'org.codehaus.groovy.grails.webflow', // webflow
					'org.springframework',
					'org.hibernate',
					'net.sf.ehcache.hibernate',
					'edu.conncoll.banner',
					'groovy.sql'
					
			root {
				error 'appLog'
				additivity = true
			}
		}
		test {
			appenders {
				rollingFile name:'appLog', file:'/var/log/tomcat6/admissions.log', maxFileSize:1024
			}
			
			error 	'org.codehaus.groovy.grails.web.servlet',  //  controllers
					'org.codehaus.groovy.grails.web.pages', //  GSP
					'org.codehaus.groovy.grails.web.sitemesh', //  layouts
					'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
					'org.codehaus.groovy.grails.web.mapping', // URL mapping
					'org.codehaus.groovy.grails.commons', // core / classloading
					'org.codehaus.groovy.grails.plugins', // plugins
					'org.codehaus.groovy.grails.orm.hibernate', // hibernate integration
					'org.codehaus.groovy.grails.webflow', // webflow
					'org.springframework',
					'org.hibernate',
					'net.sf.ehcache.hibernate',
					'edu.conncoll.banner',
					'groovy.sql'
			
			warn   	'org.mortbay.log',
					'grails.app'
					
			root {
				error 'appLog'
				additivity = true
			}
		}
		
		development {
			appenders {
				//console name:'stdout', threshold: org.apache.log4j.Level.DEBUG
				rollingFile name:'appLog', file:'/Users/shared/logs/admissions.log', maxFileSize:1024
			}
			error 	'org.codehaus.groovy.grails.web.servlet',  //  controllers
					'org.codehaus.groovy.grails.web.pages', //  GSP
					'org.codehaus.groovy.grails.web.sitemesh', //  layouts
					'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
					'org.codehaus.groovy.grails.web.mapping', // URL mapping
					'org.codehaus.groovy.grails.commons', // core / classloading
					'org.codehaus.groovy.grails.plugins', // plugins
					'org.codehaus.groovy.grails.orm.hibernate', // hibernate integration
					'org.codehaus.groovy.grails.webflow', // webflow
					'org.springframework',
					'org.hibernate',
					'net.sf.ehcache.hibernate',
					'edu.conncoll.banner',
					'groovy.sql'
			
			warn   	'org.mortbay.log',
					'grails.app'
			
			info	'groovy.sql',
					'com.linkedin.grails'
			
			debug  	'edu.conncoll.banner',
					 'edu.conncoll.banner.admissions',
					'org.codehaus.groovy.grails.webflow',
					'groovy.sql'
		}
	}

}

// Added by the Spring Security Core plugin:
grails.plugins.springsecurity.userLookup.userDomainClassName = 'edu.conncoll.banner.User'
grails.plugins.springsecurity.userLookup.authorityJoinClassName = 'edu.conncoll.banner.UserRole'
grails.plugins.springsecurity.authority.className = 'edu.conncoll.banner.Role'

/*
 * CAS integration parameters allow us to defer authentication to CAS
 *
 * to install:
 *     1) From a Grails prompt run 'install-plugin spring-security-cas'
 *     2) Delete the Login/LogoutController created by the spring-security-core install
 *     3) Delete the views/login/auth view created by the spring-security-core install
 *
 * To uninstall:
 *     1) From a Grails prompt run 'uninstall-plugin spring-security-cas'
 */
 environments {
	 production {
		 grails.plugins.springsecurity.cas.serviceUrl = 'https://prodapps.conncoll.edu/Admissions/j_spring_cas_security_check'
		 //Added to handle redirect loop issue when deployed within a load balanced environment
		 grails.plugins.springsecurity.cas.redirectAfterValidation = 'false'
	 }
	 development {
		  grails.plugins.springsecurity.cas.serviceUrl = 'http://localhost:8080/Admissions/j_spring_cas_security_check'
		 //Ted's iMac
		 //grails.plugins.springsecurity.cas.serviceUrl = 'http://136.244.213.84:8080/Admissions/j_spring_cas_security_check'
	 }
	 test {
		 grails.plugins.springsecurity.cas.serviceUrl = 'http://testapps.conncoll.edu/Admissions/j_spring_cas_security_check'
		 //Added to handle redirect loop issue when deployed within a load balanced environment
		 grails.plugins.springsecurity.cas.redirectAfterValidation = 'false'
	 }
 
 }
 
 grails.plugins.springsecurity.cas.loginUri = '/login'
 grails.plugins.springsecurity.cas.serverUrlPrefix = 'https://cas.conncoll.edu/cas'
 grails.plugins.springsecurity.cas.proxyReceptorUrl = '/secure/receptor'
 
 grails.plugins.springsecurity.cas.useSingleSignout = true
 grails.plugins.springsecurity.cas.sendRenew = false
 grails.plugins.springsecurity.cas.key = 'edu-conncoll-admissions-wrkcrd'
 grails.plugins.springsecurity.cas.artifactParameter = 'ticket'
 grails.plugins.springsecurity.cas.serviceParameter = 'service'
 grails.plugins.springsecurity.cas.filterProcessesUrl = '/j_spring_cas_security_check'