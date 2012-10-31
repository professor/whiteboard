/* UI Mockup JS Migration */

var criterias_array = ["company", "class_year", "program", "ft_pt", "course", "project", "team" ];

var criteria_name_hash = {
    "first_name": "First Name",
    "last_name": "Last Name",
    "andrew_id": "Andrew ID",
    "company": "Company",
    "class_year": "Class Year",
    "program": "Program",
    "ft_pt": "Full/Part Time"
}

var selected_criteria_hash = {
    "First Name": true,
    "Last Name": true,
    "Andrew ID": true,
    "Company": false,
    "Class Year": false,
    "Program": false,
    "Full/Part Time": false
}

// reserved for future iteration 
//criteria_name_hash["team"] = "Team";
//criteria_name_hash["project"] = "Project";
//criteria_name_hash["course"] = "Course";
//selected_criteria_hash["Team"] = false;
//selected_criteria_hash["Project"] = false;
//selected_criteria_hash["Course"] = false;

var search_request = $.ajax();

function execute_search(){
    // DEBUG
    console.log("search executed");
    $('#results_box').fadeTo('fast', 0.5);
    search_request.abort();

    var request_url_with_params = 'people.json?page=1';
    // add main criteria to query string
    if($("#search_text_box").val() != "Search Text"){ request_url_with_params += "&main_search_text="+$("#search_text_box").val(); }
    else { request_url_with_params += "&main_search_text="; }
    if(selected_criteria_hash["First Name"]){ request_url_with_params += "&first_name=true"; }
    if(selected_criteria_hash["Last Name"]){ request_url_with_params += "&last_name=true"; }
    if(selected_criteria_hash["Andrew ID"]){ request_url_with_params += "&andrew_id=true"; }
    if($('#exact_match_checkbox')[0].checked){ request_url_with_params += "&exact_match=true"; }
    // add people_type to query string 
    if($('#people_type_picker').val() != "all") {request_url_with_params += "&people_type="+$('#people_type_picker').val();}
    // add extra criteria to query string
    if(selected_criteria_hash["Company"]){ request_url_with_params += "&organization_name="+$('#criteria_company input').val(); }
    if(selected_criteria_hash["Class Year"]){ request_url_with_params += "&class_year="+$('#criteria_class_year select').val(); }
    if(selected_criteria_hash["Program"]){ request_url_with_params += "&program="+$('#criteria_program select').val(); }
    if(selected_criteria_hash["Full/Part Time"]){
      if($('#criteria_ft_pt select').val() == "ft") { request_url_with_params += "&is_part_time=false"; }
      else { request_url_with_params += "&is_part_time=true"; }
    }
    
    // DEBUG console.log(request_url_with_params);
    
    search_request = $.ajax({
        url: request_url_with_params, dataType: 'json',
        success: function(data){
            $("#results_box").html("");
            $.each(data, function(){
                // DEBUG console.log(this.first_name +" "+this.last_name );
                var card_html =
                '<div class="data_card">'+
                '<a href="people/'+this.id+'">'+
                '<img src='+this.image_uri+'></a><br>'+
                /*'Name: '+this.first_name+' '+this.last_name+'<br>'+*/
                '<div style="font-size: 16px;">'+this.first_name+' '+this.last_name+'</div>'+
                /*'Email: '+*/'<a class="mail_link" href="mailto:'+this.email+'">'+this.email + '</a><br>';
                if(this.telephone1){
                    card_html+= this.telephone1_label +': '+this.telephone1+'<br>';
                }
                if(this.telephone2){
                    card_html+= this.telephone2_label +': '+this.telephone2+'<br>';
                }

// MERGE TRY
                card_html += 'Teams: ';
                console.log(this.team_names);
                for(var i=0; i<this.team_names.length; i++){
                    card_html +=  this.team_names[i].name + ' (Course: ' + this.team_names[i].course_name+ ') ';
                    //console.log(card_html);
                }
// END TRY
                card_html += '</div>';
                $("#results_box").append(card_html);
            });

            $('#results_box').fadeTo('fast', 1);
        }
    });
    
};


