package edu.conncoll.banner.admissions.applicant

import groovy.sql.Sql

/*
 * Object representing an interview with the Applicant. Each applicant
 * can have many Interviews. 
 *
 * See the Interview.hbm.xml file for DB mappings
 *
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 */

class Interview implements Serializable {

	long pidm
	String type
	Date date
	
	String typeDescription
	long time
	String result
	String resultDescription
	String recruiter
	String recruiterName
	
	public String toString(){
		"Interview [type: " + type + ", typeDescription: " + typeDescription + ", date: " + date + 
		", time: " + time + ", result: " + result + ", resultDescription: " + resultDescription + 
		", recruiter: " + recruiter + ", recruiterName: " + recruiterName + "]"
	}
	
	static saveInterviews(dataSource, pidm, interviews){
		def ret = ""
		
		def db = new Sql( dataSource )
		
		try{
			//Gather the valid interview types so that we don't delete any that we shouldn't!!
			def interviewTypes = InterviewTypeLkp.list()
			def where = ""
			interviewTypes.each { type ->
				where += "'${type.id}', "
			}
			where = where[0..where.size() - 3]
			
			//Blanket delete because changing an interview changes its underlying Pkey
			db.execute("DELETE FROM saturn.sorappt WHERE sorappt_pidm = ? AND sorappt_ctyp_code IN (${where}) ", [pidm])
			
			interviews.each{ interview ->
				db.execute("INSERT INTO saturn.sorappt (sorappt_pidm, sorappt_contact_date, sorappt_contact_from_time, sorappt_contact_to_time, sorappt_ctyp_code, sorappt_recr_code, sorappt_rslt_code, sorappt_activity_date) VALUES (?, ?, ?, ?, ?, ?, ?, sysdate) ",
						[pidm, new java.sql.Date( interview.date.getTime() ), interview.time, 1000, interview.type, interview.recruiter, interview.result])
			}
			
			ret = "OK"
		}catch(all){
			ret = "An error occured while saving your interviews! ${all.message}"
		}
		
		return ret
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((date == null) ? 0 : date.hashCode());
		result = prime * result + (int) (pidm ^ (pidm >>> 32));
		result = prime * result + ((type == null) ? 0 : type.hashCode());
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
		Interview other = (Interview) obj;
		if (date == null) {
			if (other.date != null)
				return false;
		} else if (!date.equals(other.date))
			return false;
		if (pidm != other.pidm)
			return false;
		if (type == null) {
			if (other.type != null)
				return false;
		} else if (!type.equals(other.type))
			return false;
		return true;
	}
}
