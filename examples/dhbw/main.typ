#import "/themes/dhbw/config.typ": conf
#show: doc => conf(
  title: "Titel",
  authors: (
    (
      name: "Johann Wolfgang von Goethe",
      "Kurs, Matrikelnummer": "TIK21, 7400001",
    ),
    (
      name: "Max Musterfrau",
      "Kurs, Matrikelnummer": "TIT21, 7654321",
    ),
    (
      name: "Max Mustermann",
      "Kurs, Matrikelnummer": "TIT21, 1234567",
      "Gutachter der DHBW:": "Dr. Maria Leitner"
    ),
  ),
  courseName: "Informationstechnik",
  submissionDate: datetime.today().display(), // expects content, not a datetime, so use .display()
  thesisType: "Hausarbeit", // e.g Bachelor Thesis
  companyLogo: [], // expects any content, e.g. an image
  universityLogo: image("pics/dhbwLogo.svg"),
  university: "DHBW Ravensburg", // e.g. DHBW Ravensburg

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
)

= Mustertitel

#lorem(50)
#figure(
  caption: "huh",
  table([asdfasdfasdfa], [asdf])
)

#lorem(100)
== Untertitel
=== Untertitel
#lorem(20)

#lorem(400)
