// This page contains all relevant JS for the people search
var photobook_toggled = false;
var advanced_search_toggled = false;
var last_search_results = '';
var last_search_query = '';
var jq_xhr;                             // jQuery Ajax XML HTTP Request Object
var searchBox_old_val  = '';            // searchBox old value holder. If user changes keystrokes but lands up with same parameter, don't send a request again.
var ajax_req_issued = false;            // object that indicates if an ajax search request is currently executing
var sendQueryToServer_timer = null;     // js timer object for controlling number of requests going to server on keyup
var advanced_search_changed = false;
var load_using_custom_params = false;

$(document).ready(function() {

    /****************************************
                SETUP INITIAL STATE
    *****************************************/

    // setting up the search box  (filterBoxOne)
    if ($("#filterBoxOne").prop("disabled") == true) {
        $('#filterBoxOne').val('');
        $('#filterBoxOne').removeAttr("disabled");
        $('#filterBoxOne').focus();
    };

    // Setup the initial state of tables
    $("#people_table")
        .tablesorter({
            // add zebra striping style
            widgets:['zebra'],
            // don't allow sorting on the picture and contact details columns
            headers:{0:{sorter:false}, 3:{sorter:false}}
        })
        .tablesorterFilter({ filterContainer:$("#filterBoxOne"),
            filterClearContainer:$("#filterClearOne"),
            filterColumns:[0, 1, 2],
            filterCaseSensitive:false
        });

    $("#key_contacts_table").hide();
    $("#advanced_search_filters").hide();

    //default_results_json = getDefaultSearchResultsJson();

    var standard_params_list = ['filterBoxOne', 'photobook'];
    var advanced_params_list = ['filterBoxOne','user_type','graduation_year','masters_program','course_id','search_inactive'];
    var valid_params_list = advanced_params_list.concat(standard_params_list);
    for (var i in valid_params_list) {
        if(getURLParameter(valid_params_list[i]))
            load_using_custom_params = true;
    }
    for (var i in advanced_params_list) {
        if(getURLParameter(valid_params_list[i]))
            advanced_search_toggled = true;
    }
    if(getURLParameter('photobook') == "true")
        photobook_toggled = true;
    if(load_using_custom_params)
        setSessionInfo();
    load_using_custom_params = false;

    // making our search considerate (load search params from session)
    if($.session.get("previous_search_params") && $.session.get("previous_toggle_state")){
        var previous_search_params = jQuery.parseJSON($.session.get("previous_search_params"));
        var previous_toggle_states = jQuery.parseJSON($.session.get("previous_toggle_state"));

        if(previous_search_params){
            if(previous_search_params.filterBoxOne){
                $("#filterBoxOne").val(previous_search_params.filterBoxOne);
                last_search_query = previous_search_params.filterBoxOne;
            }
            if(previous_search_params.filter_person_type && previous_search_params.search_inactive)
                $("#search_inactive").prop('checked', true);
            if(previous_search_params.user_type)
                $("#filter_person_type").val(previous_search_params.user_type);
            if(previous_search_params.graduation_year)
                $("#filter_year").val(previous_search_params.graduation_year);
            if(previous_search_params.masters_program)
                $("#filter_program").val(previous_search_params.masters_program);
            if(previous_search_params.course_id)
                $("#filter_course").val(previous_search_params.course_id);
        }
        if(previous_toggle_states){
            if(previous_toggle_states.photobook_toggled_state){
                photobook_toggled = previous_toggle_states.photobook_toggled_state;
                setPhotobookToggleState();
            }
            if(previous_toggle_states.advanced_search_filters){
                advanced_search_toggled = previous_toggle_states.advanced_search_filters;
                setAdvancedFilterToggleState();
                advanced_search_changed = true;
            }
        }
        getSearchResults();
    }

    updateView();
    $("#photobook_results").hide();

    /**************************************************************
        SEARCHING FOR PEOPLE (Search trigger functions)
        These are the main search functions that trigger a search
    ***************************************************************/

    // Entering Search parameters (keyup)
    // on entering some key in the search box "filterBoxOne"
    $("#filterBoxOne").keyup(function() {
        var isSearchTextEntered = ($.trim($("#filterBoxOne").val()).length > 0);
        var didSearchChange = ($("#filterBoxOne").val() != last_search_query);
        if(didSearchChange){
            updateView();
            if(isSearchTextEntered){
                // Prevent multiple calls to the database
                if(sendQueryToServer_timer != null)
                    clearTimeout(sendQueryToServer_timer); // there's a previous timer running, clear it and set a new one for the new keystrokes of the user
                sendQueryToServer_timer = setTimeout(getSearchResults, 500); // set timer for the keystrokes entered by user
                last_search_query = $("#filterBoxOne").val();
                // update the UI immediately to indicate that the pending search is in progress
                // when ajax search query returns successfully, the view will be updated again.
                $('#empty_results').hide();
                $("#people_table").hide();
                $("#key_contacts_table").hide();
                $("#key_contacts_photobook").hide();
                $("#ajax_loading_notice").show();
            }else if(advanced_search_toggled){
                    // advanced filters are visible, query the database
                    // this is essentially a select all (as nothing entered in filterBoxOne)
                    getSearchResults();
            }
        }
        setSessionInfo();
        // if ($("#filterBoxOne").val() == last_search_query){
        //     if($("#people_table").is(":visible") && $('#people_table tbody tr').length <= 1){
        //         setTimeout(keyup_error_recover(),500); alert('what!'); }
        // }
    });

    // Advanced filters (toggle)
    $("#filterBoxOne_filter").click(function (){
        var isSearchTextEntered = ($.trim($("#filterBoxOne").val()).length > 0);
        advanced_search_toggled = !advanced_search_toggled;
        advanced_search_changed=true;
        setAdvancedFilterToggleState();

        // update UI immediately while search ajax call is processing.
        if(advanced_search_toggled)
            $("#advanced_search_filters").show();
        else
            $("#advanced_search_filters").hide();
        updateView();

        // update UI to show key_contacts_table if true.  Else, execute a search.
        if(!isSearchTextEntered && !advanced_search_toggled){
            updateView();
        } else {
            getSearchResults();
        }
        setSessionInfo();
    });

    // Photobook view (click)
    $("#filterBoxOne_photobook").click(function (){
        photobook_toggled = !photobook_toggled;
        setPhotobookToggleState();
        clearSearchResults();
        if(!photobook_toggled){
            $("#key_contacts_photobook").hide();
            $("#people_photobook").hide();
        }
        if (    advanced_search_toggled ||     // advanced search filters visible
                ($.trim($("#filterBoxOne").val()).length > 0)       // search text entered
            ) {
            $("#empty_results").hide();
            buildSearchResults(last_search_results);
        }
        updateView();
        setSessionInfo();
    });

    $("#filter_person_type").change(function(){ advanced_search_changed=true; getSearchResults(); });
    $("#filter_course").change(function(){ advanced_search_changed=true; getSearchResults(); });
    $("#filter_year").change(function(){ advanced_search_changed=true; getSearchResults(); });
    $("#filter_program").change(function(){ advanced_search_changed=true; getSearchResults(); });
    $("#search_inactive").change(function(){ advanced_search_changed=true; getSearchResults(); });

    $("#filterBoxOne_export_contacts").click(function (){
        show_box();
    });

    /* making the whole row of key_contacts clickable
    ***************************************************/
    // apply on key_contacts
    $('#key_contacts_table tbody tr').click(function () {
        window.location = $(this).find('a').attr('href');
    });
    // apply on people_table
    $('#people_table tbody tr').live(  "click",
        function(){
            window.location = $(this).find('a').attr('href');
        });

}); // jQuery ready function ending


