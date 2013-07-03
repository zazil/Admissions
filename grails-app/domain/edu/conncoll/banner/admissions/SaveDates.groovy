package edu.conncoll.banner.admissions
import java.io.Serializable;
class SaveDates implements Serializable {
	String	term
	String	admit
	Date	start
	Date	end
	
	/*Zazil. Since I am defining a subclass, it is recommended that the java
	 * toString method be overriden here to return...*/
	@Override	
	public String toString(){
		return getId()
	}	
	public String getId(){
		 return "${term} ${admit}"
	}
	 
    static constraints = {
		term	blank: false
		admit	blank: false
		start	blank: false
		end		blank: false
	 }
		
	static mapping = {
		table	'CC_WRKCRD_TERM_ADMT_DEFS'	
		version	false
		id		composite: ['term','admit'], generator: 'assigned'
		
		term	column:'TERM'
		admit	column:'ADMT' 
		
		start	column:'START_DATE'
		end		column:'END_DATE'

	}
}