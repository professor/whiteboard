describe("Grade", function(){
  it("can construct with letter grade type", function(){
      var grade = new Grade("letter", [0.1,0.1,0.1], {"A":100, "A-":92, "B+": 90});
      expect(grade.getType()).toEqual("letter");
      expect(grade.getWeight()).toEqual([0.1,0.1,0.1]);
      expect(grade.getMapping()).toEqual({"A":100, "A-":92, "B+": 90});
  });
    it("can construct with points grade type", function(){
        var grade = new Grade("points");
        expect(grade.getType()).toEqual("points");
    });
    it("can construct with weight grade type", function(){
        var grade = new Grade("weight", [0.1,0.1,0.1]);
        expect(grade.getType()).toEqual("weight");
        expect(grade.getWeight()).toEqual([0.1,0.1,0.1]);
    });
    it("can convert weight to points", function(){
        var grade = new Grade("weight", [0.1,0.1,0.1]);
      expect(grade.convert({0:"100", 2:"100"})).toEqual({0:10,2:10});
    });
    it("can compute final grades for points", function(){
        var grade = new Grade("points");
        expect(grade.calculate({0:"100", 2:"100"})).toEqual(200);
    });
    it("can compute final grades for weight", function(){
        var grade = new Grade("weight", [0.1,0.1,0.1]);
        expect(grade.calculate({0:"100", 2:"100"})).toEqual(20);
    });
    it("can compute final grades for letter", function(){
        var grade = new Grade("letter", [0.1,0.1,0.1], {"A":100, "A-":92, "B+": 90});
        expect(grade.calculate({0:"A", 2:"B+"})).toEqual(19);
    });
});
