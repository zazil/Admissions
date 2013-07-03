package edu.conncoll.banner.admissions.application

import edu.conncoll.banner.User

class NoteService {

    static transactional = true
	
	def dataSource
	
	def save(user, applId, id, type, identifier, content){
		
		//Don't save an empty note!
		if(content){
			def note = (id != 0) ? Note.findById(id) : new Note(applId: applId as long, 
																type: type, 
																identifier: identifier, 
																content: content)
			
			if(note){
				log.debug "NoteService.save - Appl: applId, Type: ${note.type}, Identitifer: ${note.identifier}"
				
				try{
					//If this isn't a new note, update the identifier and content
					if(id != 0){
						note.identifier = identifier ?: " "
						note.identifierDescription = " "
						note.content = content ?: " "
					}
					
					//If the note identifier is null just set it to blank to prevent null value error from DB
					if( !note.identifier ) { note.identifier = " " }
					if( !note.identifierDescription ) { note.identifierDescription = " " }
					
					def dt = new Date()
					
					//If the note was not found, create a new one, otherwise just update it.
					if( id == 0 ){
						note.creator = user
						note.createdOn = dt
					}else{
						note.updater = user
						note.updatedOn = dt
					}
					
					//Save the note
					if(note.save(flush: true, failOnError: true)){
						//If this is a new note we need to remove the one currently in the session
						//because if there are multiples it will complain because they're all id == 0
						if(id == 0){
							Note.withSession { session ->
								session.evict(note)
							}
						}
						
						return "OK"
					}else{
						return "Unable to save your note!"
					}
					
				}catch(all){
					log.error "NoteService.save() - ${all.message}\n\t" +
								"User: ${user}\n\t" +
								"Appl: ${applId}\n\t" +
								"Note: ${id}\n\t" +
								"Type: ${type}, Identifier: ${identifier}, Content: ${content}"
					return "Unable to save the note!"
				}
			}else{
				return "Note not found!"
			}
		}
	}
	
	//Delete the specified note
	def delete( note ){
		try{
			log.debug "NoteService.delete - Appl: applId, Note: ${note.id}"
			
			/* If this isn't a new note */
			if( note?.id != 0 ){
				note.delete( flush: true, failOnError: true )
			}
			return "OK"
		}catch( all ){
			log.error "NoteService.delete - Appl: applId, Note: ${note.id} - ${all.message} "
			return "There was a problem trying to delete your comment."
		}
	}
	
}
