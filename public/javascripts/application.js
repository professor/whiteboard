// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


	$(function() {
		$("#presentation_presentation_date").datepicker({
//            showSecond: true,
//	        timeFormat: 'hh:mm:ss',
            dateFormat: 'yy-mm-dd'
		});
	});


	$(function() {
		$("#add_person").click(function() {
            var a = $("<a></a>").attr('href','#').click(somefunction);
           $("#people_in_a_collection").append(a);
        });
 	});


