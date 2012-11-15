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


}