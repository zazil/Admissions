package edu.conncoll.banner.admissions.application

import edu.conncoll.banner.User

class TestService {

	def dataSource
	def springSecurityService
	
    def saveApprovedTestCategory( appl ){
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		if( appl ){
			try{
				return appl.saveApprovedTestCategory( user.username, dataSource )
				
			}catch( all ){
				return "err:Unable to save the approved test category! " + all.message
			}
		}else{
			return "err:Unable to save the tests!"
		}
	}
	
	def remove( appl, test ){
		if( appl && test ){
			try{
				return appl.removeTest( dataSource, test )
				
			}catch( all ){
				return "Unable to remove the " + test.code + " test! " + all.message 
			}
		}else{
			return "Unable to save the test!"
		}
	}
	
	def update( appl, test, newScore ){
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		if(appl && test){
			if((test.score as double) <= 0){
				this.remove(appl, test)
			}else{
				try{
					return appl.saveTest( user.username, dataSource, test, newScore )
					
				}catch( all ){
					return "Unable to update the " + test.code + " test!" + all.message
				}
			}
		}else{
			return "Unable to save the test!"
		}
	}
	
    def add(appl, test) {
		def user = User.findByUsername( springSecurityService.getPrincipal().username )

		if( appl && test ){
		
			if((test.score as double) <= 0){
				this.remove(appl, test)
			}else{
				try{
					def testType = TestTypeLkp.findById( test.code.trim() )
					//def newTest = new Test(category: test.category, code: test.code, date: test.date, score: test.score, applId: appl?.id)
					
					if( testType ){
						test.description = testType.description
						test.minScore = testType.minScore
						test.maxScore = testType.maxScore
						test.dataType = testType.dataType
					}else{
						return "Unable to find the Test Type!"
					}
					
					return appl.saveTest( user.username, dataSource, test, test.score )
					
				}catch( all ){
					return "Unable to add the " + test.code + " test! " + all.message
				}
			}
		}else{
			return "Unable to save the test!"
		}
    }
	
	def calculateACTComposite(appl){
		def combined = 0, testCount = 0, avg = 0
		def composite = 0, msg = ""
		
		try{
			//Loop through all the ACT scores and calculate an average
			appl?.tests?.findAll { it.code =~ /ACT\w*/ }?.each { act ->
				
				//If this isn't the composite value
				if(act.code != "ACT"){
					testCount++
					combined += act.score as double
				}else{
					composite = act.score as double
				}
				
			}
			
			if(combined > 0 && testCount > 0){
				avg = ((combined as double) / (testCount as int)).round(0)
			}
			
			//If the ACT average is greater than the composite, set the composite to the average
			if(avg > composite){
				//Delete the old composite
				msg = this.remove(appl, appl?.tests?.find { it.code == "ACT" })
				
				msg = this.add(appl, new Test(applId: 0,
												code: 'ACT',
												date: new Date(),
												category: 'ACT',
												score: (avg as int)))
				
				if( msg == "OK"){
					msg = avg
				}else{
					msg = null
				}
			}
		}catch(all){
			log.error "testService.calculateACTComposite: ${all.message}"
		}
		
		return msg
			
	}
	
	def getTestTypeList(tests) {
		//Get the Attribute types and remove any that are contained in the attr list passed in
		def testLkps = TestTypeLkp.list()
		
		tests.each { test ->
			def lkp = testLkps.find{ it.id == test.code && (test.score as double) > 0 }
			if(lkp){
				testLkps.remove(lkp)
			}
		}
		/*
		def testRemoves = []
		testLkps.each { test ->
			if(tests?.find{ it.code == test.id && (it.score as double) > 0 }){
				testRemoves.add(test)
			}
		}
		testRemoves.each {
			testLkps.remove(it)
		}*/
		
		return testLkps
	}
	
}
