#import "config.typ": conf
#show: doc => conf(
  title: "Title",
  authors: (
    (
      name: "Max Mustermann",
      company: "Musterfirma",
      matriculation_number: 1234567,
      course_abbr: "MusterKursKürzel",
      course_name: "Musterkursname",
      evaluator: "Prof. Dr. Max Musterprofessor",
      company_advisor: "Max Musterberater",
      period: [#datetime.today(offset: -50).display() - #datetime.today(offset: -1).display()],
      submission_date: datetime.today().display(),
    ),
  ),
  university: "DHBW Musterstadt",
  abstract: [],
  language: "en",
  font: "IBM Plex Serif",
  outlines: (
    ("List of figures", image),
    ("List of tables", table),
    ("List of listings", "list")
  ),
  thesis_type: "Bachelorarbeit/Studienarbeit/T2000 Projektarbeit",
  field_of_studies: "",
  company_logo: (path: "pictures/AirbusLogo.jpg", alternative_text: "Company Logo"),
  university_logo: (path:"pictures/University-logo.svg", alternative_text: "University Logo"),
  declaration_on_honour: true,
  bibliography-file: "references.yml",
  bibliography-style: "ieee",
  doc,
)

= asfd

#figure(
  image("pictures/University-logo.svg"),
  caption: [alsjkdf asld]
) <dhbw>

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
  caption: [asdf]
) <table>

#figure(
  terms.item("sd", "afg"),
  kind: "list",
  supplement: [List],
  caption: "asdf"
)

#lorem(200)
