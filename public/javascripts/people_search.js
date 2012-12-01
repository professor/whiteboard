/* JS Migration */

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
var RECOGNITION_HASH = {};
RECOGNITION_HASH["COMPANY"] = {};
RECOGNITION_HASH["PEOPLE_TYPE"] = {
  "student": true, "faculty": true, "staff": true, "alumni": true, "professor": true, "alumnus": true
};
RECOGNITION_HASH["FTPT"] = {
  "ft": true, "pt": true, "fulltime": true, "parttime": true, "part": true, "full": true
};
RECOGNITION_HASH["PROGRAM"] = {
  "se": true, "sm": true, "ini": true, "ece": true, "se-tech": true, "se-dm": true, "ini-is": true, "ini-sm": true, "ini-mob": true
};
RECOGNITION_HASH["IGNORED_COMPANY_WORDS"] = {
  "pvt": true, "ltd": true , "limited": true, "private": true, "dept": true, "corp": true, "an": true, "co": true,
  "corporation": true, "inc": true, "or": true, "and": true, "of": true, "the": true
};

// Predefines the Global Search Request object
var SEARCH_REQUEST = $.ajax();
var SEARCH_TIMEOUT;

// Global variable for datacard mode 
var DATACARD_MODE = "photo_card";




// Build the company hash
function build_company_hash(){

  var build_from_server = function(){
    return $.ajax({
      url: 'people_get_companies.json', dataType: 'json',
      success: function(data){
        for(var i=0; i<data.length; ++i){
          if(data[i] != null && data[i] != ""){
            var splited_str_array = data[i].split(" ");
            for(var j=0; j<splited_str_array.length; ++j){
              //splited_str_array[j] = splited_str_array[j].replace(/^[a-zA-Z0-9](.*[a-zA-Z0-9])?$/gi, '');
              splited_str_array[j] = splited_str_array[j].replace(/^[^a-z0-9]/gi,'').replace(/[^a-z0-9]$/gi,'').toLowerCase();
              if(!(splited_str_array[j].length < 2) && !RECOGNITION_HASH["IGNORED_COMPANY_WORDS"].hasOwnProperty(splited_str_array[j]) && !$.isNumeric(splited_str_array[j])){
                RECOGNITION_HASH["COMPANY"][splited_str_array[j]] = true;
              }

            }
          }
        }
        if(typeof(Storage) !== "undefined"){
          localStorage['RECOGNITION_HASH_COMPANY'] = JSON.stringify(RECOGNITION_HASH["COMPANY"]);  
          localStorage['RECOGNITION_HASH_COMPANY_TIMESTAMP'] = current_date.getTime();
        }
        $('#smart_search_text').removeAttr('disabled').css('opacity', 1);
      }  
    });
  }

  if(typeof(Storage) !== "undefined"){
    //console.log("HTML5 Local Storage Supported");
    var current_date = new Date();
    if(localStorage['RECOGNITION_HASH_COMPANY'] == undefined || (parseInt(localStorage['RECOGNITION_HASH_COMPANY_TIMESTAMP'])+1209600000) < current_date.getTime() ){ 
      build_from_server()
    } else {
      console.log("Found Local Recognition Hash for Company.");
      RECOGNITION_HASH["COMPANY"] = JSON.parse(localStorage['RECOGNITION_HASH_COMPANY']);
      $('#smart_search_text').removeAttr('disabled').css('opacity', 1);
    }
  } else { build_from_server(); }
};


