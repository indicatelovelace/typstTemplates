// #import "@local/dhbw-thesis:0.1.0": conf
#import "@local/dhbw-thesis:0.1.0": conf
#show: doc => conf(
  title: "Mustertitel",
/*
   author is an array of dicts. The only key that is necessary is "name".
  Any other property supplied is printed at the bottom end of the page, as per the guidelines, in the format "#key: #value", in the given order. For multiple authors, this data is collected, deduplicated, and either displayed as per usual or, if possible, listed as line seperated values.
  */
  authors: (
    (
      name: "Max Musterfrau",
      "Kurs, Matrikelnummer": "Musterkurs, Mustermatrikelnummer",
    ),
    (
      name: "Max Mustermann",
      "Kurs, Matrikelnummer": "Musterkurs, Mustermatrikelnummer",
      "Gutachter der DHBW:": "Prof. Max Musterprofessor"
    ),
  ),
  courseName: "Musterkurs",
  submissionDate: datetime.today().display(), // expects content, not a datetime, so use .display()
  submissionPlace: "Musterort",
  thesisType: "Musterarbeit", // e.g Bachelor Thesis
  companyLogo: [], // expects any content, e.g. an image
  universityLogo: image("pics/dhbwLogo.svg"),
  university: "DHBW Ravensburg", // e.g. DHBW Ravensburg
  abstractTitle: none, // No abstract if none
  abstract: none,
  appendix: none, // no appendix if none
  glossary: none, // the user is expected to create their own glossarium, with a package of their choice, or by hand. This can of course also include an list of symbols etc. No glossarium is printed if none
  bibliographyTitle: none, // no bibliography if none
  bibliographyFiles: (),
  bibliographyStyle: "ieee", // no specific requirements here, I recommend you use IEEE
  declarationOnHonour: true,
  draft: true,
  language: "de", // enable language-specific quotes with ISO 639-1/2/3 language code
  font: "IBM Plex Serif",
  fontSize: 12pt,
  smallcapsFont: "Linux Libertine",
  mathFont: "IBM Plex Serif",
  outlines: ((none, none),), // e.g. (table, "List of Tables") in the submitted order
  equationTitle: none, // no equation table if none, equations are not a regular figure, only block equations are listed
  equationSupplement: none, // no eqution supplement if none
  
  doc,
)

/* Write your thesis here */
