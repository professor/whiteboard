/*
 *This page contains all relevant JS for the password reset pages
 */


// Helper function to validate reset form
function validatePasswordResetForm(){
    if ( ($("#cmu_mail").val()=="") || ($("#personal_mail").val()=="")  ){
        return warn_blank_fields()
    } else{
        return true
    }
}

// Helper function to validate edit form
function validatePasswordEditForm(){
    var newPass = $("#new_password").val()
    var oldPass = $("#confirm_password").val()
    if ((newPass==oldPass) && newPass!="") {
        return true
    }else{
        return warn_password_mismatch()

    }
}

// Warn if password mismatches
function warn_password_mismatch(){
    $("#password_mismatch_warning").empty()
    $("#password_mismatch_warning").append($('<div/>').css('color', 'red').text('Password mismatch'));
    return false
}

// Warn if email fields are blank
function warn_blank_fields(){
    $("#blank_email_warning").empty()
    $("#blank_email_warning").append($('<div/>').css('color', 'red').text('Blank fields are not allowed'));
    return false
}