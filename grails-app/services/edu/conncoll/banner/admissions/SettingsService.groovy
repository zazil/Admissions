package edu.conncoll.banner.admissions

/*
 * Service that allows us to treat the Settings domain as a Singleton
 *
 * The domain behind this service should only ever have one record so we
 * should treat it as a singleton that gets initialized when the application
 * starts up. When using this service you should refer to it as:
 *
 *     settingsService.instance?.[parameter]
 */
class SettingsService {

    static transactional = true
	
	def instance = {
		return Settings.list()[0]
	}
}
