/* UI Mockup JS Migration */

// An array of available criteria
var CRITERIA_ARRAY = ["company", "class_year", "program", "ft_pt", "course", "project", "team" ];

// HASH providing the mapping of variable name and screen name
var CRITERIA_NAME_HASH = {
    "first_name": "First Name",
    "last_name": "Last Name",
    "andrew_id": "Andrew ID",
    "company": "Company",
    "class_year": "Class Year",
    "program": "Program",
    "ft_pt": "Full/Part Time"
}
// HASH reflecting if criteria specified or not
var SELECTED_CRITERIA_HASH = {
    "First Name": true,
    "Last Name": true,
    "Andrew ID": true,
    "Company": false,
    "Class Year": false,
    "Program": false,
    "Full/Part Time": false
}

// Prefetch data from server and build hash table for prediction on user inputs
var RECOGNITION_HASH = new Object();
RECOGNITION_HASH["COMPANY"] = new Object();

// Predefines the Global Search Request object
var SEARCH_REQUEST = $.ajax();
var SEARCH_TIMEOUT;

// Build the company hash
function build_company_hash(){
  $.ajax({
    url: 'people_get_companies.json', dataType: 'json',
    success: function(data){
      for(var i=0; i<data.length; ++i){
        if(data[i] != null && data[i] != ""){
          var splited_str_array = data[i].split(" ");
          for(var j=0; j<splited_str_array.length; ++j){
            //splited_str_array[j] = splited_str_array[j].replace(/^[a-zA-Z0-9](.*[a-zA-Z0-9])?$/gi, '');
            splited_str_array[j] = splited_str_array[j].replace(/^[^a-z0-9]/gi,'').replace(/[^a-z0-9]$/gi,'');
          }
          console.log(splited_str_array);
        }
      }
    }  
  });
};

// TODO for company hash
// ignore, pvt, ltd, limited, private, dept, corp, an, co, inc, or, and, of, the, single character, empty string, replace character like (. , ) at the beginning and end  with empty
// Check for program full time..... first and then company (because someone write SE Fulltime Tech.... as company)




function construct_query_sting(){
    var request_url_with_params = '';
    // add main criteria to query string
    if($("#search_text_box").val() != "Search Text"){ request_url_with_params += "&main_search_text="+$("#search_text_box").val(); }
    else { request_url_with_params += "&main_search_text="; }
    if(SELECTED_CRITERIA_HASH["First Name"]){ request_url_with_params += "&first_name=true"; }
    if(SELECTED_CRITERIA_HASH["Last Name"]){ request_url_with_params += "&last_name=true"; }
    if(SELECTED_CRITERIA_HASH["Andrew ID"]){ request_url_with_params += "&andrew_id=true"; }
    if($('#exact_match_checkbox')[0].checked){ request_url_with_params += "&exact_match=true"; }
    // add people_type to query string 
    if($('#people_type_picker').val() != "all") {request_url_with_params += "&people_type="+$('#people_type_picker').val();}
    // add extra criteria to query string
    if(SELECTED_CRITERIA_HASH["Company"]){ request_url_with_params += "&organization_name="+$('#criteria_company input').val(); }
    if(SELECTED_CRITERIA_HASH["Class Year"]){ request_url_with_params += "&class_year="+$('#criteria_class_year select').val(); }
    if(SELECTED_CRITERIA_HASH["Program"]){ request_url_with_params += "&program="+$('#criteria_program select').val(); }
    if(SELECTED_CRITERIA_HASH["Full/Part Time"]){
      if($('#criteria_ft_pt select').val() == "ft") { request_url_with_params += "&is_part_time=false"; }
      else { request_url_with_params += "&is_part_time=true"; }
    }
    
    return request_url_with_params;
};

