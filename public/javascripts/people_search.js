// This page contains all relevant JS for the people search


var photobook_toggled = false;
var last_search_results = '';
var last_search_query = '';
var jq_xhr;                             // jQuery Ajax XML HTTP Request Object
var searchBox_old_val  = '';            // searchBox old value holder. If user changes keystrokes but lands up with same parameter, don't send a request again.
var ajax_req_issued = false;            // object that
var sendQueryToServer_timer = null;     // js timer object for controlling number of requests going to server on keyup
var default_results_json ='';

jQuery(document).ready(function() {

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
        })
        .hide();
    $("#advanced_search_filters").hide();
    $("#filterBoxOne_loader").hide();

    // fetch default search results (key contacts)
    getDefaultSearchResultsJson();

    // Populate the Ajax loading div
    loading_image = document.createElement('img');
    loading_image.src="images/ajax-loader.gif";
    loading_text = document.createTextNode("Loading Results");
    elem = document.getElementById('ajax_loading_notice');
    elem.appendChild(loading_image);
    elem.appendChild(loading_text);

    /**************************************************************
        SEARCHING FOR PEOPLE (Search trigger functions)
        These are the main search functions that trigger a search
    ***************************************************************/

    // Entering Search parameters (keyup)
    // on entering some key in the search box "filterBoxOne"
    $("#filterBoxOne").keyup(function() {
        var isSearchTextEntered = ($.trim($("#filterBoxOne").val()).length > 0) ? true : false;
        var didSearchChange = ($("#filterBoxOne").val() == last_search_query) ? false : true;
        if(isSearchTextEntered && didSearchChange){
            clearAllTables();
            $('#people_table').hide();
            $('#ajax_loading_notice').show();
        // Prevent multiple calls to the database
            if(sendQueryToServer_timer != null){
                clearTimeout(sendQueryToServer_timer); // there's a previous timer running, clear it and set a new one for the new keystrokes of the user
            }
            last_search_query = $("#filterBoxOne").val();
            sendQueryToServer_timer = setTimeout(getSearchResults, 500); // set timer for the keystrokes entered by user
        }else if(didSearchChange){
            // clear tables only when there is text entered, otherwise hitting function keys will also clear the results
            clearAllTables();
            // TODO: test functionality
            if(!($("#advanced_search_filters").is(":visible"))){
                // show the key contacts table again only if the filters are not displayed.
                buildSearchResults(default_results_json);
            }else{
                // advanced filters are visible, query the database
                    // this is essentially a select all (as nothing entered in filterBoxOne)
                getSearchResults();
            }
        }
        //showRelevantTables(isSearchTextEntered);
    });

    // Advanced filters (toggle)
    $("#filterBoxOne_filter").toggle(
        function(){
            // show advanced filters
            $("#advanced_search_filters").show();
            $(this).addClass("toggled");

            clearAllTables();
            $('#people_table').hide();
            getSearchResults();
        },
        function(){
            // deactivate advanced filters
            $("#advanced_search_filters").hide();
            $(this).removeClass("toggled");

            var isSearchTextEntered = ($.trim($("#filterBoxOne").val()).length > 0)?true:false ;
            if ( isSearchTextEntered ){
                getSearchResults();
                //???showRelevantTables(isSearchTextEntered);
            }else{
                // build photobook default results
                clearAllTables();
                buildSearchResults(default_results_json);
            }
        }
    );
    $("#filter_person_type").change(function(){getSearchResults();});
    $("#filter_course").change(function(){getSearchResults();});
    $("#filter_year").change(function(){getSearchResults();});
    $("#filter_program").change(function(){getSearchResults();});
    $("#search_inactive").change(function(){getSearchResults();});


    // Photobook view (click)
    $("#filterBoxOne_photobook").click(function (){
        photobook_toggled = !photobook_toggled;
        if(photobook_toggled)
            $(this).addClass("toggled");
        else
            $(this).removeClass("toggled")
        var title = photobook_toggled ? 'Grid View' : 'Photobook View';
        $("#filterBoxOne_photobook").attr('title', title);

        clearAllTables();
        if (    $("#advanced_search_filters").is(":visible") ||     // advanced search filters visible
                ($.trim($("#filterBoxOne").val()).length > 0)       // search text entered
            ) {
            buildSearchResults(last_search_results);
        }else{
            buildSearchResults(default_results_json);
        }
    });

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

