package edu.conncoll.banner.admissions

import grails.util.Environment

class ErrorController {

    def forbidden = {
		if( Environment.current == Environment.DEVELOPMENT ){
			render view: '/errorDev'
		}else{
			render view: '/error', model: [message: 'You do not have access to this page!']
		}
	}
	
	def notFound = {
		if( Environment.current == Environment.DEVELOPMENT ){
			render view: '/errorDev'
		}else{
			render view: '/error', model: [message: 'The page you were looking for could not be found!']
		}
	}
		
	def notAllowed = {
		if( Environment.current == Environment.DEVELOPMENT ){
			render view: '/errorDev'
		}else{
			render view: '/error', model: [message: 'You do not have access to this page!']
		}
	}
	
    def internalError = {
		if( Environment.current == Environment.DEVELOPMENT ){
			render view: '/errorDev'
		}else{
			render view: '/error', model: [message: 'Oops, it looks like the server had a problem. Please try refreshing the page in your browser!']
		}
	}
}
