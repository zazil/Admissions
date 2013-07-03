class UrlMappings {

	static mappings = {

		"/$controller/$action?/$id?"{
			constraints {
				// apply constraints here
			}
		}

		"/"( controller: "application", action: "index" )
		
		
		
		"403" (controller: "error", action: "forbidden")
		"404" (controller: "error", action: "notFound")
		"405" (controller: "error", action: "notAllowed")
		"500" (controller: "error", action: "internalError")
	}
}
