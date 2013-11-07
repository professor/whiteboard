var showAjaxError = function (error_message) {
    var errorElement = '' +
        '<div class="ui-widget" data-error="ajaxError">' +
        '<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;">' +
        '<p style="color: red; margin-top: 5px;">' +
        '<span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>' +
        error_message.toString() +
        '</p>' +
        '</div>' +
        '</div>'

    // clear error messages before setting a new one
    $('div[data-error="ajaxError"]').remove();
    $(errorElement).prependTo('#mainContent .content');
};

var hideAjaxError = function () {
    $('div[data-error="ajaxError"]').remove();
};