// Try to parse the smart search text
function parse_smart_search(){
  splited_search_str_array = $.trim($('#smart_search_text').val()).split(" ");  
  var category_selected = {};
  category_selected["main_search_text"] = "";
  var parameters_hash = {};
  //console.log(splited_search_str_array);
  for(var i=0; i<splited_search_str_array.length; ++i){
    if(splited_search_str_array[i].length > 1){
      splited_search_str_array[i] = splited_search_str_array[i].toLowerCase();

      // Start guessing the category, start from people type
      if(!category_selected.hasOwnProperty("people_type") && RECOGNITION_HASH["PEOPLE_TYPE"].hasOwnProperty(splited_search_str_array[i])){
        switch(splited_search_str_array[i]){
          case "faculty":
          case "professor":
            category_selected["people_type"] = "staff";
            break;
          case "alumni":
            category_selected["people_type"] = "alumnus";
            break;
          default:
            category_selected["people_type"] = splited_search_str_array[i];
            break;
        }
      }

      // Then guess program
      else if(!category_selected.hasOwnProperty("program") && RECOGNITION_HASH["PROGRAM"].hasOwnProperty(splited_search_str_array[i])){
        var program_text = splited_search_str_array[i];
        if( i+1 < splited_search_str_array.length ){
          var merged_program_text = splited_search_str_array[i]+'-'+splited_search_str_array[i+1].toLowerCase();
          if(RECOGNITION_HASH["PROGRAM"].hasOwnProperty(merged_program_text) ){
            program_text = splited_search_str_array[i]+'_'+splited_search_str_array[i+1];
            i++;
          }
        }
        category_selected["program"] = program_text.replace('-','_').toUpperCase();
      }

      // Then guess FT/PT
      else if(!category_selected.hasOwnProperty("ftpt") && RECOGNITION_HASH["FTPT"].hasOwnProperty(splited_search_str_array[i])){
        switch(splited_search_str_array[i]){
          case "ft":
          case "fulltime":
          case "full":
            category_selected["is_part_time"] = false;
            break;
          case "pt":
          case "parttime":
          case "part":
            category_selected["is_part_time"] = true;
            break;
        }
        if(splited_search_str_array[i] == "full" || splited_search_str_array[i] == "part"){
          if( i+1 < splited_search_str_array.length ){
            if( splited_search_str_array[i+1].toLowerCase() == "time" ) { i++; }
          }
        }
      }

      // Then guess company
      else if(RECOGNITION_HASH["COMPANY"].hasOwnProperty(splited_search_str_array[i]) ){
        if(!category_selected.hasOwnProperty("organization_name")){
          category_selected["organization_name"] = splited_search_str_array[i];
        }
      }

      // Then guess class year 
      else if($.isNumeric(splited_search_str_array[i])){
        var current_date = new Date();
        var default_class_year = current_date.getFullYear();
        if (current_date.getMonth() > 8) { default_class_year += 1; }
        var tmp_class_year = splited_search_str_array[i];
        if (splited_search_str_array[i].length == 2){ tmp_class_year = "20"+splited_search_str_array[i]; }
        if (tmp_class_year.length == 4){
          tmp_class_year = parseInt(tmp_class_year);
          if(tmp_class_year > 2001 && tmp_class_year <= default_class_year+1){
            category_selected["class_year"] = tmp_class_year;
          }
        }
      }

      // else it is name or andrew id
      else {
        category_selected["main_search_text"] += splited_search_str_array[i]+" ";
      }

    }
  }

  category_selected["main_search_text"] = $.trim(category_selected["main_search_text"]);
  category_selected["first_name"] = true;
  category_selected["last_name"] = true;
  category_selected["andrew_id"] = true;

  fill_advanced_area(category_selected);
  
}

// Reset things in the advanced area
function reset_advanced_area(){
  SELECTED_CRITERIA_HASH["Company"] = false;
  SELECTED_CRITERIA_HASH["Class Year"] = false;
  SELECTED_CRITERIA_HASH["Program"] = false;
  SELECTED_CRITERIA_HASH["Full/Part Time"] = false;
  
  $('#search_text_box').val("");
  $('#people_type_picker').val("all");
  $('.criteria_tag').hide();
}

