package edu.conncoll.banner.admissions

/*
 * Object representing an Applicant to the college. 
 *
 * See the Person.hbm.xml file for DB mappings
 * 
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 */

import java.util.Map;

import edu.conncoll.banner.Person

class Applicant extends Person {
    String gender
	String citizenshipCode
	
	Set addresses
	Set telephones
	Set legacies
	Set interviews
	Set contacts
	
	public String toString(){
		"Applicant [gender: " + gender + ", citizenshipCode: " + citizenshipCode + "]"
	}
	
    static constraints = {
		pidm				nullable: false, unique: true
		gender				nullable: true
		citizenshipCode		nullable: true
		
		addresses			nullable: true
		telephones			nullable: true
    }
	
}
