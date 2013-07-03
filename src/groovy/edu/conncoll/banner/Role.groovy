package edu.conncoll.banner

/*
 * Object representing the user's roles as defined in Workflow
 *
 * WARNING: Do NOT delete or rename the authority variable as it
 * 			could render the spring-security-core plugin inoperable
 *
 * TODO: Move the direct sql to standard GORM query once the object 
 * 		 has been converted to a standard GORM object
 * 
 * See the Role.hbm.xml file for DB mappings
 */

import groovy.sql.Sql
import java.util.Set;

class Role {
	long id
	String authority

	static constraints = {
		id			nullable: false, unique: true
		authority 	blank: false, unique: true
	}
	
	/* Function to retrieve the list of usernames associated with the specified Role */
	def listUsers( dataSource ){
		try{
			def db = new Sql( dataSource )
			
			Set users = []
			
			db.eachRow( 'select user_id from wrkcrd.cc_wrkcrd_ban_user_role_vw where role_id = ' + this.id ){
				row ->
					users.add( User.get( row.user_id ) )
			}
			
			return users
			
		}catch( Exception e ){
			throw e
		}
	}
	
	public String toString(){
		"Role [id: " + id + ", authority: " + authority + "]"
	}
}
