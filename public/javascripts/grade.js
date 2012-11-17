function Grade(type, mapping, weight)
{

    var gradeType = type;
    var gradeMapping = mapping;
    var gradeWeight = weight;

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
        for(var assignment_index in gradeHash){
          gradeArray[assignment_index] = this.to_number(gradeHash[assignment_index], assignment_index);
          if(gradeType == "weight")
            gradeArray[assignment_index] *= gradeWeight[assignment_index];
        }
        return gradeArray;
    };
    this.to_number = function(grade, assignment_index){
      if(typeof grade  == 'number') {
        return grade;
      }
      grade = $.trim(grade);
      if( /[\d\.]+/.test(grade)){
        return parseFloat(grade);
      }
      if(grade in gradeMapping){
        if(gradeType == "points"){
          return gradeMapping[grade] * gradeWeight[assignment_index];
        }
        else{
          return gradeMapping[grade];
        }
      }
      return 0;
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
      earned_grade = Math.round(earned_grade*100)/100;
      if(gradeType =="letter") earned_grade = this.get_letter(earned_grade);
      $("tr#s_"+student_id + " .earned").text(earned_grade);
      return earned_grade;
    };
    this.get_letter = function(grade){
      if(isNaN(grade)) return "";
      var order = ["A", "A-", "B+", "B", "B-", "C+", "C", "C-"];
      var current = order[0];
      $.each(order,function(index, letter){
        if(grade < gradeMapping[letter])
          current = letter;
      });
      return current;
    };

}
