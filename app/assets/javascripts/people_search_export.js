/****************************************
    EXPORT CONTACT DETAILS FUNCTIONS
*****************************************/

jQuery(document).ready(function($) {
    // export a single user's contact details (from the user profile page)
    $("#user_profile_show").on('click','.export_button', function(){
        export_contact_dtls(true);
    });
    // export multiple contact details (from the people search results page)
    $("#people_search").on('click', '.export_button', function(){
        export_contact_dtls(false);
    });
    // same as export multiple but done from the button on search filter bar
    $("#filterBoxOne_export_contacts").click(function(){
        export_contact_dtls(false);
    });

});

// Export contact details from the people search results page (multiple) or user profile page (single)
function export_contact_dtls(isSingleContact){
    // export the results only for the search parameters chosen by user.
    var search_params = '';
    if (!isSingleContact){
        search_params='filterBoxOne='+ $("#filterBoxOne").val();
        // advanced_search_toggled will only be available for multiple contacts -- see people_search.js
        if(advanced_search_toggled){
            search_params+=
            '&user_type='+   $("#filter_person_type").val()+
            '&graduation_year='+ $("#filter_year").val()+
            '&masters_program='+ $("#filter_program").val()+
            '&course_id='+ $("#filter_course").val()+
            '&search_inactive='+ $('#search_inactive:checked').val()+
            '&advanced_search_toggled=true';
        }
    }
    // export pop-up dialog
    var $dialog = $('<div></div>')
        .html('Which format do you wish to export to?')
        .dialog({
            autoOpen: true,
            resizable: false,
            draggable: false,
            width: 100,
            height: 130,
            modal: true,
            title: 'Export contact(s)',
            buttons:{
                "CSV":function(){
                    if (isSingleContact){
                        window.location.href = "http://"+window.location.hostname+':'+window.location.port+'/people_csv.csv?search_id='+$("#person_id").val();
                    }else{
                        window.location.href = 'people_csv.csv?' + search_params;
                    }
                    $(this).dialog("close");
                },
                "vCard":function(){
                    if(isSingleContact){
                        window.location.href = "http://"+window.location.hostname+':'+window.location.port+'/people_vcf.vcf?search_id='+ $("#person_id").val();
                    }else{
                        window.location.href = 'people_vcf?'+ search_params;
                    }
                    $(this).dialog("close");
                }
            }
        });
}