// Auto fillin parameters into advanced search area UI - will be used by both linkable url and extracting smart search fields
function fill_advanced_area(parameters_hash){
  
  reset_advanced_area();
  
  // Start from main search text
  $('#search_text_box').val(parameters_hash["main_search_text"]);

  // Then first name, last name, andrew id
  if(parameters_hash.hasOwnProperty("first_name") && parameters_hash.hasOwnProperty("last_name") && parameters_hash.hasOwnProperty("andrew_id")){ $('#main_criteria_picker').val("all"); }
  else if(parameters_hash.hasOwnProperty("first_name")) { $('#main_criteria_picker').val("first_name"); }
  else if(parameters_hash.hasOwnProperty("last_name")) { $('#main_criteria_picker').val("last_name"); }
  else if(parameters_hash.hasOwnProperty("andrew_id")) { $('#main_criteria_picker').val("andrew_id"); }
  
  // Then company
  if(parameters_hash.hasOwnProperty("organization_name")){
    SELECTED_CRITERIA_HASH["Company"] = true;
    $('#criteria_company').show();
    $('#criteria_company_text').val(parameters_hash["organization_name"]);
  }


  if(parameters_hash.hasOwnProperty("exact_match")){
    $('#exact_match_checkbox').prop('checked', true)
  }
  if(parameters_hash.hasOwnProperty("include_inactive")){
    $('#include_inactive_checkbox').prop('checked', true)
  }



  // Then people type
  var is_staff = false;
  if(parameters_hash.hasOwnProperty("people_type")){
    $('#people_type_picker').val(parameters_hash["people_type"]);
    if(parameters_hash["people_type"] == "staff"){ is_staff = true; }
  }

  // If people type is not staff, then apply all other criteria
  if(!is_staff){
    // Then Program
    if(parameters_hash.hasOwnProperty("program")){
      SELECTED_CRITERIA_HASH["Program"] = true;
      $('#criteria_program').show();
      $('#criteria_program .criteria_text').val(parameters_hash["program"]);
    }

    // Then class year
    if(parameters_hash.hasOwnProperty("class_year")){
      SELECTED_CRITERIA_HASH["Class Year"] = true;
      console.log(parameters_hash["class_year"]);
      $('#criteria_class_year').show();
      $('#criteria_class_year .criteria_text').val(parameters_hash["class_year"]);
    }

    // Then FT/PT
    if(parameters_hash.hasOwnProperty("is_part_time")){
      SELECTED_CRITERIA_HASH["Full/Part Time"] = true;
      $('#criteria_ft_pt').show();
      console.log(parameters_hash["is_part_time"]);
      $('#criteria_ft_pt .criteria_text').val( (parameters_hash["is_part_time"] == "true" || parameters_hash["is_part_time"] === true)? "pt":"ft" );
    }
  } else {
    $('#extra_criteria_picker').html("");
    $('#extra_criteria_picker').append('<option value="default" class="select-hint">Add Criteria</option><option value="company">Company</option>');
  }

}


function construct_query_sting(){
    
    if($.trim($("#search_text_box").val()).length < 2 &&
       $('#people_type_picker').val() == "all" &&
       !SELECTED_CRITERIA_HASH["Company"] && !SELECTED_CRITERIA_HASH["Class Year"] &&
       !SELECTED_CRITERIA_HASH["Program"] && !SELECTED_CRITERIA_HASH["Full/Part Time"]
    ){ 
      SEARCH_REQUEST.abort();
      $('#results_box').html(
        '<div class="ui-widget"><div class="ui-state-highlight ui-corner-all"><p style="color: green; margin-top: 5px;">'+
          '<span class="ui-icon ui-icon-info" style="float: left; margin-left: .2em; margin-top: .1em; margin-right: .3em"></span>'+
            'Please input more characters to trigger the search'+
        '</p></div></div>'
      );
      return location.hash;
    }

    var request_url_with_params = '';
    // add main criteria to query string
    request_url_with_params += "&smart_search_text="+$("#smart_search_text").val();
    request_url_with_params += "&main_search_text="+$("#search_text_box").val();
    if(SELECTED_CRITERIA_HASH["First Name"]){ request_url_with_params += "&first_name=true"; }
    if(SELECTED_CRITERIA_HASH["Last Name"]){ request_url_with_params += "&last_name=true"; }
    if(SELECTED_CRITERIA_HASH["Andrew ID"]){ request_url_with_params += "&andrew_id=true"; }
    if($('#exact_match_checkbox')[0].checked){ request_url_with_params += "&exact_match=true"; }
    if($('#include_inactive_checkbox')[0].checked){ request_url_with_params += "&include_inactive=true"; }
    // add people_type to query string 
    if($('#people_type_picker').val() != "all") {request_url_with_params += "&people_type="+$('#people_type_picker').val();}
    // add extra criteria to query string
    if(SELECTED_CRITERIA_HASH["Company"]){ request_url_with_params += "&organization_name="+$('#criteria_company input').val(); }
    if(SELECTED_CRITERIA_HASH["Class Year"]){ request_url_with_params += "&class_year="+$('#criteria_class_year select').val(); }
    if(SELECTED_CRITERIA_HASH["Program"]){ request_url_with_params += "&program="+$('#criteria_program select').val(); }
    if(SELECTED_CRITERIA_HASH["Full/Part Time"]){
      if($('#criteria_ft_pt .criteria_text').val() == "ft") { request_url_with_params += "&is_part_time=false"; }
      else { request_url_with_params += "&is_part_time=true"; }
    }

    return request_url_with_params;
};

