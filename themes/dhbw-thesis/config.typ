#import "./utils.typ": authorMetadata, flattenAuthorMetadata

#let conf(
  title: none,
  authors: (), /*
                author is an array of dicts. The only key that is necessary is "name".
               Any other property supplied is printed at the bottom end of the page, as per the guidelines, in the format "#key: #value", in the given order. For multiple authors, this data is collected, deduplicated, and either displayed as per usual or, if possible, listed as line seperated values.
               */
  courseName: none,
  submissionDate: datetime.today().display(), // expects content, not a datetime, so use .display()
  submissionPlace: "Musterort",
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
  storageDeclaration: true,
  language: "en", // enable language-specific quotes with ISO 639-1/2/3 language code
  font: "IBM Plex Serif",
  fontSize: 12pt,
  smallcapsFont: "Linux Libertine",
  mathFont: "IBM Plex Serif",
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
  set figure(gap: 1.2em)

  show outline: it => {
    set par(first-line-indent: 0em, leading: 1em, justify: false, linebreaks: "simple")
    show ref: x => none
    it
  }

  show figure: set block(above: 2.0em, below: 2.0em, breakable: false)

  show figure.where(kind: image): it => {
    set align(center)
    set text(font: "IBM Plex Sans")
    set par(leading: 0.5em)
    block[#it.body #text(font: font)[#it.caption] + v(0em)]
  }

  show math.equation: set text(font: mathFont)

  // Add numbering to equations
  if equationSupplement != none {
    set math.equation(numbering: "(1)", supplement: equationSupplement)
  } else {
    set math.equation(numbering: none, supplement: none)
  }

  // leading is line spacing
  set par(first-line-indent: 1em, leading: 1.5em, justify: true, linebreaks: "optimized")

  show raw.where(block: true): it => {
    set block(above: 1em, below: 1em)
    it
  }

  show raw: it => {
    set figure(supplement: [Command Line Output])
    it
  }

  show table: it => {
    set par(first-line-indent: 0em, hanging-indent: 0em, justify: false, leading: 0.7em)
    it
  }

  set table.header(repeat: true)

  // Configure headings.
  set heading(numbering: "1.1")

  show heading: it => {
    context {
      let first = true
      // Don't indent headings
      // Set some defaults
      set text(weight: "bold")
      let size = 1em
      let style = "normal"

      set par(first-line-indent: 0em)

      if (it.level == 1) {
        size = 1.5em
        let levels = counter(heading).at(here())
        if levels != (1,) {
          pagebreak(weak: true)
        }
      } else if (it.level == 2) {
        size = 1.3em
      } else if (it.level == 3) {
        size = 1.2em
      } else {
        style = "italic"
      }
      set text(size: size, style: style)
      // Some spacing below the heading

      // Apply styling defined in the condition above

      // Some spacing above the heading
      v(size / 2, weak: false)
      if it.numbering != none and it.level < 4 {
        counter(heading).display()
        h(0.75em, weak: true)
      }
      it.body
      v(size / 2, weak: false)
      // Display heading numbers until level four, if numbering is enabled
      // Shouldn't really use more than three heading levels, so no more from level four onwards!
    }
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
    #align(
      center,
      [
        //#v(2%)
        #v(3em)
        #text(size: 14pt, title)
        #v(4em)
        #text(weight: "bold", upper(thesisType)) \
        #v(11em)
        #if courseName != none [#if language == "de" [des Studiengangs] else [of the degree programm] #text(
            courseName,
            weight: "bold",
          )]

        #if language == "de" [an der ] else [at the] #university
        #v(4em)
        #if language == "de" [von] else [by]

        #v(1em)
        #text(name, weight: "bold")

        #v(4em)
        #submissionDate
      ],
    )

    #align(
      bottom + left,
      [
        #table(
          columns: (50%, 50%),
          align: (x, y) => (left, left).at(x),
          stroke: none,
          ..flattenAuthorMetadata(dict: author)
        )
      ],
    )]

  // Enable page numbers starting by declatation on honour, with roman numbering
  counter(page).update(0)
  set page(
    numbering: "I",
    header: context {
      set align(right)
      let head = query(selector(heading).after(here())).find(h => {
        h.location().page() == here().page() and h.level == 1
      })
      if (head != none) { } else {
        let l1h = query(selector(heading).before(here())).filter(headIt => {
          headIt.level == 1
        })
        let oldHead = if l1h != () {
          l1h.last().body
        } else {
          []
        }
        let count = counter(heading.where(level: 1)).display()
        if l1h.last().numbering != "1.1" {
          count = []
        }
        set align(right)
        set text(font: smallcapsFont)
        smallcaps[#count #oldHead]
      }
    },
  )

  if storageDeclaration {
    heading(level: 1, outlined: false, numbering: none)[
      #text(lang: "de")[Erklärung zur unbegrenzten Aufbewahrung]
    ]
    par(
      first-line-indent: 0em,
      text(lang: "de")[
        Hiermit genehmigen die Autoren der Arbeit eine unbefristete Aufbewahrung durch den Studiengang #courseName und durch die Betreuenden.
      ],
    )
    v(8em)

    for n in name.split(",") {
      (
        grid(
          columns: (auto, auto),
          column-gutter: 1fr,
          row-gutter: 20pt,
          [#submissionPlace, #submissionDate], [],
          [_Ort, Datum_], emph[#n],
        )
          + v(40pt)
      )
    }
  }

  if declarationOnHonour {
    heading(level: 1, outlined: false, numbering: none)[
      Ehrenwörtliche Erklärung
    ]
    par(
      first-line-indent: 0em,
      text(lang: "de")[
        Ich versichere hiermit, dass ich die vorliegende Arbeit mit dem Titel
        \ #strong(title) \
        selbstständig verfasst und keine anderen als die angegebenen Quellen und Hilfsmittel benutzt habe.
      ],
    )
    v(8em)

    for n in name.split(",") {
      (
        grid(
          columns: (auto, auto),
          column-gutter: 1fr,
          row-gutter: 20pt,
          [#submissionPlace, #submissionDate], [],
          [_Ort, Datum_], emph[#n],
        )
          + v(40pt)
      )
    }
  }

  // Prints the outline for figures with given name only if at least one item of that kind exists
  let printOutlineIfContentExists(title, kind) = {
    context {
      let elems = query(figure.where(kind: kind))
      let count = elems.len()
      if count > 0 {
        set par(first-line-indent: 0em, leading: 1em)
        [
          #heading(level: 1, numbering: none)[#title]
          #outline(
            title: none,
            target: figure.where(kind: kind),
          )
        ]
      }
    }
  }

  // Outlines for equations
  let printOutlineIfEquationExists(title) = {
    context {
      let elems = query(math.equation.where(block: true))
      let count = elems.len()
      if count > 0 and title != none {
        par(first-line-indent: 0em, leading: 1em)[
          title#heading(level: 1, numbering: none)[#title]
          #outline(
            title: none,
            target: math.equation.where(block: true),
          )
        ]
      }
    }
  }

  set par(spacing: 1.8em)

  if abstractTitle != none {
    par(first-line-indent: 0em)[
      #heading(level: 1, outlined: false, numbering: none)[#abstractTitle]
      #abstract
    ]
  }


  // Outline / Table of contents
  // TODO: customize
  outline(depth: 3, indent: 1em)

  for (name, kind) in outlines {
    printOutlineIfContentExists(name, kind)
  }

  printOutlineIfEquationExists(equationTitle)

  {
    set par(leading: 1em, spacing: 1em)
    glossary
  }

  counter(page).update(1)

  set page(numbering: "1")

  doc

  // Use arabic numbering for content

  // Display paper content

  set page(header: none)
  pagebreak(weak: true)
  if bibliographyFiles.len() > 0 and bibliographyTitle != none {
    par(justify: false)[#bibliography(bibliographyFiles, title: bibliographyTitle, full: false)]
  }

  if appendix != none {
    counter(heading).update(1)
    counter(figure).update(1)
    for it in outlines {
      let k = it.at(1)
      counter(figure.where(kind: k)).update(0)
    }
    set heading(numbering: "A.1")
    set figure(numbering: "A")
    show heading: it => {
      if it.level > 1 {
        set heading(outlined: false, supplement: none)
      }
      it
    }
    appendix
  }
}

