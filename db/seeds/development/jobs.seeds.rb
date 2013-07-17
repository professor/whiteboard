# Populate some sample jobs
# Not using Factory Girl for this as it is straight forward
[
  [
    "Semantic Harmonization of Smart Grid Concepts",
    %q(This project is in year 2 of a 3-year grant, and concerns the application of semantic modeling and querying techniques to demonstrate how the smart grid community can manage the large challenge of harmonizing definitions and relations among the standards being defined. The particular research will involve extending the work of Year 1, where a student developed a semantic query tool running on the Amazon cloud (see http://fsgim.sv.cmu.edu) that allowed arbitrarySPARQL queries to be applied to a model defined in OWL. A number of queries were predefined to allow people not familiar with SPARQL to explore the model. The point of this tool was to support validation of the model, checking, for example, how the datatypes were declared. Supporting this web application is a sophisticated commercial semantic modeling tool called TopBraid Composer, sold by TopQuadrant. In Year 2, we plan to: apply the same techniques to several other standards; extend the web query tool to allow navigation among the classes and relations via hyperlinks, using a technology called SPARQL Web Pages; explore automated suggestions for improvements to the models using automated reasoning techniques. You would be part of a team of four: one research faculty at CMU, two employees at TopQuadrant under contract to CMU, and yourself. You would be responsible for the web query tool. This project supports a major national effort to modernize the electrical grid, involving hundreds of companies and thousands of engineering professionals. You will have an opportunity to write a paper and present results at a national meeting. ),
    "Experience with interactive web page design using Javascript",
     "some experience with Semantic Web technology (RDF, OWL, SPARQL) would be preferred.",
     "Fall, Spring and Summer semesters, 10 hours per week. Would like a commitment for the full year.",
     false
  ],
  [
    "An Interchange Ontology for Mobile Sensor Platforms in Home Health Management",
    %q(This project is in year 2 of a 3-year grant, and concerns the application of ontological engineering methods to the use of mobile sensor platforms in the home health management domain. To date we have defined a simple ontology and a mapping to a standard (IEEE 11073) for exchanging health monitoring data, such as blood pressure, pulse rate, temperature, etc. This year we will explore two tasks: 1.    Building a proof of concept smart phone app that automatically converts health monitoring data into IEEE 11073-compatible form using the ontology, 2.    Apply automated reasoning techniques to validate portions of the IEEE 11073 standard after converting it into an OWLrepresentation.),
    "Experience with mobile device app development",
     "some experience with Semantic Web technology (RDF, OWL, SPARQL) would be preferred",
     " Fall, Spring and Summer semesters, 10 hours per week. Would like a commitment for the full year",
     true
  ],
  [
    "Ruby on Rails development",
    %q(We’ll be modifying and enhancing two open sourced Ruby on Rails websites. The first site is our education rails application. The second is a destination site for the software craftsmanship community. The student will also help promote the site with the community. Ideally, I'm looking for someone who loves working with Rails and may be interested in using it in their next job.),
    "Experience working with Ruby on Rails.",
     "",
     "Fall, Spring, and Summer semesters",
     false
  ]
  ].each do |job|
    Job.create(
      :title => job[0],
      :description => job[1],
      :skills_must_haves => job[2],
      :skills_nice_haves => job[3],
      :duration => job[4],
      :is_closed => job[8]
    )
  end