$(document).ready(function(){

    // Initialize the customization dialog box
    $('#dialog_modal').dialog({
        dialogClass: 'customization_dialog', position: 'top', width: 210, height: 420,
        autoOpen: false, show: 'fold', hide: 'fold', modal: true
    });
    $('#customization_link').click(function() {  $('#dialog_modal').dialog("open");  });
    $('#customization_dialog_close').click(function() { $('#dialog_modal').dialog("close"); });


    // add Class Year options
    var current_date = new Date();
    var default_class_year = current_date.getFullYear();
    if (current_date.getMonth() > 8) { default_class_year += 1; }
    for (var i=default_class_year+1; i>2001; --i){
        $('#criteria_class_year select').append('<option value="'+i+'">'+i+'</option>');
    }
    $('#criteria_class_year select').val(default_class_year);

    // hide criteria_tag in the extra_criteria_box 
    $('#extra_criteria_box .criteria_tag').hide();


    // display "Seartch Text" in the main search text if no text is inputed
    $('#search_text_box').val("Search Text").addClass("null_search_text");
    $("input").focus( function(){
        if ($(this).val() == $(this)[0].title){
            $(this).removeClass("null_search_text");
            $(this).val("");
        }
    }).blur(function(){
        if ($(this).val() == ""){
            $(this).addClass("null_search_text");
            $(this).val($(this)[0].title);
        }
    });


    // when user change the people type
    $('#people_type_picker').change(function() {
        // clean up the extra criteria options
        $('#extra_criteria_picker').html("");
        var criteria_ids; // the applied index numbers of criterias_array
        switch($(this)[0].value){
            case "all":
            case "student":
                criteria_ids = [0, 1, 2, 3];
                break;
            case "staff":
                criteria_ids = [0];
                break;
            case "alumnus":
                criteria_ids = [0, 1, 2, 3];
                break;
        }
        // add extra criteria options according to criteria_ids
        $('#extra_criteria_picker').append('<option value="default" class="select-hint">Add Criteria</option>');
        for (var i=0; i<criteria_ids.length; ++i){
            var criteria_name = criterias_array[criteria_ids[i]];
            $('#extra_criteria_picker').append('<option value="'+criteria_name+'">'+criteria_name_hash[criteria_name]+'</option>');
        }
        // iterate through every extra criteria to determine if it should be hidden
        $('#extra_criteria_box .criteria_tag').each( function(){
            var to_be_hide = true;
            for (var i=0; i<criteria_ids.length; ++i){
                if( $(this)[0].title == criteria_name_hash[criterias_array[criteria_ids[i]]]){
                    to_be_hide = false;
                    break;
                }
            }
            // check if added extra criteria not valid to selected people type
            if(to_be_hide && $(this).css('display') != 'none') {
                selected_criteria_hash[$(this)[0].title] = false;
                alert($(this)[0].title +" is not related to the user type selected.");
                $(this).fadeOut();
            }
        });
    });


    // when user select something from the extra criteria menu
    $('#extra_criteria_picker').change(function() {
        var tag_text = criteria_name_hash[$(this)[0].value]; // fetch the tag screen text for later use
        selected_criteria_hash[tag_text] = true;
        $('#'+'criteria_'+$(this)[0].value).appendTo('#extra_criteria_box .criteria_tags');
        $('#'+'criteria_'+$(this)[0].value).show();
        // focus on the last added extra criteria
        if($('#extra_criteria_box .criteria_tag').last().find('.criteria_text').length != 0 && $('#extra_criteria_box .criteria_tag').last().css('display') != 'none'){
            $('#extra_criteria_box .criteria_tag').last().find('.criteria_text')[0].focus();
        }
        execute_search();
        $(this).val('default');
    });


    // fade out main criteria tag when click on x
    $('#main_criteria_box').on("click", ".criteria_tag a", function(){
        if(selected_criteria_hash[$(this).parent()[0].title] == true){
            selected_criteria_hash[$(this).parent()[0].title] = false;
            $(this).parent().fadeTo("fast", 0.55);
            $(this).html('+');
            // check if all main criteria is faded
            if(!(selected_criteria_hash["First Name"] || selected_criteria_hash["Last Name"] || selected_criteria_hash["Andrew ID"])) {
                $(this).parent().fadeTo("fast", 1);
                $(this).html('x');
                alert("Sorry, but you can not discard all three criterias.");
                selected_criteria_hash[$(this).parent()[0].title] = true;
            }
        } else { // fade in when click on +
            selected_criteria_hash[$(this).parent()[0].title] = true;
            $(this).parent().fadeTo("fast", 1);
            $(this).html('x');
        }
        execute_search();
        return false; // avoid anchor action
    });

    // Remove extra criteria tag when click on x
    $('#extra_criteria_box').on("click", ".criteria_tag a", function(){
        selected_criteria_hash[$(this).parent()[0].title] = false;
        $(this).parent().fadeOut();
        execute_search();
        return false;
    });

    var search_timeout;

    // DEPRECATED
    /*$('#search_text_box').keyup(function(e) {
        if(e.which == 13){ // If ENTER
          execute_search();
        }
    });*/

    $('#people_type_picker, .criteria_text, #exact_match_checkbox').change(function(e) {
      execute_search();
    });
    $('#search_text_box').keyup(function(e) {
      clearTimeout(search_timeout);
      //if($('#search_text_box').val().length >1){
      $('#results_box').fadeTo('fast', 0.5);
      if(e.which == 13){
        search_timeout=setTimeout('execute_search()', 0);
      } else {
        search_timeout=setTimeout('execute_search()', 400);
      }
      //}

    });
    $('.criteria_text').keyup(function(e) {
      clearTimeout(search_timeout);
      search_timeout=setTimeout('execute_search()', 400)  ;
    });


    $.getJSON('../people_autocomplete.json',
        function(rcv_data){
            $('#search_text_box').autocomplete({
                source: rcv_data, minLength: 2, delay: 400
            });
        }
    )


});
