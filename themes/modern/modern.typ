//#import "../logic.typ"
//#import "../utils/utils.typ"
#import "@preview/polylux:0.3.1": *

#let fgdark = rgb("#234563")
#let bgwhite = rgb("FFFFFF")

#let sections = state("sections", ())

#let currentSection(update: none) = {
  let newSec = []
  if update != none {
    newSec = sections.update(l => {
    l.push(update)
    l
  })
  }
  newSec
  locate(loc => {
    let sec = sections.at(loc)
    if sec.len() < 1 {
      return []
    } else {
      return sections.at(loc).last()
    }
  })
}

#let currentSectionNumber() = locate(loc => {
    sections.at(loc).len() + 1
  })

#let _loremBullet(
  count: 5
) = list(..range(count).map(item => lorem(calc.rem((item + 1) * 149, 17) + 1)))

#let _sectionSymbols(
  size: 10pt,
  unselected: circle(radius: 5pt, fill: white, stroke: black),
  selected: circle(radius: 5pt, fill: black, stroke: black)
) = {
  locate(loc => {
    let allSecs = sections.final(loc)
    let currentSecs = sections.at(loc)
    if currentSecs.len() > 0 {
      stack(spacing: 3pt, dir: ltr, ..allSecs.map(item =>
        if item == sections.at(loc).last() {
          selected
        } else {
          unselected
        }
    ))
    }
  })
}

#let slideHeader(section: none) = {
  set text(font: "IBM Plex Mono SmBld", size: 12pt)
  set align(left)
  stack(dir: ltr, 
    line(
      start: (2%, 30%),
      end: (2%, 70%),
      stroke: (paint: black, thickness: 2pt)
    ),
    h(4pt),
    currentSection(update: section),
    )
  set align(right)
  _sectionSymbols()
}

#let slideFooter = {
  set text(font: "IBM Plex Mono SmBld", size: 10pt)
  set align(right)
  logic.logical-slide.display()
}

#let mancy(
  aspect-ratio: "16-9",
  author: none,
  body
) = {
  set page(
    paper: "presentation-" + aspect-ratio,
    fill: none,
    margin: 1.6em,
  )

  set text(
    font: "IBM Plex Sans",
    weight: "light", size: 20pt)

  body
}


#let _corners(
  margin: 2%,
  length: 4%,
  style: (paint: black, thickness: 3pt, cap: "round")
) = {
  let offset = (100% - margin)
  // TODO: organisation
  place(top + left, 
  path(
    stroke: style, 
    (margin + length, margin),
    (margin, margin),
    (margin, margin + length),
    )
  )
  place(top + left, 
  path(
    stroke: style, 
    (margin + length, offset),
    (margin, offset),
    (margin, offset - length),
    )
  )
  place(top + left, 
  path(
    stroke: style, 
    (offset, margin + length),
    (offset, margin),
    (offset - length, margin),
    )
  )
  place(top + left, 
  path(
    stroke: style, 
    (offset - length, offset),
    (offset, offset),
    (offset, offset - length),
    )
  )
}

#let title-slide(
  title: [],
  subtitle: none,
  author: none,
  organisation: none,
  background: none,
  date: datetime.today(),
) = {
  set page(margin: 5%, background: background + _corners(margin: 8pt, length: 30pt, style: (thickness: 2pt)) + _sectionSymbols())
  let content = {
    set text(fill: fgdark)
    set align(horizon + center)
    block(width: 100%, inset: 2em, {
      text(size: 30pt, strong(title))
      if subtitle != none {
        linebreak()
        text(size: 24pt, subtitle)
      }
      line(length: 100%, stroke: .05em + black)
      set text(size: 20pt)
      if author != none {
        block(spacing: 1em, author)
      }
      set text(size: 16pt)
      set align(bottom)
      if date != none {
        // TODO: smaller and strong
        block(spacing: 1em, date.display())
      }
      // TODO: organisation
    })
  }
  logic.polylux-slide(content)
}

#let single-slide(
  title: [],
  body: none,
  section: none,
) = {
  set page(
    footer: slideFooter,
    header: slideHeader(section: section)
  )
  let content = {
    set text(fill: fgdark)
    set align(top + left)
    if title != none {
      box(width: 100%, height: 16%, inset: 5pt, title)
    }
    set align(left)
    if body != none {
      body
    }
    set align(bottom + right)
    }

  logic.polylux-slide(pad(rest: 16pt, content))
}

#show: mancy.with(aspect-ratio: "16-9")

#title-slide(title: "Nett Hier", subtitle: "Aber haben sie schonmal ein Dokument in Typst geschrieben", author: "Lennart Schuster", background: ellipse(width: 87%, height: 85%, fill: yellow, stroke: 6pt))
#single-slide(title: "Introduction", body: "Hier könnte ihre Doku stehen", section: "Introduction")
#single-slide(title: "Introduction", body: "Hier könnte ihre Doku stehen", section: "2")