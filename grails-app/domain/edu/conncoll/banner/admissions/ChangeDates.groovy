package edu.conncoll.banner.admissionsimport java.io.Serializable;
import java.util.Date;


class ChangeDates implements Serializable {
	String term
	String admit
	
	Date start
	Date end
		public String getId(){		return "${term} ${admit}"	}	public String toString(){		return getId()	}	
	static mapping = {
		table			"CC_WRKCRD_DATES_VW"
		version			false
		cache			"read-only"
		
		id				composite: ['term', 'admit'], generator: "assigned"		
		term			column: "term"
		admit			column: "admtype"
		start			column: "startdate"
		end				column: "enddate"
	}	
		
}
