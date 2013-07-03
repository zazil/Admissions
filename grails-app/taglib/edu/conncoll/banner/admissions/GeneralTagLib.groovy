package edu.conncoll.banner.admissions

class GeneralTagLib {
	static namespace = "general"
	
	/**
	 * An email input box
	 * 
	 * @name REQUIRED the name of the field
	 * @value REQUIRED the value of the field
	 * 
	 * @classes optional classes as a string of class values separated by a space
	 * @maxLength optional size of value allowed in field
	 * 
	 * @onkeypress optional javascript for the onKeypress event
	 * @onchange optional javascript for the onChange event
	 * @onclick optional javascript for the onClick event
	 */
	def email = { attrs, body ->
		def evalJS = "if(!validateEmail(\$(this).val())){ \$('#" + attrs.name + "Message').html('Invalid email'); }else{ \$('#" + attrs.name + "Message').html(''); }"
		
		out << textbox(name: attrs.name,
						value: attrs.value,
						class: attrs.classes ?: "",
						maxLength: attrs.maxLength,
						onkeypress: evalJS + (attrs.onkeypress ?: ""),
						onchange: attrs.onchange ?: "",
						onclick: attrs.onclick ?: "")
	}
	
	/**
	 * An URL input box
	 * 
	 * @name REQUIRED the name of the field
	 * @value REQUIRED the value of the field
	 * 
	 * @classes optional classes as a string of class values separated by a space
	 * @maxLength optional size of value allowed in field
	 * 
	 * @onkeypress optional javascript for the onKeypress event
	 * @onchange optional javascript for the onChange event
	 * @onclick optional javascript for the onClick event
	 */
	def url = { attrs, body ->
		def evalJS = "if(!validateUrl(\$(this).val())){ \$('#" + attrs.name + "Message').html('Invalid URL'); }else{ \$('#" + attrs.name + "Message').html(''); }"
		
		out << textbox(name: attrs.name,
						value: attrs.value,
						class: attrs.classes ?: "",
						maxLength: attrs.maxLength,
						onkeypress: evalJS + (attrs.onkeypress ?: ""),
						onchange: attrs.onchange ?: "",
						onclick: attrs.onclick ?: "")
	}
	
	/**
	 * An normal input text field
	 *
	 * @name REQUIRED the name of the field
	 * @value REQUIRED the value of the field
	 *
	 * @classes optional classes as a string of class values separated by a space
	 * @maxLength optional size restriction for the field
	 * 
	 * @onkeypress optional javascript for the onKeypress event
	 * @onchange optional javascript for the onChange event
	 * @onclick optional javascript for the onClick event
	 */
	def textbox = { attrs, body ->
		out << g.textField(name: attrs.name,
							value: attrs.value,
							class: attrs.classes ?: "",
							maxLength: attrs.maxLength,
							onkeypress: attrs.onkeypress ?: "",
							onchange: attrs.onchange ?: "",
							onclick: attrs.onclick ?: "")

		out << "<span id='${attrs.name}Message' class='error'></span>"
	}
	
	/**
	 * Ensures that only a numeric value can be entered
	 * 
	 * @name REQUIRED the name of the field
	 * @value REQUIRED the value of the field
	 * 
	 * @classes optional classes as a string of class values separated by a space
	 * @maxLength optional size of value allowed in field
	 * 
	 * @onkeypress optional javascript for the onKeypress event
	 * @onchange optional javascript for the onChange event
	 * @onclick optional javascript for the onClick event
	 */
	def numeric = { attrs, body ->
		out << textbox(name: attrs.name,
						value: attrs.value,
						class: attrs.classes ?: "",
						maxLength: attrs.maxLength,
						onchange: attrs.onchange ?: "",
						onclick: attrs.onclick ?: "")
		
		out << "<script type='text/javascript'>" +
					"\$('#${attrs.name}').live( 'keydown', function( e ){" +
						"isNumeric(e);" +
					"});" +
					(attrs.onkeypress ?: "") +
				"</script>"
	}
}
