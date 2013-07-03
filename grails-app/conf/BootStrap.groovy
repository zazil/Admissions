import edu.conncoll.banner.admissions.Settings

class BootStrap {

    def init = { servletContext ->
		
		println "Loading application settings from CC_WRKCRD_SETTINGS ..."
		new Settings()
		
    }
    def destroy = {
    }
}