/****************************************
        EXPORT VCARD FUNCTIONS
*****************************************/

// pop up box that shows up on hitting the Export button
function show_box(){
    var boxValue = $("#filterBoxOne").val();
    var $dialog = $('<div></div>')
        .html('Which format do you wish to export to?')
        .dialog({
            autoOpen: true,
            resizable: false,
            draggable: false,
            width: 100,
            height: 130,
            modal: true,
            title: 'Export Contacts',
            buttons:{
                "CSV":function(){
                    window.location.href='people_csv.csv?filterBoxOne='+boxValue;
                    $(this).dialog("close");
                },
                "vCard":function(){
                    window.location.href='people_vcf?filterBoxOne='+boxValue;
                    $(this).dialog("close");
                }
            }
        });
}

/****************************************
        MAIN SEARCH FUNCTIONS
*****************************************/

// get search results from database based on search parameters
//      queries the database with search parameters
//      calls builds the search results
function getSearchResults(){
    searchBox = $("#filterBoxOne");
    isSearchTextEntered = ($.trim(searchBox.val()).length > 0);
    if(     (searchBox.val() != searchBox_old_val)
        ||  advanced_search_changed
        ||  ( (!advanced_search_toggled) && isSearchTextEntered )
        ){

        advanced_search_changed = false;
        $("#people_table").hide();
        searchBox_old_val = searchBox.val();

        if( isSearchTextEntered || advanced_search_toggled ){
            if(ajax_req_issued){
                // an ajax request was already issued, abort that request
                jq_xhr.abort();
                // Note: only instructs browser to stop listening for old request, if request already issued to server, cannot force server to stop processing.
            }
            // send ajax request and assign the XHML HTTP request object returned to jq_xhr
            jq_xhr = $.ajax({
              url : 'people_search',  // the URL for the request
              data : setSessionInfo(),  // the data to send  (will be converted to a query string)
              method : 'GET',
              dataType : 'json',  // the type of data we expect back
              contentType: "application/json; charset=utf-8",
              beforeSend: function() {
                ajax_req_issued = true;
                clearSearchResults();
                $('#ajax_loading_notice').show();
                $('#empty_results').hide();
              },
              complete: function() {
                ajax_req_issued = false;
                if(jq_xhr.status)
                    updateView();
                $("#ajax_loading_notice").hide();
              },
              success : function(json) {
                last_search_results = json;
                buildSearchResults(json);
              }
           });
        } else{
        // user has not entered a search query
            if(ajax_req_issued)
                jq_xhr.abort();
            updateView();
        }
    } //speed up transition from filter toggled to untoggled state when no text entered.
    else if ((!advanced_search_toggled) && (!isSearchTextEntered)){
        if(ajax_req_issued)
            jq_xhr.abort();
        updateView();
    }
}

