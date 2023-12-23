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
#let authorFormat(seperator: " ,", format: "f", company: true, authors) = {
 first = authors.first()
 arr = authors.slice(1, authors.len() - 1)
 arr.fold(first, 
 )
}

#let _authorCases(format: "f", author: ()) = {
  if format == "f" {
    
  } else if format == "fMS" {

  } else if format == "fS" {

  } else if format == "fS" {

  } else if format == "oL" {

  }
}
