package edu.conncoll.banner.admissions.application

/* 
 * Object representing the Banner Application checklist. An
 * application will have many checklist items
 * 
 * Mapping info can be found in ChecklistItem.hbm.xml
 * 
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run.
 */

import java.util.Date;
import groovy.sql.Sql

class ChecklistItem {

	long applId
	
	String type
	String description
	String mandatory
	Date receivedOn
	String comment

	def saveItem(dataSource, pidm, term, appl_no ) {
		def ret = ""
		
		try{
			def db = new Sql( dataSource )
			
			db.executeUpdate( "UPDATE saturn.sarchkl " +
								"SET sarchkl_receive_date = ?, sarchkl_comment = ?, sarchkl_activity_date = ?, sarchkl_mandatory_ind = ? " +
								"WHERE sarchkl_admr_code = ? and sarchkl_pidm = ? and sarchkl_term_code_entry = ? " +
								"and sarchkl_appl_no = ?", 
								[(this.receivedOn) ? new java.sql.Date(this.receivedOn?.getTime()) : null, 
								 this.comment, 
								 new java.sql.Date(new Date().getTime()),
								 this.mandatory, 
								 this.type,
								 pidm, term, appl_no] )
					
			db.commit()
			
			ret = "OK"
			
		}catch( all ){
			log.error "ChecklistItem.saveItem() - ${all.message}\n\t" +
						"pidm: ${pidm}, term: ${term}, appl: ${appl_no}"
						
			ret = "Unable to save your checklist changes. "
		}
		
		return ret
	}
}