function execute_search(request_params){
    
    // console.log("search executed");
    $('#results_box').fadeTo('fast', 0.5);
    SEARCH_REQUEST.abort();

    SEARCH_REQUEST = $.ajax({
        url: 'people.json?page=1'+request_params, dataType: 'json',
        success: function(data){
            $("#results_box").html("");
            $.each(data, function(){
                // DEBUG console.log(this.first_name +" "+this.last_name );
                var card_html =
                '<div class="data_card">'+
                '<a href="people/'+this.id+'"><img src='+this.image_uri+'></a><br>'+
                '<div class="data_card_human_name">'+this.first_name+' '+this.last_name+'</div>'+
                '<div class="data_card_email"><a class="mail_link" href="mailto:'+this.email+'">'+this.email + '</a></div>'+
                '<div class="data_card_telephone">';
                if(this.telephone1){ card_html+= this.telephone1_label +': '+this.telephone1+'<br>'; }
                if(this.telephone2){ card_html+= this.telephone2_label +': '+this.telephone2+'<br>'; }
                card_html += '</div>';

                if(this.team_names.length > 0){ card_html += 'Teams: '; }
                for(var i=0; i<this.team_names.length; i++){
                    card_html +=  this.team_names[i].name + ' (Course: ' + this.team_names[i].course_name+ ') ';
                }

                card_html += '</div>';
                $("#results_box").append(card_html);
            });

            $('#results_box').fadeTo('fast', 1);
        }
    });
    //history.pushState(null, "", 'people?'+request_params);
    //history.replaceState(null, "", 'people?'+request_params);
    // Linkable URL - Modify the location hash when search performed
    location.hash=request_params;
};