// build the search results (called from one of the search trigger functions )
function buildSearchResults(json) {
    if(json != ''){
        if(photobook_toggled){
            // build row number i
            // first do high priority results, then low priority results
            for (var i in json){
                if(json[i].priority)
                    buildResultRowPhotoBookFormat(json[i]);
            }
            for (var i in json){
                if(!json[i].priority)
                    buildResultRowPhotoBookFormat(json[i]);
            }
            // apped the export list row button
            $('#photobook_results_main').append($('<div class="clearboth"><input type="button" class="export_button" value="Export List" onclick="show_box();"/></div>'));
        } else{
            // build row number i
            // first do high priority results, then low priority results
            for (var i in json){
                if(json[i].priority)
                    buildResultRowListFormat(json[i]);
            }
            for (var i in json){
                if(!json[i].priority)
                    buildResultRowListFormat(json[i]);
            }

        }
    }
}

// build a single list result row (TODO: change this name to build list result row)
function buildResultRowListFormat (json) {
    // contact details data
    var contactDtls_string = '';
    for(var i in json.contact_dtls)
       contactDtls_string += json.contact_dtls[i] + "<br />";
    contactDtls_string += "<a href='mailto:" + json.email + "'>" + json.email + "</a>";

    $('<tr />')
        .append($('<td class="photobook-img" />').append($(loadImage(json.image_uri))))
        .append($('<td><a href="'+json.path+'">'+json.first_name+'</a></td>'))
        .append($('<td><a href="'+json.path+'">'+json.last_name+'</a></td>'))
        .append($('<td>'+contactDtls_string+'</td>'))
        .append($('<td>'+json.program+'</td>'))
    .appendTo('#people_table tbody');
}

