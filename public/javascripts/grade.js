function Grade(type)
{

    var gradeType = type;
    var gradeWeight;
    var gradeMapping;
    if(arguments.length > 1)
        gradeWeight = arguments[1];
    if(arguments.length > 2)
        gradeMapping = arguments[2];



    this.getType = function(){
        return gradeType;
    };
    this.getWeight = function(){
        return gradeWeight;
    };
    this.getMapping = function(){
        return gradeMapping;
    };
    this.convert = function(gradeHash){
        var gradeArray = [];
        for (var assignment_index in gradeHash) {
            if(gradeType == "letter"){
                gradeHash[assignment_index] = gradeMapping[gradeHash[assignment_index]];
            }
            else{
             gradeHash[assignment_index] = parseFloat(gradeHash[assignment_index]);
            }
        }
        if(gradeType == "points")
            return gradeHash;

        for (var assignment_index in gradeHash) {
            gradeArray[assignment_index] = gradeHash[assignment_index] * gradeWeight[assignment_index];
        }
        return gradeArray;
    };
    this.calculate = function(gradeHash){
      var total = 0;
            var gradeArray = this.convert(gradeHash);


        for (var assignment_index in gradeArray) {
            total += gradeArray[assignment_index];
        }
        return total;
    };
    this.get_grades_for_student = function(student_id){
      var hash = {};
      $("tr#s_"+ student_id).find("input").each(function(){
        var assignment_id = $(this).attr("id").split("_")[1];
        hash[assignment_id] = $(this).val();
      });
      return hash;
    };
    this.earned_grade = function(student_id){
      var grades_hash = this.get_grades_for_student(student_id);
      var earned_grade = this.calculate(grades_hash);
      $("tr#s_"+student_id + " .earned").text(earned_grade);
      return earned_grade;
    }

}
