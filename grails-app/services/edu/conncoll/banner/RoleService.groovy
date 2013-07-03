package edu.conncoll.banner

class RoleService {

	def dataSource
	def springSecurityService
	
	//Loops through the current user's roles to see if they have the one specified
    private boolean isRole( roleIn ){
		def user = User.findByUsername( springSecurityService.getPrincipal().username)
		def ret = false
		
		user.getAuthorities().each(){ role ->  
			if( role.authority == roleIn || role.authority == 'ROLE_ADMIN' )  //Admin always has authority!
				ret = true		
		}
		
		return ret
	}
	
	//Retrieve the list of users associated with the specified role. Needed to retrieve 2nd Reader list
	def getUsersForRole( roleIn ){
		 return Role.findByAuthority( roleIn.encodeAsHTML().trim() ).listUsers( dataSource )
	}
}
