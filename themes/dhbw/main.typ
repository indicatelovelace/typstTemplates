#import "@preview/glossarium:0.2.3" : gls, glspl
#import "config.typ": conf
#show: doc => conf(
  // Document Information
  title: "Title",
  language: "en",
  // Work Information
  authors: (
    (
      name: "Max Mustermann",
      company: "Musterfirma",
      matriculationNumber: 1234567,
      courseShort: "MusterKursKürzel",
      courseName: "Musterkursname",
      evaluator: "Prof. Dr. Max Musterprofessor",
      companyAdvisor: "Max Musterberater",
      period: [#datetime.today(offset: -50).display() - #datetime.today(offset: -1).display()],
      submissionDate: datetime.today().display(),
    ),
  ),
  font: "IBM Plex Serif",
  outlines: (
    ("List of figures", image),
    ("List of tables", table),
    ("List of listings", "list"),
  ),
  thesisType: "Bachelorarbeit/Studienarbeit/T2000 Projektarbeit",
  fieldOfStudies: "",
  university: "DHBW Musterstadt",
  // Elements
  abstract: [],
  appendix: [],
  // see https://github.com/typst/packages/tree/main/packages/preview/glossarium/0.2.3 for docs
  glossary: ((key: "kuleuven", short: "KU Leuven", long: "asdf", desc: "asf a wsjsjngng"),),
  glossaryTitle: "Glossarium",
  equationTitle: "List of equations",
  equationShort: "Eq.",
  declarationOnHonour: true,
  // Pictures
  companyLogo: (path: "pictures/AirbusLogo.jpg", alternativeText: "Company Logo"),
  universityLogo: (path:"pictures/University-logo.svg", alternativeText: "University Logo"),
  // Bib
  bibliographyFiles: "bib/references.yml",
  bibliographyStyle: "ieee",
  // Docs
  doc,
)

= Mustertitel

#figure(
  image("pictures/University-logo.svg"),
  caption: [Das DHBW Logo]
) \
#lorem(100) \
#gls("kuleuven") \
#figure(
  table(
  columns: (1fr, auto, auto),
  inset: 10pt,
  align: horizon,
  [], [*Area*], [*Parameters*],
  [],
  $ pi h (D^2 - d^2) / 4 $,
  [
    $h$: height \
    $D$: outer radius \
    $d$: inner radius
  ],
  [],
  $ sqrt(2) / 12 a^3 $,
  [$a$: edge length]
  ),
  caption: [Eine Tabelle]
) \

$ sum_(i=0)^n a_i = 2^(1+i) $

#math.equation(
  block: true,
  supplement: [Ein Mustertitel für eine benannte Gleichung],
  [$a + b = c$]
)

#lorem(100)
#figure(
  [
    - Item 1
    - Ein anderes Item
  ],
  kind: "list",
  supplement: [List],
  caption: [Eine Liste]
)
#lorem(100)
