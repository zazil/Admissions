dataSource {
    pooled = true
    driverClassName = "oracle.jdbc.driver.OracleDriver"
	dialect = "org.hibernate.dialect.Oracle10gDialect"
	username = "wrkcrd"
	password = "cc-irene11"
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = true
    cache.region.factory_class = 'net.sf.ehcache.hibernate.EhCacheRegionFactory'
	flush.mode = "commit"
}
// environment specific settings
environments {
    development {
        dataSource {
			//Zazil 5/15 DEV is down
			//url = "jdbc:oracle:thin:@lily.conncoll.edu:1522:TEST"
			url = "jdbc:oracle:thin:@lily.conncoll.edu:1522:DEV"
			//This logSql statement shows on the console every query/command it is executed on the database
			logSql = true
        }
    }
    test {
        dataSource {
            url = "jdbc:oracle:thin:@lily.conncoll.edu:1522:TEST"
			
			pooled = true
			properties {
			   maxActive = -1
			   minEvictableIdleTimeMillis=1800000
			   timeBetweenEvictionRunsMillis=1800000
			   numTestsPerEvictionRun=3
			   testOnBorrow=true
			   testWhileIdle=true
			   testOnReturn=true
			   validationQuery="SELECT 1 FROM dual"
			}
        }
    }
    production {
        dataSource {
            url = "jdbc:oracle:thin:@rose.conncoll.edu:1521:CONN"
			
            pooled = true
            properties {
               maxActive = -1
               minEvictableIdleTimeMillis=1800000
               timeBetweenEvictionRunsMillis=1800000
               numTestsPerEvictionRun=3
               testOnBorrow=true
               testWhileIdle=true
               testOnReturn=true
               validationQuery="SELECT 1 FROM dual"
            }
        }
    }
}
