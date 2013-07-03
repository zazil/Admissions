package edu.conncoll.banner

class Telephone {
	long id
	
		String type
		String phone
		
		public String toString() {
			"Telephone [id: " + id + ", type: " + type + ", phone: " + phone + "]"
		}
		
		static constraints = {
			id			nullable: false, unique: true
	
			type		blank: false
			
			phone		nullable: true, minSize: 7
		}
}
