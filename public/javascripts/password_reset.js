/*
 *This page contains all relevant JS for the password reset pages
 */


// Helper function to validate reset form
function validateResetForm(){
    if ( ($("#primaryEmail").val()=="") || ($("#personalEmail").val()=="")  ){
        return warn_blank_fields()
    } else{
        return true
    }
}

// Helper function to validate edit form
function validateEditForm(){
    var newPass = $("#newPassword").val()
    var oldPass = $("#confirmPassword").val()
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