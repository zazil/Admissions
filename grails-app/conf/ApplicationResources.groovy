modules = {
    application {
        resource url:'js/application.js'
    }
	
	overrides {
		'jquery-theme' {
			resource id:'theme', url:'/css/smoothness/jquery-ui-1.8.24.custom.css'
		}
	}
}