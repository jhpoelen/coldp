-- Postgres ColDP schema

-- enumeration types
CREATE TYPE AREASTANDARD AS ENUM (
  'TDWG',
  'ISO',
  'FAO',
  'FAO_FISHING',
  'LONGHURST',
  'TEOW',
  'IHO',
  'TEXT'
);

CREATE TYPE DISTRIBUTIONSTATUS AS ENUM (
  'NATIVE',
  'DOMESTICATED',
  'ALIEN',
  'UNCERTAIN'
);

CREATE TYPE GAZETTEER AS ENUM (
  'TDWG',
  'ISO',
  'FAO',
  'LONGHURST',
  'TEOW',
  'IHO',
  'TEXT'
);

CREATE TYPE LIFEZONE AS ENUM (
  'BRACKISH',
  'FRESHWATER',
  'MARINE',
  'TERRESTRIAL'
);

CREATE TYPE MEDIATYPE AS ENUM (
  'IMAGE',
  'VIDEO',
  'AUDIO'
);

CREATE TYPE NOMCODE AS ENUM (
  'BACTERIAL',
  'BOTANICAL',
  'CULTIVARS',
  'PHYTOSOCIOLOGICAL',
  'VIRUS',
  'ZOOLOGICAL'
);

CREATE TYPE NOMRELTYPE AS ENUM (
  'SPELLING_CORRECTION',
  'BASIONYM',
  'BASED_ON',
  'REPLACEMENT_NAME',
  'CONSERVED',
  'LATER_HOMONYM',
  'SUPERFLUOUS',
  'HOMOTYPIC',
  'TYPE'
);

CREATE TYPE NOMSTATUS AS ENUM (
  'ESTABLISHED',
  'NOT_ESTABLISHED',
  'ACCEPTABLE',
  'UNACCEPTABLE',
  'CONSERVED',
  'REJECTED',
  'DOUBTFUL',
  'MANUSCRIPT',
  'CHRESONYM'
);

CREATE TYPE SEX AS ENUM (
  'FEMALE',
  'MALE',
  'HERMAPHRODITE'
);

CREATE TYPE STATUS AS ENUM (
  'ACCEPTED',
  'PROVISIONALLY_ACCEPTED',
  'SYNONYM',
  'AMBIGUOUS_SYNONYM',
  'MISAPPLIED'
);

CREATE TYPE RANK AS ENUM (
  'DOMAIN',
  'REALM',
  'SUBREALM',
  'SUPERKINGDOM',
  'KINGDOM',
  'SUBKINGDOM',
  'INFRAKINGDOM',
  'SUPERPHYLUM',
  'PHYLUM',
  'SUBPHYLUM',
  'INFRAPHYLUM',
  'SUPERCLASS',
  'CLASS',
  'SUBCLASS',
  'INFRACLASS',
  'PARVCLASS',
  'SUPERLEGION',
  'LEGION',
  'SUBLEGION',
  'INFRALEGION',
  'SUPERCOHORT',
  'COHORT',
  'SUBCOHORT',
  'INFRACOHORT',
  'GIGAORDER',
  'MAGNORDER',
  'GRANDORDER',
  'MIRORDER',
  'SUPERORDER',
  'ORDER',
  'NANORDER',
  'HYPOORDER',
  'MINORDER',
  'SUBORDER',
  'INFRAORDER',
  'PARVORDER',
  'MEGAFAMILY',
  'GRANDFAMILY',
  'SUPERFAMILY',
  'EPIFAMILY',
  'FAMILY',
  'SUBFAMILY',
  'INFRAFAMILY',
  'SUPERTRIBE',
  'TRIBE',
  'SUBTRIBE',
  'INFRATRIBE',
  'SUPRAGENERIC_NAME',
  'GENUS',
  'SUBGENUS',
  'INFRAGENUS',
  'SUPERSECTION',
  'SECTION',
  'SUBSECTION',
  'SUPERSERIES',
  'SERIES',
  'SUBSERIES',
  'INFRAGENERIC_NAME',
  'SPECIES_AGGREGATE',
  'SPECIES',
  'INFRASPECIFIC_NAME',
  'GREX',
  'SUBSPECIES',
  'CULTIVAR_GROUP',
  'CONVARIETY',
  'INFRASUBSPECIFIC_NAME',
  'PROLES',
  'NATIO',
  'ABERRATION',
  'MORPH',
  'VARIETY',
  'SUBVARIETY',
  'FORM',
  'SUBFORM',
  'PATHOVAR',
  'BIOVAR',
  'CHEMOVAR',
  'MORPHOVAR',
  'PHAGOVAR',
  'SEROVAR',
  'CHEMOFORM',
  'FORMA_SPECIALIS',
  'CULTIVAR',
  'STRAIN',
  'OTHER',
  'UNRANKED'
);