function export_csv(){
    searchBox = $("#filterBoxOne");
    if($.trim(searchBox.val())){
        jq_xhr = $.ajax({
            url : 'people_search',  // the URL for the request
            data : { filterBoxOne : searchBox.val(), ajaxCall : true, fake_data:true },  // the data to send  (will be converted to a query string)
            method : 'GET',
            dataType : 'csv',  // the type of data we expect back
            contentType: "txt/csv; charset=utf-8",
            success : function(json) {
                //buildSearchResults(json);
                console.log("Sent Successfully!");
            }
        });
    }
}

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
                    window.location.href='http://localhost:3000/people_csv.csv?filterBoxOne='+boxValue;
                    $(this).dialog("close");
                },
                "vCard":function(){
                    window.location.href='http://localhost:3000/people_vcf?filterBoxOne='+boxValue;
                    $(this).dialog("close");
                }
            }
        });
}

/****************************************
        MAIN SEARCH FUNCTIONS
*****************************************/

// get default search results and store in a json object
function getDefaultSearchResultsJson(){
    // send ajax request and assign the XHML HTTP request object returned to jq_xhr
    jq_xhr = $.ajax({
        url : 'people',  // the URL for the request
        data : { ajaxCall : true, fake_data:true },  // the data to send  (will be converted to a query string)
        method : 'GET',
        dataType : 'json',  // the type of data we expect back
        contentType: "application/json; charset=utf-8",

        success : function(json) {
            default_results_json=json;
        }
    });
}

// get search results from database based on search parameters
//      queries the database with search parameters
//      calls builds the search results
function getSearchResults(){
    isAdvancedFiltersEnabled = ($("#advanced_search_filters").is(":visible"));
    searchBox = $("#filterBoxOne");

    if(     (searchBox.val() != searchBox_old_val)
        ||  isAdvancedFiltersEnabled
        ||  ( (!(isAdvancedFiltersEnabled)) && ($.trim(searchBox.val())) )
        ){
        searchBox_old_val = searchBox.val();
        $('#people_table tbody').empty();
        $('#photobook_results').empty();

        if( ($.trim(searchBox.val())) || isAdvancedFiltersEnabled ){
            if(ajax_req_issued){
                // an ajax request was already issued, abort that request
                jq_xhr.abort();
                // Note: only instructs browser to stop listening for old request, if request already issued to server, cannot force server to stop processing.
            }
            // send ajax request and assign the XHML HTTP request object returned to jq_xhr
            jq_xhr = $.ajax({
              url : 'people_search',  // the URL for the request
              data : buildDataObject(),  // the data to send  (will be converted to a query string)
              method : 'GET',
              dataType : 'json',  // the type of data we expect back
              contentType: "application/json; charset=utf-8",
              beforeSend: function() {
                ajax_req_issued = true;
                //$("#filterBoxOne_loader").show();
              },
              complete: function() {
                ajax_req_issued = false;
                showRelevantTables($.trim($("#filterBoxOne").val()).length > 0);  
              },
              success : function(json) {
                last_search_results = json;
                clearAllTables();
                buildSearchResults(json);
                //$("#filterBoxOne_loader").hide();
              }
           });
        }else{
        // user has not entered any string
            if(ajax_req_issued){
                jq_xhr.abort();
            }
            // hide the results table
            $("#people_table").hide();
            $("#photobook_results").hide();
        }
    }
}

// build the search results (called from one of the search trigger functions )
function buildSearchResults(json) {
    if(json != ''){
        if(!photobook_toggled){
            // build row number i
            for (var i in json){
                if(json[i].priority)
                    buildResultRowListFormat(json[i]);
            }
            for (var i in json){
                if(!json[i].priority)
                    buildResultRowListFormat(json[i]);
            }
        } else{
            // build row number i
            for (var i in json){
                if(json[i].priority)
                    buildResultRowPhotoBookFormat(json[i]);
            }
            for (var i in json){
                if(!json[i].priority)
                    buildResultRowPhotoBookFormat(json[i]);
            }
        }
        showRelevantTables(($.trim($("#filterBoxOne").val()).length > 0));
    } else{
        clearAllTables();
        $("#empty_results").show();
    }
}

