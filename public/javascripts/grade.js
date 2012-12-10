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
        for(var assignment_index=0; assignment_index < gradeHash.length; assignment_index ++){
          gradeArray[assignment_index] = this.to_number(gradeHash[assignment_index], assignment_index);
          if(gradeType == "weights")
            gradeArray[assignment_index] *= gradeWeight[assignment_index];
        }
        return gradeArray;
    };
    this.to_number = function(grade, assignment_index){
      if(typeof grade  == 'number') {
        return grade;
      }
      grade = $.trim(grade).toUpperCase();
      if( /[\d\.]+/.test(grade)){
        return parseFloat(grade);
      }
      if(grade in gradeMapping){
        if(gradeType == "points"){
          return gradeMapping[grade] * gradeWeight[assignment_index]/100;
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
    
    this.calculate_max = function(gradeHash){
      var total = 0;
      for(var assignment_index =0; assignment_index < gradeHash.length; assignment_index ++){
        if($.trim(gradeHash[assignment_index])=='')
          continue;
        if(gradeType == "weights")
          total += gradeWeight[assignment_index] * 100;
        else
          total += gradeWeight[assignment_index];
      }
      return total;
    };

    this.calculate_percentage = function(gradeHash){
        if(this.calculate_max(gradeHash) == 0) return "";
      return this.calculate(gradeHash)/this.calculate_max(gradeHash) * 100;
    };
    
    this.get_grades_for_student = function(student_id){
      var hash = [];
      $("tr#s_"+ student_id).find("input").each(function(){
        var assignment_id = $(this).attr("id").split("_")[1];
        if(assignment_id >= 0)
          hash.push($(this).val());
      });
      return hash;
    };
    this.earned_grade = function(student_id){
      var grades_hash = this.get_grades_for_student(student_id);
      var earned_grade = this.calculate(grades_hash);
      earned_grade = Math.round(earned_grade*100)/100;
      var percentage = Math.round(this.calculate_percentage(grades_hash) );
      var term = "pts";
      if(gradeType == "weights")
        term = "%";
      var text = earned_grade+ term;
      if(percentage != ""){
          text += " (" + percentage + "%)";
          $("tr#s_" +student_id + " .performance").text(this.get_final(percentage));
      }

        $("tr#s_"+student_id + " .earned").text(text);

      return earned_grade;
    };
    this.get_final = function(grade){
      if(isNaN(grade)) return "";
      //var order = gradeMapping.keys();
      var order = ["A", "A-", "B+", "B", "B-", "C+", "C", "C-"];
      var current = order[0];
      $.each(order,function(index, letter){
        if(grade < gradeMapping[letter])
          current = letter;
      });
      return current;
    };
    this.updateFinalGrade = function(student_id){
      var grades_hash = this.get_grades_for_student(student_id);
      var percentage = this.calculate_percentage(grades_hash);
      var final_grade = this.get_final(percentage);
      $("tr#s_"+student_id + " .final input").val(final_grade);
    };
}
