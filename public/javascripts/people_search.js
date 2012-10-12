/* UI Mockup JS Migration */

var criteria_name_hash = new Object();
criteria_name_hash["first_name"] = "First Name";
criteria_name_hash["last_name"] = "Last Name";
criteria_name_hash["andrew_id"] = "Andrew ID";
criteria_name_hash["company"] = "Company";
criteria_name_hash["class_year"] = "Class Year";
criteria_name_hash["team"] = "Team";
criteria_name_hash["project"] = "Project";
criteria_name_hash["course"] = "Course";
criteria_name_hash["program"] = "Program";
criteria_name_hash["ft_pt"] = "Full/Part Time";


var criterias_array = ["company", "class_year", "program", "ft_pt", "course", "project", "team" ];
var ext_criteria_hash = new Object();
ext_criteria_hash["First Name"] = true;
ext_criteria_hash["Last Name"] = true;
ext_criteria_hash["Andrew ID"] = true;
ext_criteria_hash["Company"] = false;
ext_criteria_hash["Class Year"] = false;
ext_criteria_hash["Team"] = false;
ext_criteria_hash["Project"] = false;
ext_criteria_hash["Course"] = false;
ext_criteria_hash["Program"] = false;
ext_criteria_hash["Full/Part Time"] = false;

function execute_search(){
    console.log("search executed");
    var request_url_with_params = 'people.json?page=1';
    // main criteria
    if($("#search_text_box").val() != "Search Text"){ request_url_with_params += "&main_search_text="+$("#search_text_box").val(); }
    else { request_url_with_params += "&main_search_text="; }
    if(ext_criteria_hash["First Name"]){ request_url_with_params += "&first_name=true"; }
    if(ext_criteria_hash["Last Name"]){ request_url_with_params += "&last_name=true"; }
    if(ext_criteria_hash["Andrew ID"]){ request_url_with_params += "&andrew_id=true"; }
    if($('#exact_match_checkbox')[0].checked){ request_url_with_params += "&exact_match=true"; }
    // extra criteria
    if(ext_criteria_hash["Company"]){ request_url_with_params += "&organization_name="+$('#criteria_company input').val(); }
    //console.log(request_url_with_params);

    $.ajax({
        url: request_url_with_params,
        dataType: 'json',
        success: function(data){
            console.log(data);
            $("#results_box").html("");
            $.each(data, function(){
                var card_html = '<div class="data_card">';
                card_html += '<a href="people/'+this.id+'">'
                card_html += '<img src='+this.image_uri+'></a><br>';
                card_html += 'Name: '+this.first_name+' '+this.last_name+'<br>';
                card_html += 'Email: '+this.email;
                card_html += '</div>';
                $("#results_box").append(card_html);
            });
            // re-height the results box for aligning
            $("#results_box").css('height', 260*Math.ceil(data.length/3)+16+"px");
        }
    });

};


$(document).ready(function(){

    // Initialize dialog
    $('#dialog_modal').dialog({
        dialogClass: 'customization_dialog', position: 'top', width: 220, height: 450,
        autoOpen: false, show: 'fold', hide: 'fold', modal: true
    });
    $('#customization_link').click(function() {  $('#dialog_modal').dialog("open");  });
    $('#customization_dialog_close').click(function() { $('#dialog_modal').dialog("close"); });

    // Class Year Options
    for (i=2013; i>2001; --i){
        $('#criteria_class_year select').append('<option value="'+i+'">'+i+'</option>');
    }
    // extra_criteria_box criteria_tag Hide
    $('#extra_criteria_box .criteria_tag').hide();


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


    // add criteria change event
    $('#people_type_picker').change(function() {
        $('#extra_criteria_picker').html("");
        var criteria_ids;
        switch($(this)[0].value){
            case "all":
            case "student":
                criteria_ids = [0, 2, 3, 4, 5, 6];
                break;
            case "staff":
                criteria_ids = [0, 4, 5];
                break;
            case "alumni":
                criteria_ids = [0, 1, 2, 3];
                break;
        }

        $('#extra_criteria_picker').append('<option value="default" class="select-hint">Add Criteria</option>');
        for (var i=0; i<criteria_ids.length; ++i){
            var criteria_name = criterias_array[criteria_ids[i]];
            $('#extra_criteria_picker').append('<option value="'+criteria_name+'">'+criteria_name_hash[criteria_name]+'</option>');
        }
        $('#extra_criteria_box .criteria_tag').each( function(){
            var to_be_hide = true;
            for (var i=0; i<criteria_ids.length; ++i){
                if( $(this)[0].title == criteria_name_hash[criterias_array[criteria_ids[i]]]){
                    to_be_hide = false;
                    break;
                }
            }
            if(to_be_hide && $(this).css('display') != 'none') {
                ext_criteria_hash[$(this)[0].title] = false;
                alert($(this)[0].title +" is not related to the user type selected.");
                $(this).fadeOut();
            }
        });

    });


    $('#extra_criteria_picker').change(function() {
        var tag_text = criteria_name_hash[$(this)[0].value];
        ext_criteria_hash[tag_text] = true;
        $('#'+'criteria_'+$(this)[0].value).appendTo('#extra_criteria_box .criteria_tags');
        $('#'+'criteria_'+$(this)[0].value).show();

        if($('#extra_criteria_box .criteria_tag').last().find('.criteria_text').length != 0 && $('#extra_criteria_box .criteria_tag').last().css('display') != 'none'){
            $('#extra_criteria_box .criteria_tag').last().find('.criteria_text')[0].focus();
        }

        $(this).val('default');
    });


    // Remove tag when click on x
    $('#main_criteria_box').on("click", ".criteria_tag a", function(){
        if($(this).parent().css('opacity') == '1'){
            ext_criteria_hash[$(this).parent()[0].title] = false;
            $(this).parent().fadeTo("fast", 0.55);
            $(this).html('+');
            // check if all main criteria is faded
            if(!(ext_criteria_hash["First Name"] || ext_criteria_hash["Last Name"] || ext_criteria_hash["Andrew ID"])) {
                $(this).parent().fadeTo("fast", 1);
                $(this).html('x');
                alert("Sorry, but you can not discard all three criterias.");
            }
        } else {
            ext_criteria_hash[$(this).parent()[0].title] = true;
            $(this).parent().fadeTo("fast", 1);
            $(this).html('x');
        }
        return false; // avoid anchor action
    });

    $('#extra_criteria_box').on("click", ".criteria_tag a", function(){
        ext_criteria_hash[$(this).parent()[0].title] = false;
        $(this).parent().fadeOut();
        return false;
    });


    // Send query and get results
    $('#search_text_box').keyup(function(e) {
        if(e.which == 13){ // If ENTER
            execute_search();
        }
    });

    $('#submit_btn').click( function(){ execute_search(); });

});
