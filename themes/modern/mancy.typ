// This theme is inspired by https://github.com/matze/mtheme
// The polylux-port was performed by https://github.com/Enivex

// Consider using:
// #show math.equation: set text(font: "Fira Math")
// #set strong(delta: 100)
// #set par(justify: true)

//#import "../logic.typ"
//#import "../utils/utils.typ"
#import "@preview/polylux:0.3.1": *

#let fgdark = rgb("#234563")
#let bgwhite = rgb("FFFFFF")
#let sections = locate(loc => utils.sections-state.final(loc).len())

#let mancy(
  aspect-ratio: "16-9",
  footer: [],
  author: none,
  body
) = {
  set page(
    paper: "presentation-" + aspect-ratio,
    fill: none,
    margin: 0em,
    header: none,
    footer: none,
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
  date: datetime.today(),
) = {
  set page(background: _corners(margin: 8pt, length: 30pt, style: (thickness: 2pt)))
  let content = {
    set text(fill: fgdark)
    set align(horizon + center)
    block(width: 100%, inset: 2em, {
      text(size: 30pt, strong(title))
      if subtitle != none {
        linebreak()
        text(size: 1.5em, subtitle)
      }
      line(length: 100%, stroke: .05em + bgwhite)
      set text(size: 24pt)
      if author != none {
        block(spacing: 1em, author)
      }
      set text(size: 22pt)
      set align(bottom)
      if date != none {
        block(spacing: 1em, date.display())
      }

    })
  }
  logic.polylux-slide(content)
}

#let slide(
  body: none 
) = {
  let content = {
    set text(fill: fgdark)
    set align(top + left)
    set align(start + top)
    if body != none {
      body
    }
    set align(bottom + right)
    utils.last-slide-number
    }
  logic.polylux-slide(content)
}

#let next(
  section: none
  ) = {
    if section != none {
    utils.register-section(section)
  }
}

#show: mancy.with(aspect-ratio: "16-9")

#title-slide(title: lorem(20), subtitle: lorem(30), author: "Lennart Schuster")

#next(section: "Introduction")
#slide(body: "asdf")
