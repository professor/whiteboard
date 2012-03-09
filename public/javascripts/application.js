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
<<<<<<< HEAD


	$(function() {
		$("#add_person").click(function() {
            var a = $("<a></a>").attr('href','#').click(somefunction);
           $("#people_in_a_collection").append(a);
        });
 	});


  // The below link explains data
  // http://stackoverflow.com/questions/4518889/jquery-ui-dialog-open-multiple-dialog-boxes-using-the-same-class-on-the-button-a
   $(function(){
	 $('.info_icon').each(function() {
	 $.data(this, 'dialog',
		  $(this).next().dialog({
			  autoOpen: false,
			  modal: true,
			  height: 70,
			  title: 'Submission date',
			  overlay: {
			  opacity: 0.2,
			  background: "black"
			  }

		   })
	);

  }).click(function() {
  $.data(this, 'dialog').dialog('open');
  return false;
  });


  });
=======
>>>>>>> master
