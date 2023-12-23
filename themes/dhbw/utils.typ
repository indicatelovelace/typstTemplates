#import "@preview/drafting:0.1.1": *
// Get the page (counter value, not real page number) for a selector
// e. g. #page_ref(<lst:hello-world>)
#let page_ref(selector) = {
  locate(loc => {
    // Get the `location` of the element
    let element_location = query(selector, loc)
    .first()
    .location()

    // Get the page number, the location lies on
    link(element_location)[#counter(page).at(element_location).first()]
  })
}

// format is one of:
// f Robert James Oppenheimer
// fMS Robert J. Oppenheimer
// fS R. J. Oppenheimer
// s R. J. Oppenheimer
// oL Oppenheimer
//#let authorFormat(seperator: " ,", format: f, company: true, authors) = {
//  first = authors.first()
//  arr = authors.slice(1, authors.len() - 1)
//  arr.fold(first, 
//  )
//}
//
//#let _authorCases(format: f, author) {
//  if format == f author.name
//  else if format == fMS author.name
//}

#let reduceAuthors(authors) = {
  authors = authors.sorted(key: author => author.name)
  let names = ()
  let matrNums = ()
  let courseS = ()
  let courseL = ()
  let period = ()
  let evaluators = ()
  let submissionDate = ()
  for author in authors {
    names.push(author.name)
  }
  for author in authors {
    matrNums.push(author.matriculationNumber)
  }
  for author in authors {
    courseS.push(author.courseShort)
  }
  for author in authors {
    courseL.push(author.courseName)
  }
  for author in authors {
    evaluators.push(author.at("evaluator", default: none))
  }
  for author in authors {
    period.push(author.at("period", default: none))
  }
  for author in authors {
    submissionDate.push(author.at("submissionDate", default: none))
  }
  (
  name: names.join(", "),
  matriculationNumber: matrNums.map(str).join(", "),
  courseShort: courseS.dedup().join(", "),
  courseName: courseL.dedup().join(", "),
  evaluator: evaluators.filter(x => x != none).first(),
  period: period.filter(x => x != none).first(),
  submissionDate: submissionDate.filter(x => x != none).first(),
  company: none,
  companyAdvisor: none,
  )
}