// build a single photoboook result row
function buildResultRowPhotoBookFormat(json){
    $(loadImage(json.image_uri))
        .appendTo($('<a class="photobook_item" href="' + json.path + '"/>'))
        // jQuery chaining refers always to the first element (so still img)
        .parent()
        // now you're in the photobook_item element
        .append($('<p class="photobook_item_name" />').html(json.first_name+" "+json.last_name))
        .appendTo('#photobook_results_main');
}


/****************************************
        HELPER FUNCTIONS
*****************************************/
// helper function to clear all tables
function clearSearchResults () {
    // clear existing tables
    $('#people_table tbody').empty();
    $('#photobook_results_main').empty();
}

// helper function to build json data object for ajax calls
function setSessionInfo() {
    var json = {};

    if(load_using_custom_params){

        // JSON object for override parameters
        json = {
            filterBoxOne : getURLParameter('filterBoxOne'),
            user_type :   getURLParameter('user_type'),
            graduation_year : getURLParameter('graduation_year'),
            masters_program : getURLParameter('masters_program'),
            course_id : getURLParameter('course_id'),
            search_inactive : getURLParameter('search_inactive'),
            ajaxCall : true
        };

    } else if (advanced_search_toggled) {
        json = {
                    filterBoxOne : $("#filterBoxOne").val(),
                    user_type :   $("#filter_person_type").val(),
                    graduation_year : $("#filter_year").val(),
                    masters_program : $("#filter_program").val(),
                    course_id : $("#filter_course").val(),
                    search_inactive : $('#search_inactive:checked').val(),
                    ajaxCall : true
        };
    } else{
        json = {
                    filterBoxOne : $("#filterBoxOne").val(),
                    show_advanced_search : false,
                    ajaxCall : true
        };
    };

    $.session.set("previous_search_params", JSON.stringify(json));
    $.session.set("previous_toggle_state", getToggleState());

    return json;

}

function getToggleState(){
    var json = {
        photobook_toggled_state : photobook_toggled,
        advanced_search_filters : advanced_search_toggled
    };
    return JSON.stringify(json);
}

function setPhotobookToggleState(){
        setSessionInfo();
        var $photobook = $("#filterBoxOne_photobook");
        if(photobook_toggled)
            $photobook.addClass("toggled");
        else
            $photobook.removeClass("toggled");
        $photobook.attr('title', (photobook_toggled ? 'Grid View' : 'Photobook View'));
}

function setAdvancedFilterToggleState(){
    var $filter = $("#filterBoxOne_filter");
    if(advanced_search_toggled)
        $filter.addClass("toggled");
    else
        $filter.removeClass("toggled");
}

// helper function to build the photo image form the uri and add a scotty img if not loaded
function loadImage(image_uri){
    var img = new Image();
    if(!photobook_toggled){
        img.width = 60;
    }else{
        img.width = 145;
    }
    img.src = image_uri;
    $(img).bind({
        error: function() {
            // if there's some error in loading the image, load scotty dog instead
            img.src = "/images/mascot.jpg";
        }
    });
    $(img).attr('src',image_uri);
    return img;
}

// Get parameter from the current URL
function getURLParameter(sParam){
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    for (var i = 0; i < sURLVariables.length; i++){
        var sParameterName = sURLVariables[i].split('=');
        if(sParameterName[0] == sParam){
            return sParameterName[1];
        }
    }
}

