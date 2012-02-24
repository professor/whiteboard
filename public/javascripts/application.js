// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

	function confirmExit(){
  		if(confirmation_needed){
	 	return " ";
  		}
	}

	$(function() {
		$("#presentation_presentation_date").datepicker({
            showButtonPanel: true,
            dateFormat: 'yy-mm-dd'
		});
	});
