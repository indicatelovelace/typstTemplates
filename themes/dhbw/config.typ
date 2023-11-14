#let conf(
  title: none,
  authors: (),
  university: none,
  abstract: [],
  language: "de", // enable language-specific quotes with ISO 639-1/2/3 language code.
  font: "IBM Plex Sans",
  font_size: 12pt,
  outlines: ((none, none),),
  thesis_type: none,
  course: none,
  field_of_studies: none,
  company_logo: (path: none, alternative_text: none),
  university_logo: (path: none, alternative_text: none),
  bibliography-file: none,
  bibliography-style: "ieee",
  declaration_on_honour: true,
  doc,
) = {
  //===========================================================================
  // Layout configuration
  //===========================================================================
  
  set page(
    paper: "a4",
    number-align: right,
    margin: (rest: 2.5cm)
  )
  
  set text(
    lang: language,
    region: language,
    font: font,
    size: font_size, // Weird font size to achieve about the same line length as with 12pt Arial in Word
  )
  
  // Add some spacing between figures and caption
  set figure(
    gap: 1em
  )
  
  // Add numbering to equations
  set math.equation(numbering: "(1)")
  
  // leading is line spacing
  set par(first-line-indent: 1em, leading: 1.5em)
  
  // Configure headings.
  set heading(numbering: "1.1")
  
  show heading: it => {
    let first = true;
    // Don't indent headings
    set par(first-line-indent: 0em)
  
    // Set some defaults
    set text(weight: "bold")
    let size = 1em
    let style = "normal"
  
    // Set size and style based on the heading level
    if (it.level == 1) {
      size = 1.5em
      locate(loc => {
        // Pagebreak for all except the first numbered headline
        // The first numbered headline receives the pagebreak
        // implicit via page counter update (I guess?)
        let levels = counter(heading).at(loc)
        if levels != (1,) {
          pagebreak(weak: true)
        }
      })
    } else if (it.level == 2) {
      size = 1.3em
    } else if (it.level == 3) {
      size = 1.2em
    } else {
      style = "italic"
    }
  
    // Apply styling defined in the condition above
    set text(size: size, style: style)
  
    // Some spacing above the heading
    v(size / 2, weak: false)
  
    // Display heading numbers until level four, if numbering is enabled
    // Shouldn't really use more than three heading levels, so no more from level four onwards!
    if it.numbering != none and it.level < 4 {
      counter(heading).display()
      h(0.75em, weak: true)
    }
    // Print the heading itself
    it.body
  
    // Some spacing below the heading
    v(size / 2, weak: false)
  }

  //===========================================================================
  // Titlepage
  //===========================================================================

  // Template supports only one author, as it is made for a bachelor thesis!
  let author = authors.first()

  // Print company and / or university logo, if given
  grid(
    columns: (30%, 40%, 30%),
    if company_logo.path != none and company_logo.path != "" {
      image(company_logo.path, width: 100%)
    },
    [],
    if university_logo.path != none and university_logo.path != "" {
      image(university_logo.path, width: 100%)
    }
  )

  // Print author and university information
  align(center, [
    //#v(2%)
    #v(3em)
    #text(size: 14pt, title )
    #v(4em)
    #text(weight: "bold", upper(thesis_type)) \
    #v(11em)
    #if language == "de" [des Studiengangs] else [of the degree programm] #text(author.course_name, weight: "bold")

    #if language == "de" [an der ] else [at the] #university
    #v(4em)
    by

    #v(1em)
    #text(author.name, weight: "bold")

    #v(4em)
    #author.submission_date
  ])

  align(bottom + left, [
    #table(
      columns: (50%, 50%),
      align: (x, y) => (left, left).at(x),
      stroke: none,
//      if author.submission_date != none [#if language == "de" [Eingereicht am:] else [Submission date:]], [#author.submission_date],
    //  if author.department != none [#if language == "de" [Abteilung:] else [Department:]], [#author.department],
    if author.period != none [#if language == "de" [Bearbeitungszeitraum:] else [Editing period:]], [#author.period],
    if author.matriculation_number != none and author.course_abbr != none [#if language == "de" [Matrikelnummer, Kurs:] else [Matriculation number, Course:]], [#author.matriculation_number, #author.course_abbr],
    if author.company != none [#if language == "de" [Firma:] else [Company:]], [#author.company],
    if author.company_advisor != none [#if language == "de" [Betreuer der Ausbildungsfirma:] else [Company Advisor:]], [#author.company_advisor],
    if author.evaluator != none [#if language == "de" [Gutachter der Dualen Hochschule:] else [Evaluator of the University:]], [#author.evaluator],
    )
  ])

  // Enable page numbers starting by declatation on honour, with roman numbering
  counter(page).update(0)
  set page(numbering: "I")

  //===========================================================================
  // Declaration of honour
  //===========================================================================
  if declaration_on_honour {
    heading(level: 1, outlined: false, numbering: none)[
      #if language == "de" [Ehrenwörtliche Erklärung] else [Declaration on honour]
    ]
    par(first-line-indent: 0em,
      if language == "de" [
        Ich versichere hiermit, dass ich die vorliegende Arbeit mit dem Titel "#title" selbstständig verfasst und
        keine anderen als die angegebenen Quellen und Hilfsmittel benutzt habe. Ich versichere zudem, dass die
        eingereichte elektronische Fassung mit der gedruckten Fassung übereinstimmt.
      ] else  [
        I hereby declare that this project thesis with the topic "#title" is entirely the product of my own scholarly work,
        unless otherwise indicated in the text or references or acknowledged below. I also assure that the submitted
        electronic version is the same version as the printed version.
      ]
    )
    v(8em)

    grid(
      columns: (auto, 1fr, auto),
      if language == "de" [OrEditing period:t, Datum] else [Location, Date],
      [],
      [#author.name]
    )
  }

  //===========================================================================
  // Registers / Outlines
  //===========================================================================

  // Prints the outline for figures with given name only if at least one item of that kind exists
  let print_outline_if_content_exists(title, kind) = {
    locate(loc => {
      let elems = query(figure.where(kind: kind), loc)
      let count = elems.len()
      if count > 0 {
        par(first-line-indent: 0em, leading: 1em)[
          #heading(level: 1, numbering: none)[#title]
          #outline(
            title: none,
            target: figure.where(kind: kind),
          )
        ]
      }
    })
  }

  // Outline / Table of contents
  par(first-line-indent: 0em, leading: 1em)[
    #outline(depth: 3, indent: true)
  ]

  for (name, kind) in outlines {
    print_outline_if_content_exists(name, kind)
  }

  //===========================================================================
  // Abstract
  //===========================================================================

  // Print only non empty abstract
  if abstract != none and abstract != "" {
    par(first-line-indent: 0em)[
      #heading(level: 1, outlined: false, numbering: none)[Abstract]
      #abstract
    ]
  }

  //===========================================================================
  // Content
  //===========================================================================

  // Use arabic numbering for content
  set page(numbering: "1")
  counter(page).update(1)

  // Display paper content
  doc
}
