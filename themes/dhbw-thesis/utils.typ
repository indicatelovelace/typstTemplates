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

// (name: Gustav Grönberg, number: 4532, class: A1)
// (name: Simon Grönberg, number: 3332, class: A1, lead: Simon Grönberg)
// (name: [Gustav Grönberg, Simon Grönberg], number: (4532, 3332), class: (A1, A1), lead: (Simon Grönberg))
#let authorMetadata(authors) = {
  let commonKeys = authors.fold((:), (dic, auth) => {
    for (key, value) in auth {
      dic.insert(key, dic.at(key, default: ()) + (value,))
    }
    dic
  })
  commonKeys
}

#let flattenAuthorMetadata(dict: (:)) = {
  let metadata = dict.pairs().map(pair => {
    let key = pair.at(1).dedup()
    (strong(pair.at(0)), key.at(0)) + key.slice(1).map(it => {
      if it != none {
        ([], it)
      }
      }).flatten()
  })
  metadata.flatten()
}


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

