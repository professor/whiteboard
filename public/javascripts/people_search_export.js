/****************************************
        EXPORT VCARD FUNCTIONS
*****************************************/

jQuery(document).ready(function($) {
    $("#user_profile_show .export_button").live('click', function(){
        export_contact_dtls(true);
    });

    $("#people_search .export_button").live('click', function(){
        // export_contact_dtls_multiple();
        export_contact_dtls(false);
    });

});


function export_contact_dtls(isSingleContact){
    // if (isSingleContact){
    //     "http://"+window.location.hostname+':'+window.location.port+'/people_csv.csv?search_id='+ $("#person_id").val();
    //     "http://"+window.location.hostname+':'+window.location.port+'/people_vcf.vcf?search_id='+ $("#person_id").val();
    // }else{
    //     'people_csv.csv?filterBoxOne='+boxValue;
    //     'people_vcf?filterBoxOne='+boxValue;
    // }
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
                        window.location.href = 'people_csv.csv?filterBoxOne=' + $("#filterBoxOne").val();
                    }
                    $(this).dialog("close");
                },
                "vCard":function(){
                    if(isSingleContact){
                        window.location.href = "http://"+window.location.hostname+':'+window.location.port+'/people_vcf.vcf?search_id='+ $("#person_id").val();
                    }else{
                        window.location.href = 'people_vcf?filterBoxOne='+$("#filterBoxOne").val();
                    }
                    $(this).dialog("close");
                }
            }
        });
}