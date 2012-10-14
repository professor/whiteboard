$('#gradebook_submit').live('click', function() {
//    console.log("i m clicked");
    updateScore(true);


});

$('#gradebook_save_draft').live('click', function() {
//    console.log("saved draft");
    updateScore(false);

});


function updateScore(visible_to_student) {

    var data = {};
    data.scoreArrayList = [];
    data.scoreSubmitted=visible_to_student;
    data.courseAssignment={};
     if(visible_to_student==true){
        if($(".score [type=text]")!=null){
            var scoreList= $(".score [type=text]")[0];
            var attrId = scoreList.getAttribute('id');
            var course_id=attrId.split('_')[0];
            var assignment_id=attrId.split('_')[1];
            data.courseAssignment = {"course_id":course_id, "assignment_id":assignment_id}  ;
        }
     }


    if($('changedScore') != null){
        $('.changedScore').each(function(){
            var attrId = $(this).attr("id");
            var attrValue = $(this).val();
            var course_id=attrId.split('_')[0];
            var assignment_id=attrId.split('_')[1];
            var student_id=attrId.split('_')[2];
            data.scoreArrayList.push({"course_id":course_id, "assignment_id":assignment_id,"student_id":student_id,"score":attrValue,"is_student_visible":visible_to_student})  ;

        });
    }

//    console.log(data.scoreArrayList);

//
//       var my_course_id=$(location).attr('href');
//       my_course_id=my_course_id.split('/courses/')[1];
//       my_course_id=my_course_id.split('/')[0];
//       console.log("Course Id:  "+my_course_id);
////    var scoreList= $(".score [type=hidden]")[0];
////    var attrId = scoreList.getAttribute('id');

    $.ajax({
        type: 'POST',
        contentType: 'application/json',
        url: "grade_books/",
        dataType: "json",
        data: JSON.stringify(data, null, 1),
        success: function(data, message, jqXHR){
//            location.reload();
            $('#result').append('<p id="notice">Record submitted successfully</p>');
//            console.log('Submittion Successfull');
        },
        error: function(jqXHR, textStatus, errorThrown){
            console.log('Unable to submit the record');
        }
    });


};


$(document).ready(function() {
    console.log("I am loaded");
 //   console.log($(".score [type=text]"));
    $(".score [type=text]").live("change", function() {

          console.log($(this).attr('id'))  ;
//            var id = $(this).attr('id');
        var score = $(this).val();

        var previousValue = $(this)[0].defaultValue;
        if(previousValue != score)
        {
            console.log("different");
            $(this).css("border","thin solid");
            $(this).css("border-color","red");
            $(this).addClass("changedScore");

        }
        else
        {
            $(this).css("border","thin solid");
            $(this).css("border-color","#666666");
            $(this).removeClass("changedScore");

        }
    });
});