function execute_search(request_params){
    // For debug
    console.log("search executed");
    
    $('#results_box').fadeTo('fast', 0.5);
    SEARCH_REQUEST.abort();

    SEARCH_REQUEST = $.ajax({
        url: 'people.json?page=1'+request_params, dataType: 'json',
        success: function(data){
            $("#results_box").html("");
            $.each(data, function(){
                // DEBUG console.log(this.first_name +" "+this.last_name );
                var card_html =
                '<div class="data_card '+DATACARD_MODE+'">'+
                //if(DATACARD_MODE == "photo_card"){ card_html += '">';}
                '<a href="people/'+this.id+'"><img class ="data_card_photo" src='+this.image_uri+'></a>'+
                '<div class="data_card_human_name">'+this.first_name+' '+this.last_name+'</div>';
                if(this.title){ card_html += '<div class="data_card_title">'+this.title+'</div>' };
                if($('#main_criteria_picker')[0].value=="andrew_id") {card_html+='<div>'+this.andrew_id+'</div>'};
                card_html += '<div class="data_card_email"><a class="mail_link" href="mailto:'+this.email+'">'+this.email + '</a></div>';
                if(this.telephone1){ card_html+= '<div class="data_card_telephone1">'+this.telephone1_label +': '+this.telephone1+'</div>'; }
                if(this.telephone2){ card_html+= '<div class="data_card_telephone2">'+this.telephone2_label +': '+this.telephone2+'</div>'; }

                if(this.team_names.length > 0){ card_html += '<div class="data_card_teams">Teams: ';
                    for(var i=0; i<this.team_names.length; i++){
                        card_html +=  this.team_names[i].name + ' (Course: ' + this.team_names[i].course_name+ ')<br/> ';
                    }
                    card_html +='</div>';
                }

                if(this.company) { card_html += '<div class="data_card_company">'+'Company: '+this.company+'</div>'; }
                card_html += '</div>';
                $("#results_box").append(card_html);
            });
            if($("#results_box").html() == ""){
              $('#results_box').html(
                '<div class="ui-widget"><div class="ui-state-highlight ui-corner-all"><p style="color: green; margin-top: 5px;">'+
                  '<span class="ui-icon ui-icon-info" style="float: left; margin-left: .2em; margin-top: .1em; margin-right: .3em"></span>'+
                    'No matches found'+
                '</p></div></div>'
              );
            }
            $('#results_box').fadeTo('fast', 1);
            customize_display();
        }

    });

};

