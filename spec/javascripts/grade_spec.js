describe("Grade", function(){
  var weight = [0.1, 0.1, 0.1];
  var max_scores = [10, 10, 10];
  var mapping = {"A":100, "A-": 92, "B+": 90, "B": 87, "B-": 83, "C+": 78, "C": 73, "C-": 65};
  var gradeWeight;
  var gradePoints;
  beforeEach(function(){
    gradePoints = new Grade("points", mapping, max_scores);
    gradeWeight = new Grade("weight", mapping, weight);
  
  });
  
  describe("can construct ", function(){
    it("with points grade type", function(){
      expect(gradePoints.getType()).toEqual("points");
      expect(gradePoints.getMapping()).toEqual(mapping);
      expect(gradePoints.getWeight()).toEqual(max_scores);
    });

    it("with weight grade type", function(){
      expect(gradeWeight.getType()).toEqual("weight");
      expect(gradeWeight.getMapping()).toEqual(mapping);
      expect(gradeWeight.getWeight()).toEqual(weight);
    });
  });
  describe("can covert ", function(){ 
    var assignment_index = 0;

    it("from letter to number for points grade", function(){
      var assignment_index = 0;
      $.each(mapping, function( key, value){
        expect(gradePoints.to_number(key, assignment_index)).toEqual(mapping[key]*max_scores[assignment_index]/100);
      });
    });
    it("from letter to number for weighting grade", function(){
      $.each(mapping, function( key, value){
        expect(gradeWeight.to_number(key)).toEqual(mapping[key]);
      });
    });
    it("from string score to number", function(){
      expect(gradeWeight.to_number(" 90 ")).toEqual(90);
      expect(gradeWeight.to_number(" ")).toEqual(0);
      expect(gradePoints.to_number(" 90 ")).toEqual(90);
      expect(gradePoints.to_number(" ")).toEqual(0);
    });
    it("from number to number", function(){
      expect(gradeWeight.to_number(90)).toEqual(90);
      expect(gradePoints.to_number(90)).toEqual(90);
    });
  });
  it("can compute final grades from points to letter", function(){
    expect(gradeWeight.get_final(100)).toEqual("A");
    expect(gradeWeight.get_final(98)).toEqual("A");
    expect(gradeWeight.get_final(92)).toEqual("A");
    expect(gradeWeight.get_final(91)).toEqual("A-");
    expect(gradeWeight.get_final(90)).toEqual("A-");
    expect(gradeWeight.get_final(65)).toEqual("C");
    expect(gradeWeight.get_final(60)).toEqual("C-");
  });
  describe("can transform for grades array", function(){
    it("from combination weight array to points", function(){
      expect(gradeWeight.convert({0:"A", 1:" ", 2:"100"})).toEqual({0:10,1:0,2:10});
    });
    it("from combination points array to points", function(){
      expect(gradePoints.convert({0:"A", 1:" ", 2:"10"})).toEqual({0:10,1:0,2:10});
    });
  });
  describe("can compute earned grades", function(){
    it("for points", function(){
      expect(gradePoints.calculate({0:"", 1:"A ", 2:"10"})).toEqual(20);
    });
    it("for weight", function(){
      expect(gradeWeight.calculate({0:"",1:" A", 2:"100"})).toEqual(20);
    });
  });
  describe("can compute earned grade percentage", function(){
    it("for points", function(){
      expect(gradePoints.calculate_percentage({0:"", 1:"A ", 2:"10"})).toEqual(100);
    });
    it("for weight", function(){
      expect(gradeWeight.calculate_percentage({0:"",1:" A", 2:"100"})).toEqual(100);
    });
  });
  describe("can interact with table", function(){
    it("can fetch all grades for one person", function(){
      loadFixtures("gradebook.html");
      expect(gradePoints.get_grades_for_student(1)).toEqual({1:'1', 2:'2'});
      expect(gradePoints.get_grades_for_student(2)).toEqual({1:'3', 2:'4'});
    });
    it("can compute and update earned grade for a student", function(){
      loadFixtures("gradebook.html");
      var student_id = 1;
      expect(gradePoints.earned_grade(student_id)).toEqual(3);
      expect($("tr#s_"+student_id+ " .earned").text()).toEqual('3(15%)');
    });
    it("can compute and update final grade for a student", function(){
      loadFixtures("gradebook.html");
      var student_id = 1;
      gradePoints.updateFinalGrade(student_id);
      expect(gradePoints.get_final(student_id)).toEqual("C-");
      expect($("tr#s_"+student_id + " .final input").val()).toEqual("C-");
    });
  });
});