function keyup_error_recover(){
    alert('help is on the way!');

}

function updateView(){
    if(!ajax_req_issued){
        $filterBoxOne = $("#filterBoxOne");
        $filterBoxOne_filter = $("#filterBoxOne_filter");
        $filterBoxOne_photobook = $("#filterBoxOne_photobook");
        $key_contacts_table = $("#key_contacts_table");
        $key_contacts_photobook = $("#key_contacts_photobook");
        $people_table = $("#people_table");
        $photobook_results = $("#photobook_results");
        $advanced_search_filters = $("#advanced_search_filters");
        $empty_results = $("#empty_results");
        isSearchTextEntered = ($.trim($("#filterBoxOne").val()).length > 0);
        var empty_results = false;

        if(last_search_results == '' && !$key_contacts_table.is(":visible") && !$key_contacts_photobook.is(":visible") && !ajax_req_issued){
            empty_results = true;
            if(advanced_search_toggled)
                $advanced_search_filters.show();
            // hide other sections
            $empty_results.show();
            $people_table.hide();
            $key_contacts_photobook.hide();
            $key_contacts_table.hide();
            $photobook_results.hide();
        }
        if(last_search_results == '' && !$key_contacts_table.is(":visible") && !$key_contacts_photobook.is(":visible")){
            if(advanced_search_toggled){
                $advanced_search_filters.show();
                $empty_results.show();
                empty_results = true;
            }else
                $advanced_search_filters.hide();
            // hide other sections
            $people_table.hide();
            $key_contacts_photobook.hide();
            $key_contacts_table.hide();
            $photobook_results.hide();
        }
        // Set up initial state
        if(!advanced_search_toggled && !photobook_toggled && !isSearchTextEntered){
            //show key_contacts table
            $key_contacts_table.show();
            // hide other sections
            $empty_results.hide();
            $key_contacts_photobook.hide();
            $people_table.hide();
            $photobook_results.hide();
            $advanced_search_filters.hide();
            $("#ajax_loading_notice").hide();
            //$("#ajax_loading_notice").hide();
        }
        // Set up people search results table view without advanced filters
        if(!advanced_search_toggled && !photobook_toggled && isSearchTextEntered && !empty_results){
            // show people search results in people_table
            $people_table.show();
            // hide other sections
            $key_contacts_photobook.hide();
            $key_contacts_table.hide();
            $photobook_results.hide();
            $advanced_search_filters.hide();
        }
        // Set up people search results table view with advanced filters
        if(advanced_search_toggled && !photobook_toggled && !empty_results){
            // show results people_table
            // show advance search filters box
            $people_table.show();
            $advanced_search_filters.show();
            // hide other sections
            $key_contacts_photobook.hide();
            $key_contacts_table.hide();
            $photobook_results.hide();
        }
        // Set up people search results photobook view without advanced filters
        if(!advanced_search_toggled && photobook_toggled && !isSearchTextEntered){
            // show key contacts in photobook_results
            $key_contacts_photobook.show();
            // hide other sections
            $key_contacts_table.hide();
            $photobook_results.hide();
            $people_table.hide();
            $advanced_search_filters.hide();
        }
        if(!advanced_search_toggled && photobook_toggled && isSearchTextEntered && !empty_results){
            // show people search results in photobook_results
            $photobook_results.show();
            // hide other sections
            $key_contacts_photobook.hide();
            $people_table.hide();
            $key_contacts_table.hide();
            $advanced_search_filters.hide();
        }
        // Set up people search results photobook view with advanced filters
        if(advanced_search_toggled && photobook_toggled && !empty_results){
            // show search results in photobook_table
            // show advance search filters box
            $photobook_results.show();
            $advanced_search_filters.show();
            // hide other sections
            $key_contacts_photobook.hide();
            $people_table.hide();
            $key_contacts_table.hide();
        }
    }
}