$(document).ready(function(){

    // Initialize the customization dialog box
    $('#dialog_modal').dialog({
        dialogClass: 'customization_dialog', position: 'top', width: 200, height: 400,
        autoOpen: false, show: 'fold', hide: 'fold', modal: true
    });
    $('#customization_link').click(function() {  $('#dialog_modal').dialog("open");  });
    $('#customization_dialog_close').click(function() { $('#dialog_modal').dialog("close"); });

    // Initialize the export results dialog box
    $('#export_dialog_modal').dialog({
        dialogClass: 'customization_dialog', position: 'top', width: 160, height: 120,
        autoOpen: false, show: 'fold', hide: 'fold', modal: true
    });
    $('#export_link').click(function() {  $('#export_dialog_modal').dialog("open");  });
    $('#export_dialog_close').click(function() { $('#export_dialog_modal').dialog("close"); });

    $('#export_to_csv').click(function(){
      window.open('people.csv?page=1'+construct_query_sting());
      $('#export_dialog_modal').dialog("close");
    });

    $('#export_to_vcf').click(function(){
      window.open('people.vcf?page=1'+construct_query_sting());
      $('#export_dialog_modal').dialog("close");
    });

    // Advanced Search Area Initialization
    $('#advanced_search_btn').click(function(){
      $('#smart_search_text').attr('disabled', 'disabled').css('opacity', 0.3);
      $('#advanced_search_area').slideDown();
    });
    $('#advanced_area_close').click(function(){ 
      $('#smart_search_text').removeAttr('disabled').css('opacity', 1);
      $('#advanced_search_area').slideUp();
    });

    // Build the Companies Hash
    build_company_hash();

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


    // when user change the people type
    $('#people_type_picker').change(function() {
        // clean up the extra criteria options
        $('#extra_criteria_picker').html("");
        var criteria_ids; // the applied index numbers of CRITERIA_ARRAY
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
            var criteria_name = CRITERIA_ARRAY[criteria_ids[i]];
            $('#extra_criteria_picker').append('<option value="'+criteria_name+'">'+CRITERIA_NAME_HASH[criteria_name]+'</option>');
        }
        // iterate through every extra criteria to determine if it should be hidden
        $('#extra_criteria_box .criteria_tag').each( function(){
            var to_be_hide = true;
            for (var i=0; i<criteria_ids.length; ++i){
                if( $(this)[0].title == CRITERIA_NAME_HASH[CRITERIA_ARRAY[criteria_ids[i]]]){
                    to_be_hide = false;
                    break;
                }
            }
            // check if added extra criteria not valid to selected people type
            if(to_be_hide && $(this).css('display') != 'none') {
                SELECTED_CRITERIA_HASH[$(this)[0].title] = false;
                alert($(this)[0].title +" is not related to the user type selected.");
                $(this).fadeOut();
            }
        });
    });


    // when user select something from the extra criteria menu
    $('#extra_criteria_picker').change(function() {
        var tag_text = CRITERIA_NAME_HASH[$(this)[0].value]; // fetch the tag screen text for later use
        SELECTED_CRITERIA_HASH[tag_text] = true;
        $('#'+'criteria_'+$(this)[0].value).appendTo('#extra_criteria_box .criteria_tags');
        $('#'+'criteria_'+$(this)[0].value).show();
        // focus on the last added extra criteria
        if($('#extra_criteria_box .criteria_tag').last().find('.criteria_text').length != 0 && $('#extra_criteria_box .criteria_tag').last().css('display') != 'none'){
            $('#extra_criteria_box .criteria_tag').last().find('.criteria_text')[0].focus();
        }
        execute_search(construct_query_sting());
        $(this).val('default');
    });

    // NEED TO BE REFACTORED AFTER UI CHANGE
    // fade out main criteria tag when click on x
    /*$('#main_criteria_box').on("click", ".criteria_tag a", function(){
        if(SELECTED_CRITERIA_HASH[$(this).parent()[0].title]){
            SELECTED_CRITERIA_HASH[$(this).parent()[0].title] = false;
            $(this).parent().fadeTo("fast", 0.55);
            $(this).html('+');
            // check if all main criteria is faded
            if(!(SELECTED_CRITERIA_HASH["First Name"] || SELECTED_CRITERIA_HASH["Last Name"] || SELECTED_CRITERIA_HASH["Andrew ID"])) {
                $(this).parent().fadeTo("fast", 1);
                $(this).html('x');
                alert("Sorry, but you can not discard all three criterias.");
                SELECTED_CRITERIA_HASH[$(this).parent()[0].title] = true;
            }
        } else { // fade in when click on +
            SELECTED_CRITERIA_HASH[$(this).parent()[0].title] = true;
            $(this).parent().fadeTo("fast", 1);
            $(this).html('x');
        }
        execute_search(construct_query_sting());
        return false; // avoid anchor action
    });*/


    // Remove extra criteria tag when click on x
    $('#extra_criteria_box').on("click", ".criteria_tag a", function(){
        SELECTED_CRITERIA_HASH[$(this).parent()[0].title] = false;
        $(this).parent().fadeOut();
        execute_search(construct_query_sting());
        return false;
    });


    // Events binded to search execution
    $('#people_type_picker, .criteria_text, #exact_match_checkbox').change(function(e) {
      execute_search(construct_query_sting());
    });

    $('#search_text_box').keyup(function(e) {
      clearTimeout(SEARCH_TIMEOUT);
      $('#results_box').fadeTo('fast', 0.5);
      if(e.which != 13){
        SEARCH_TIMEOUT = setTimeout('execute_search(construct_query_sting())', 400);
      }
    });

    $('.criteria_text').keyup(function(e) {
      clearTimeout(SEARCH_TIMEOUT);
      SEARCH_TIMEOUT = setTimeout('execute_search(construct_query_sting())', 400)  ;
    });

    // Linkable URL - Match hash to search parameters and execute search
    var hash_params = window.location.hash;

    if(hash_params != ""){
      hash_params = hash_params.replace("#","");
      execute_search(hash_params);
    }
    // Back to previous search by pressing back button 
    $(window).bind("popstate", function() {
        var hash= location.hash;
        if( hash != ""){
          hash = hash.replace("#","");
          execute_search(hash);
        }
    });




// TODO: Match Parameters in Hash to new UI
/* var hp = hash_params.split("&");
var i;
for(i = 0; i < hp.length; i++) {
var name_value = hp[i].split("=");
var name = name_value[0];
var value = name_value[1];


if(name === "first_name") {
    $("#sea").val(value);
    console.log ($("#criteria_first_name").val());
} else if (name === "last_name") {
    $("#criteria_last_name").val(value);
} else if (name === "andrew_id") {
    $("#criteria_andrew_id").val(value);
} else if (name === "people_type") {
    $("#people_type_picker").val(value);
} else if (name === "organization_name") {
    $("#criteria_company input").val(value);
} else if (name === "main_search_text") {
    $("#search_text_box").val(value);
}

//execute_search();

} */


});