// build a single list result row (TODO: change this name to build list result row)
function buildResultRowListFormat (json) {
    row = document.createElement('tr');
    // image data
    photo_td = document.createElement('td');
    photo_td.setAttribute('class','photobook-img');
    photo_td.appendChild(loadImage(json.image_uri));
    // first_name data
    firstName_td = document.createElement('td');
    firstName_anchorLink = document.createElement('a');
    firstName_anchorLink.href = json.path;
    firstName_anchorLink.appendChild(document.createTextNode(json.first_name));
    firstName_td.appendChild(firstName_anchorLink);
    // last_name data
    lastName_td = document.createElement('td');
    lastName_anchorLink = document.createElement('a');
    lastName_anchorLink.href = json.path;
    lastName_anchorLink.innerHTML = json.last_name;
    lastName_td.appendChild(lastName_anchorLink);
    // contact details data
    contactDtls_td = document.createElement('td');
    var contactDtls_string = '';
    for(var i in json.contact_dtls)
       contactDtls_string += json.contact_dtls[i] + "<br />";
    contactDtls_string += "<a href='mailto:" + json.email + "'>" + json.email + "</a>"
    contactDtls_td.innerHTML = contactDtls_string;
    // Program Data
    program = document.createElement('td');
    program.appendChild(document.createTextNode(json.program));
    // append each data element to the row
    row.appendChild(photo_td);
    row.appendChild(firstName_td);
    row.appendChild(lastName_td);
    row.appendChild(contactDtls_td);
    row.appendChild(program);
    // append the row to the table
    $('#people_table tbody').append(row);
}


// build a single photoboook result row
function buildResultRowPhotoBookFormat(json){
    $(loadImage(json.image_uri))
        .appendTo($('<a class="photobook_item" href="' + json.path + '"/>'))
        // jQuery chaining refers always to the first element (so still img)
        .parent()
        // now you're in the photobook_item element
        .append($('<p class="photobook_item_name" />').html(json.first_name+" "+json.last_name))
        .appendTo('#photobook_results');
}


/****************************************
        HELPER FUNCTIONS
*****************************************/
// helper function to clear all tables
function clearAllTables () {
    // clear existing tables
    $('#people_table tbody').empty();
    $('#photobook_results').empty();

    // hide existing tables to possibly be re-displayed later
    $('#people_table').hide();
    $('#photobook_results').hide
    $("#empty_results").hide();

    // key_contacts_table will remain constant for a user, so no need of destroying it, just hiding/showing will do.
    $("#key_contacts_table").hide();
}
/*
    Based on the various toggles show the correct tables. Tables:
    // $("#key_contacts_table")
    // $('#people_table')
    // $('#photobook_results')
*/
function showRelevantTables(isSearchTextEntered) {
    if(last_search_results != ''){
    // if photobook toggled, show the table, hide everything else
        if (photobook_toggled && !ajax_req_issued) {
            $('#ajax_loading_notice').hide();
            $('#people_table').hide();
            $("#key_contacts_table").hide();
            $('#photobook_results').show();
        } else{
            $('#photobook_results').hide();
            $('#people_table').trigger("update"); 
            // while photobook uses the same table to show results, list view uses different tables
            if ( isSearchTextEntered && !ajax_req_issued){
                $('#ajax_loading_notice').hide();
                $('#people_table').show();
                $("#key_contacts_table").hide();
            } else if (!ajax_req_issued){
                $('#ajax_loading_notice').hide();
                // if advanced filters is visible
                if ($("#advanced_search_filters").is(":visible")) {
                    $('#people_table').show();
                    $('#people_table').trigger("update"); 
                }else{
                    $("#key_contacts_table").show();
                    $('#people_table').hide();
                }
            };
        };
    } else{
        $("#ajax_loading_notice").hide();
        if(isSearchTextEntered){
            // if no results returned, show a friendly warning message.
            clearAllTables();
            $("#empty_results").show();
        } else{
            // this handles a rare bug.  Return proper state when no search text entered.
            if(photobook_toggled)
                $('#photobook_results').show();
            else
                $("#key_contacts_table").show();
        }
    }
}

// helper function to build json data object for ajax calls
function buildDataObject() {
    var json = {};
    if ($("#advanced_search_filters").is(":visible")) {
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
                    ajaxCall : true
        };
    };
    return json;
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
            // alert('404 on image');
            // if there's some error in loading the image, load scotty dog instead
            img.src = "/images/mascot.jpg";
        }
    });
    $(img).attr('src',image_uri);
    return img;
}