function customize_display()
{
    if(!($('#photo_checkbox')[0].checked)){
        $('.data_card_photo').addClass("hidden");
        $('.data_card').addClass("resize");
    }
    else{
        $('.data_card_photo').removeClass("hidden");
        $('.data_card').removeClass("resize");
    }
    if(!($('#email_checkbox')[0].checked)){$('.data_card_email').addClass("hidden");}
    else{$('.data_card_email').removeClass("hidden")};
    if(!($('#phone_home_checkbox')[0].checked)){$('.data_card_telephone1').addClass("hidden");}
    else{$('.data_card_telephone1').removeClass("hidden")};
    if(!($('#phone_mobile_checkbox')[0].checked)){$('.data_card_telephone2').addClass("hidden");}
    else{$('.data_card_telephone2').removeClass("hidden")};
    if(!($('#team_checkbox')[0].checked)){$('.data_card_teams').addClass("hidden");}
    else{$('.data_card_teams').removeClass("hidden")};
    if(!($('#company_checkbox')[0].checked)){$('.data_card_company').addClass("hidden");}
    else{$('.data_card_company').removeClass("hidden")};

    //execute_search(construct_query_sting());
    
    // Resize the height of data_card and photo
    $(".data_card .data_card_photo").each( function(){
        $(this).css('height', $(this).width()*19/14 );
    });
    if(DATACARD_MODE == "photo_card"){
      var max_height = 0;
      $(".data_card.photo_card").each( function(){
        if($(this).height() > max_height) { max_height = $(this).height(); }
      });
      $(".data_card.photo_card").css('height', max_height+'px');
    } else { $(".data_card").css('height', 'auto'); }
}