CREATE TABLE "Reference" (
	"ID" TEXT PRIMARY KEY,
	citation TEXT,
	author TEXT,
	title TEXT,
	year INTEGER,
	source TEXT,
	details TEXT,
	doi TEXT,
	link TEXT,
	remarks TEXT
);

CREATE TABLE "Name" (
	"ID" TEXT PRIMARY KEY,
	"originalNameId" TEXT REFERENCES "Name",
	"scientificName" TEXT NOT NULL,
	authorship TEXT,
	rank RANK NOT NULL,
	uninomial TEXT,
	genus TEXT,
	"infragenericEpithet" TEXT,
	"specificEpithet" TEXT,
	"infraspecificEpithet" TEXT,
	"cultivarEpithet" TEXT,
	"publishedInID" TEXT REFERENCES "Reference",
	"publishedInPage" TEXT,
	"publishedInYear" INTEGER,
	code NOMCODE,
	status STATUS,
	link TEXT,
	remarks TEXT
);

CREATE TABLE "NameRelation" (
	"nameID" TEXT NOT NULL REFERENCES "Name",
	"relatedNameID" TEXT REFERENCES "Name",
	type NOMRELTYPE NOT NULL,
	"publishedInID" TEXT REFERENCES "Reference",
	remarks TEXT
);

CREATE TABLE "Taxon" (
	"ID" TEXT PRIMARY KEY,
	"parentID" TEXT REFERENCES "Taxon",
	"nameID" TEXT NOT NULL REFERENCES "Name",
	"appendedNamePhrase" TEXT,
	"accordingToID" TEXT REFERENCES "Reference",
	provisional BOOLEAN NOT NULL,
	"referenceID" TEXT[],
	scrutinizer TEXT,
	"scrutinizerDate" DATE,
	extinct BOOLEAN,
	"temporalRangeStart" TEXT,
	"temporalRangeEnd" TEXT,
	lifezone LIFEZONE[],
	link TEXT,
	remarks TEXT
);

CREATE TABLE "Distribution" (
	"taxonID" TEXT NOT NULL REFERENCES "Taxon",
	area TEXT NOT NULL,
	gazetteer GAZETTEER NOT NULL,
	status DISTRIBUTIONSTATUS,
	"referenceID" TEXT
);

CREATE TABLE "Synonym" (
	"ID" TEXT PRIMARY KEY,
	"taxonID" TEXT REFERENCES "Taxon",
	"nameID" TEXT NOT NULL REFERENCES "Name",
	"appendedNamePhrase" TEXT,
	"accordingToID" TEXT REFERENCES "Reference",
	status STATUS NOT NULL,
	"referenceID" TEXT[],
	link TEXT,
	remarks TEXT
);

CREATE TABLE "Media" (
	"taxonID" TEXT NOT NULL REFERENCES "Taxon",
	url TEXT NOT NULL,
	type MEDIATYPE,
	format TEXT,
	title TEXT,
	created DATE,
	creator TEXT,
	license TEXT,
	link TEXT
);

CREATE TABLE "Treatment" (
	"taxonID" TEXT PRIMARY KEY REFERENCES "Taxon",
	document TEXT NOT NULL
);

CREATE TABLE "TypeMaterial" (
	"ID" TEXT PRIMARY KEY,
	"nameID" TEXT NOT NULL REFERENCES "Name",
	citation TEXT,
	status TEXT,
	"referenceID" TEXT REFERENCES "Reference",
	locality TEXT,
	country CHARACTER(2),
	latitude DECIMAL,
	longitude DECIMAL,
	altitude INTEGER,
	host TEXT,
	date TEXT,
	collector TEXT,
	link TEXT,
	remarks TEXT
);

CREATE TABLE "VernacularName" (
	"taxonID" TEXT NOT NULL REFERENCES "Taxon",
	name TEXT NOT NULL,
	transliteration TEXT,
	language CHARACTER(3),
	country CHARACTER(2),
	area TEXT,
	sex SEX,
	"referenceID" TEXT
);
