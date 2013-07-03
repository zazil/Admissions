package edu.conncoll.banner.admissions.application

import groovy.sql.Sql

/*
 * Object representing an Applicant's intended majors. Each Application
 * may have many Majors.
 *
 * See the Major.hbm.xml file for DB mappings
 *
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 */

class Major implements Serializable{

	//long pidm
	long applId
	String code
	String description
	int priority

	@Override
	public String toString(){
		"Major [code: " + code + ", description: " + description + ", priority: " + priority + "]"	
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((code == null) ? 0 : code.hashCode());
		result = prime * result + (int) (applId ^ (applId >>> 32));
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Major other = (Major) obj;
		if (code == null) {
			if (other.code != null)
				return false;
		} else if (!code.equals(other.code))
			return false;
		if (applId != other.applId)
			return false;
		return true;
	}	
	
}
