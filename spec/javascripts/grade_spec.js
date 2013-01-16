describe("Grade", function(){
  var weight = [0.1, 0.1, 0.1];
  var max_scores = [10, 10, 10];
  var mapping = {"A":100, "A-": 92, "B+": 90, "B": 87, "B-": 83, "C+": 78, "C": 73, "C-": 65};
  var gradeWeight;
  var gradePoints;
  var student100Weight = ["A", "100", ""];
  var student50Weight = ["50", "50", ""];
  var student100Points = ["A", "10", ""];
  var student50Points = ["5", "5", ""];
  beforeEach(function(){
    gradePoints = new Grade("points", mapping, max_scores);
    gradeWeight = new Grade("weights", mapping, weight);
  
  });
  
  describe("can construct ", function(){
    it("with points grade type", function(){
      expect(gradePoints.getType()).toEqual("points");
      expect(gradePoints.getMapping()).toEqual(mapping);
      expect(gradePoints.getWeight()).toEqual(max_scores);
    });

    it("with weight grade type", function(){
      expect(gradeWeight.getType()).toEqual("weights");
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
      expect(gradeWeight.convert(student100Weight)).toEqual([10,10,0]);
      expect(gradeWeight.convert(student50Weight)).toEqual([5,5,0]);
    });
    it("from combination points array to points", function(){
      expect(gradePoints.convert(student100Points)).toEqual([10,10,0]);
      expect(gradePoints.convert(student50Points)).toEqual([5,5,0]);
    });
  });
  describe("can compute earned grades", function(){
    it("for points", function(){
      expect(gradePoints.calculate(student100Points)).toEqual(20);
      expect(gradePoints.calculate(student50Points)).toEqual(10);
    });
    it("for weight", function(){
      expect(gradeWeight.calculate(student100Weight)).toEqual(20);
    expect(gradeWeight.calculate(student50Weight)).toEqual(10);
    });
  });
  it("can compute could earned max grades", function(){
    expect(gradePoints.calculate_max(student100Points)).toEqual(20);
    expect(gradePoints.calculate_max(student50Points)).toEqual(20);
    expect(gradeWeight.calculate_max(student100Weight)).toEqual(20);
    expect(gradeWeight.calculate_max(student50Weight)).toEqual(20);
  });
  describe("can compute earned grade percentage", function(){
    it("for points", function(){
      expect(gradePoints.calculate_percentage(student100Points)).toEqual(100);
      expect(gradePoints.calculate_percentage(student50Points)).toEqual(50);
    });
    it("for weight", function(){
      expect(gradeWeight.calculate_percentage(student100Weight)).toEqual(100);
      expect(gradeWeight.calculate_percentage(student50Weight)).toEqual(50);
    });
  });
  describe("can interact with table", function(){
    it("can fetch all grades for one person", function(){
      loadFixtures("gradebook.html");
      expect(gradePoints.get_grades_for_student(1)).toEqual(['10', 'A']);
      expect(gradeWeight.get_grades_for_student(2)).toEqual(['100', 'A']);
    });
    it("can compute and update earned grade for a student", function(){
      loadFixtures("gradebook.html");
      var student_id = 1;
      expect(gradePoints.earned_grade(1)).toEqual(20);
      expect($("tr#s_1 .earned").text()).toEqual('20pts (100%)');
      expect(gradeWeight.earned_grade(2)).toEqual(20);
      expect($("tr#s_2 .earned").text()).toEqual('20% (100%)');
    });
    it("can compute and update final grade for a student", function(){
      console.log("Student 1");
      loadFixtures("gradebook.html");
      gradePoints.updateFinalGrade(1);
      expect($("tr#s_1 .final input").val()).toEqual("A");
      console.log("Student 2");
      gradeWeight.updateFinalGrade(2);
      expect($("tr#s_2 .final input").val()).toEqual("A");
    });
  });
});