$(document).ready(function(){

    // Initialize the customization dialog box
    $('#dialog_modal').dialog({
        dialogClass: 'customization_dialog', position: 'top', width: 200, height: 450,
        autoOpen: false, show: 'fold', hide: 'fold', modal: true
    });
    $('#customization_link').click(function() {  $('#dialog_modal').dialog("open");  });
    $('#customization_dialog_close').click(function() {customize_display(); $('#dialog_modal').dialog("close"); });

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

    // Insert alternate top nav bar for mobile display
    $('#topnav').append(
      "<div id='alt_topnav'><ul>"+$('#nav ul').html()+"</ul></div>"
    );

    var advanced_only_hash = { "smart_search_text": true, "first_name": true, "last_name": true, "andrew_id": true, "include_inactive": true, "exact_match": true };
    // Advanced Search Area Initialization
    $('#advanced_search_btn').click(function(){

      if($(this).html() == "Smart"){
        $('#smart_search_text').prop('disabled', false).css('opacity', 1);
        $('#advanced_search_area').slideUp();

        var query_string = window.location.hash.replace("#","");
        var tmp_smart_string = "";

          if(query_string != ""){
              var hash_params = query_string.split('&');
              for (var i = 1; i < hash_params.length; i++){
                  hash_params[i] = hash_params[i].split('=');
                  if (!advanced_only_hash.hasOwnProperty(hash_params[i][0])){
                    if(hash_params[i][0] == "is_part_time"){ tmp_smart_string += (hash_params[i][1] == "true")? "PT ":"FT "; }
                    else if(!(hash_params[i][0] == "people_type" && $('#people_type_picker').val() == "all")) { 
                      tmp_smart_string += hash_params[i][1] + ' '; }
                  }
              }
              $('#smart_search_text').val( $.trim(tmp_smart_string.replace("_","-")) );
          }
          $('#main_criteria_picker').val("all");
          SELECTED_CRITERIA_HASH["First Name"] = true;
          SELECTED_CRITERIA_HASH["Last Name"] = true;
          SELECTED_CRITERIA_HASH["Andrew ID"] = true;
          location.hash = construct_query_sting();
          $(this).html("Advanced");
      } else {
        $('#smart_search_text').prop('disabled', true).css('opacity', 0.3);
        $('#advanced_search_area').slideDown();
        $(this).html("Smart");
      }
      
    });

    // Toggle Display Mode
    $("#list_mode_btn, #card_mode_btn").click(function(){
      //if(!$(this).hasClass('hidden')){
        $("#list_mode_btn, #card_mode_btn").toggleClass("hidden");
        if(DATACARD_MODE == "photo_card") { DATACARD_MODE = "list_view"; }
        else if(DATACARD_MODE == "list_view") { DATACARD_MODE = "photo_card"; }
        $('.data_card').not('.customization_dialog .data_card').toggleClass('list_view').toggleClass('photo_card');
        
        // Resize the height of data_card
        $(".data_card .data_card_photo").each( function(){
          $(this).css('height', $(this).width()*19/14 );
        });
        if(DATACARD_MODE == "photo_card"){
          var max_height = 0;
          $(".data_card.photo_card").each( function(){
            if($(this).height() > max_height) { max_height = $(this).height(); }
          });
          $(".data_card.photo_card").css('height', max_height+'px');
        } else { $(".data_card").css('height', 'auto'); }
      //}
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
        var invalid_extra_criteria = "";
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
                //alert($(this)[0].title +" is not related to the user type selected.");
                invalid_extra_criteria += $(this)[0].title+" ";
                $(this).fadeOut();
            }
        });
        if(invalid_extra_criteria != ""){
          $('#results_box').before(
            '<div id="invalid_criteria_alert" class="ui-widget"><div class="ui-state-highlight ui-corner-all"><p style="color: green; margin-top: 5px;">'+
              '<span class="ui-icon ui-icon-info" style="float: left; margin-left: .2em; margin-top: .1em; margin-right: .3em"></span>'+
                "Criteria: "+invalid_extra_criteria+" is/are unselected acoording to the people type selected"+
            '</p></div></div>'
          );
          setTimeout('$("#invalid_criteria_alert").fadeOut()', 3999);
        }
    });

    // when user selects from the main criteria menu
    $('#main_criteria_picker').change(function() {

        if (CRITERIA_NAME_HASH.hasOwnProperty($(this)[0].value)){
          SELECTED_CRITERIA_HASH['First Name'] = false;
          SELECTED_CRITERIA_HASH['Last Name'] = false;
          SELECTED_CRITERIA_HASH['Andrew ID'] = false;
          SELECTED_CRITERIA_HASH[CRITERIA_NAME_HASH[$(this)[0].value]] = true;
        } else {
          SELECTED_CRITERIA_HASH['First Name'] = true;
          SELECTED_CRITERIA_HASH['Last Name'] = true;
          SELECTED_CRITERIA_HASH['Andrew ID'] = true;
        }

        location.hash = construct_query_sting();
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
        location.hash = construct_query_sting();
        $(this).val('default');
    });


    // Remove extra criteria tag when click on x
    $('#extra_criteria_box').on("click", ".criteria_tag a", function(){
        SELECTED_CRITERIA_HASH[$(this).parent()[0].title] = false;
        $(this).parent().fadeOut();
        location.hash = construct_query_sting();
        return false;
    });


    // Events binded to search execution
    $('#people_type_picker, select.criteria_text, #exact_match_checkbox, #include_inactive_checkbox').change(function(e) {
      //console.log('triggered');
      location.hash = construct_query_sting();
    });

    $('#search_text_box, .criteria_text').keyup(function(e) {
      //console.log('triggered');
      clearTimeout(SEARCH_TIMEOUT);
      if(e.which != 13){
        SEARCH_TIMEOUT = setTimeout('location.hash = construct_query_sting()', 400);
      }
    });

    $('#smart_search_text').keyup(function(e) {
      clearTimeout(SEARCH_TIMEOUT);
      if(e.which != 13){ 
        SEARCH_TIMEOUT = setTimeout('parse_smart_search();location.hash = construct_query_sting();', 400);
      }
    });


    // Linkable URL & Back Button- Match hash to search parameters and execute search
    window.onpopstate = function() {

        console.log("popstate triggered");
        var query_string = location.hash.replace("#","").slice(1);
        var url_hash = {};
        
        if(query_string != ""){
          var hash_params = query_string.split('&');  
          for (var i = 0; i < hash_params.length; i++){
            hash_params[i] = hash_params[i].split('=');
            url_hash[hash_params[i][0]] = hash_params[i][1];
          }

          fill_advanced_area(url_hash);
          $('#smart_search_text').val(url_hash["smart_search_text"]);
          execute_search("&"+query_string);
        } else { 
          reset_advanced_area();
          $("#results_box").html("");
          $('#smart_search_text').val("");
        }
    }

});
