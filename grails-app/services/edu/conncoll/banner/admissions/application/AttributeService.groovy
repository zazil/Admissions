package edu.conncoll.banner.admissions.application

import edu.conncoll.banner.admissions.Application

class AttributeService {

    static transactional = true
	
	def dataSource
	
	def save( appl, attrs ) {
		def ret = ""
		
		if( appl instanceof Application ){
			
			try{
				/* delete all of the attributes on the application */
				appl.removeAttributes( dataSource )
						
				/* add all of the attributes that are in the collection */
				attrs.each {
					appl.addAttribute( dataSource, it.code.toString() )
				}
				
				ret = "OK"
			}catch( all ){
				ret = "Unable to save your changes: " + all.class + " - " + all.message + "<br/>" + all.stackTrace
			}
		}else{
			ret = "No application was defined!"
		}
		
		return ret
	}
	
	def getAttributeTypeList(attrs) {
		//Get the Attribute types and remove any that are contained in the attr list passed in
		def attrLkps = AttributeTypeLkp.list()
		def attrRemoves = []
		
		//For some reason this is causing a major slowdown in page loads
		attrLkps.each { attr ->
			if(attrs?.find{ it.code == attr.id }){
				attrRemoves.add(attr)
			}
		}
		
		attrRemoves.each {
			attrLkps.remove(it)
		}
		
		return attrLkps
	}
}
