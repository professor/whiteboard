describe("Grade", function(){
  var weight = [0.1, 0.1, 0.1];
  var mapping = {"A":100, "A-": 92, "B+": 90, "B": 87, "B-": 83, "C+": 78, "C": 73, "C-": 65};
  var gradeWeight;
  var gradePoints;
  beforeEach(function(){
    gradePoints = new Grade("points", mapping, weight);
    gradeWeight = new Grade("weight", mapping, weight);
  
  });
  
  describe("can construct ", function(){
    it("with points grade type", function(){
      expect(gradePoints.getType()).toEqual("points");
      expect(gradePoints.getMapping()).toEqual(mapping);
      expect(gradePoints.getWeight()).toEqual(weight);
    });

    it("with weight grade type", function(){
      expect(gradeWeight.getType()).toEqual("weight");
      expect(gradeWeight.getMapping()).toEqual(mapping);
      expect(gradeWeight.getWeight()).toEqual(weight);
    });
  });
  describe("can covert ", function(){ 
    var assignment_index = 0;
    it("from points to letter", function(){
      expect(gradeWeight.get_letter(100)).toEqual("A");
      expect(gradeWeight.get_letter(98)).toEqual("A");
      expect(gradeWeight.get_letter(92)).toEqual("A");
      expect(gradeWeight.get_letter(91)).toEqual("A-");
      expect(gradeWeight.get_letter(90)).toEqual("A-");
    });

    it("from letter to number for points grade", function(){
      var assignment_index = 0;
      $.each(mapping, function( key, value){
        expect(gradePoints.to_number(key, assignment_index)).toEqual(mapping[key]*weight[assignment_index]);
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
  describe("can transform for grades array", function(){
    it("from weight to points", function(){
      expect(gradeWeight.convert({0:"A", 1:" ", 2:"100"})).toEqual({0:10,1:0,2:10});
    });
    it("from weight to points", function(){
      expect(gradePoints.convert({0:"A", 1:" ", 2:"100"})).toEqual({0:10,1:0,2:100});
    });
  });
  describe("can compute final grades", function(){
    it("for points", function(){
      expect(gradePoints.calculate({0:"", 1:"A ", 2:"10"})).toEqual(20);
    });
    it("for weight", function(){
      expect(gradeWeight.calculate({0:"",1:" A", 2:"100"})).toEqual(20);
    });
  });
  describe("can interact with table", function(){
    it("can fetch all grades for one person", function(){
      var grade = new Grade("points");
      loadFixtures("gradebook.html");
      expect(grade.get_grades_for_student(1)).toEqual({1:'1', 2:'2'});
      expect(grade.get_grades_for_student(2)).toEqual({1:'3', 2:'4'});
    });
    it("can compute and update earned grade for a student", function(){
      loadFixtures("gradebook.html");
      var grade = new Grade("points");
      var student_id = 1;
      expect(grade.earned_grade(student_id)).toEqual(3);
      expect($("tr#s_"+student_id+ " .earned").text()).toEqual('3');
    });
  });
});
