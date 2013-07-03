if (typeof jQuery !== 'undefined') {
	(function($) {
		$('#spinner').ajaxStart(function() {
			$(this).fadeIn();
		}).ajaxStop(function() {
			$(this).fadeOut();
		});
	})(jQuery);
}

function validateEmail(email){
	var pattern = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
	return pattern.test(email);
}

function validateUrl(url){
	var pattern = /^(?:([A-Za-z]+):)?(\/{0,3})([0-9.\-A-Za-z]+)(?::(\d+))?(?:\/([^?#]*))?(?:\?([^#]*))?(?:#(.*))?$/;
	return pattern.test(url);
}

function isNumeric(event){
	if( event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || 
		event.keyCode == 190 || event.keyCode == 110 || event.keyCode == 37 || 
		event.keyCode == 38 || event.keyCode == 39 || event.keyCode == 40 ){
		//allow specific charcaters like . and , that belong with numbers
	}else{
		//Make sure that only a number was entered
		if( (event.keyCode < 48 || event.keyCode > 57) && 
				(event.keyCode < 96 || event.keyCode > 105) ){
			event.preventDefault();
		}
	}
}