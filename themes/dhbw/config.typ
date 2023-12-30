#import "@preview/drafting:0.1.1": *
#import "./utils.typ": authorMetadata, flattenAuthorMetadata

#let conf(
  title: none,
  authors: (), /*
   author is an array of dicts. The only key that is necessary is "name".
  Any other property supplied is printed at the bottom end of the page, as per the guidelines, in the format "#key: #value", in the given order. For multiple authors, this data is collected, deduplicated, and either displayed as per usual or, if possible, listed as line seperated values.
  */
  courseName: none,
  submissionDate: datetime.today().display(), // expects content, not a datetime, so use .display()
  thesisType: none, // e.g Bachelor Thesis
  companyLogo: [], // expects any content, e.g. an image
  universityLogo: [],
  university: none, // e.g. DHBW Ravensburg

  abstractTitle: none, // No abstract if none
  abstract: none,
  appendix: none, // no appendix if none
  glossary: none, // the user is expected to create their own glossarium, with a package of their choice, or by hand. This can of course also include an list of symbols etc. No glossarium is printed if none
  bibliographyTitle: none, // No bibliography if none
  bibliographyFiles: (),
  bibliographyStyle: "ieee",
  declarationOnHonour: true,
  draft: true,
  language: "de", // enable language-specific quotes with ISO 639-1/2/3 language code
  font: "IBM Plex Serif",
  fontSize: 12pt,
  outlines: ((none, none),), // e.g. (table, "List of Tables") in the submitted order
  equationTitle: none, // no equation table if none, equations are not a regular figure, only block equations are listed
  equationSupplement: none, // no eqution supplement if none
  
  doc,
) = {
  let author = authorMetadata(authors)
  let name = author.remove("name").join(", ")
  
  set page(
    paper: "a4",
    number-align: right,
    margin: (rest: 2.5cm),
  )
  
  set text(
    lang: language,
    region: language,
    font: font,
    size: fontSize,
  )
  
  // Add some spacing between figures and caption
  set figure(
    gap: 1.2em
  )

  show figure: it => {
    v(0.5em)
    it
    v(0.5em)
  }

  // Add numbering to equations
  if equationSupplement != none {
    set math.equation(numbering: "(1)", supplement: equationSupplement)
  } else {
    set math.equation(numbering: none, supplement: none)
  }
  
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
  if draft == true {
    set-page-properties(margin-left: 2.5cm, margin-right: 2.5cm)
  }

  // Print company and / or university logo, if given
  grid(
    columns: (30%, 40%, 30%),
    //rows: (), TODO
    if companyLogo != none {
      companyLogo
    },
    [],
    if universityLogo != none {
      universityLogo
    }
  )

  // Print author and university information
  text(hyphenate: false)[
  #align(center, [
    //#v(2%)
    #v(3em)
    #text(size: 14pt, title )
    #v(4em)
    #text(weight: "bold", upper(thesisType)) \
    #v(11em)
    #if courseName != none [#if language == "de" [des Studiengangs] else [of the degree programm] #text(courseName, weight: "bold")]

    #if language == "de" [an der ] else [at the] #university
    #v(4em)
    #if language == "de" [von] else [by]

    #v(1em)
    #text(name, weight: "bold")

    #v(4em)
    #submissionDate
  ])

  #align(bottom + left, [
    #table(
      columns: (50%, 50%),
      align: (x, y) => (left, left).at(x),
      stroke: none,
      ..flattenAuthorMetadata(dict: author)
    )
  ])]

  // Enable page numbers starting by declatation on honour, with roman numbering
  counter(page).update(0)
  set page(numbering: "I")

  if declarationOnHonour {
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
      if language == "de" [Ort, Datum] else [Location, Date],
      [],
      [#name]
    )
  }

  // Prints the outline for figures with given name only if at least one item of that kind exists
  let printOutlineIfContentExists(title, kind) = {
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

  // Outlines for equations
  let printOutlineIfEquationExists(title) = {
    locate(loc => {
      let elems = query(math.equation.where(block: true), loc)
      let count = elems.len()
      if count > 0 and title != none {
        par(first-line-indent: 0em, leading: 1em)[
          #heading(level: 1, numbering: none)[#title]
          #outline(
            title: none,
            target: math.equation.where(block: true),
          )
        ]
      }
    })
  }
  set page(
    header: [
    #locate(loc => {
      let head = query(selector(heading).after(loc), loc).find(h => {
       h.location().page() == loc.page() and h.level == 1
      })
      if (head != none) {
      } else {
        let l1h = query(selector(heading).before(loc), loc).filter(headIt => {
          headIt.level == 1
        })
        let oldHead = if l1h != () {l1h.last().body} else {[]}
        let count = counter(heading.where(level: 1)).display()
        set align(right)
        set text(font: "Linux Libertine")
        smallcaps[#count #oldHead]
      }
    })
  ])

  if abstractTitle != none {
    par(first-line-indent: 0em)[
      #heading(level: 1, outlined: false, numbering: none)[#abstractTitle]
      #abstract
    ]
  }

  // Outline / Table of contents
  par(first-line-indent: 0em, leading: 1em)[
    #outline(depth: 3, indent: true)
  ]

  for (name, kind) in outlines {
    printOutlineIfContentExists(name, kind)
  }

  printOutlineIfEquationExists(equationTitle)

  glossary

  // Use arabic numbering for content
  set page(numbering: "1")
  counter(page).update(1)

  // Display paper content
  doc

  pagebreak(weak: true)
  if bibliographyFiles.len() > 0 and bibliographyTitle != none {
    bibliography(title: bibliographyTitle, full: true, bibliographyFiles)
  }

  if appendix != none {
    counter(heading).update(0)
    show heading: it => {
      if it.level > 1 {
        set heading(outlined: false, supplement: none)
      }
      set heading(numbering: "A.1")
      it
    }
    appendix
  }
}
