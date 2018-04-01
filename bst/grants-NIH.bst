% Based on
% pccp-bibtex-nomonth-title-nonhttpurl-conf-nonote.bst
% 
% Help from:
%
% https://chenfuture.wordpress.com/2007/09/24/diy-your-bibtex-style-file/
% Tame the BeaST: The B to X of BibTEX by Nicolas Markey
% 	ftp://ftp.tex.ac.uk/tex-archive/info/bibtex/tamethebeast/ttb_en.pdf
% Designing BIBTEX Styles by Oren Patashnik
% 	http://www.tex.ac.uk/tex-archive/biblio/bibtex/contrib/doc/btxhak.pdf
% http://www.tex.ac.uk/tex-archive/biblio/bibtex/contrib/doc/btxFAQ.pdf
%
% EXAMPLE INPUT:
%
%@Booklet(MarohnNSFgrant,
%Title = {Scanned-Probe Characterization of Degradation and Charge Generation in Organic Semiconductors},
%Author = {Marohn, John A.},
%Agency = {National Science Foundation},
%Duration = {08/01/13 -- 07/31/16},
%Amount = {417000},
%Institution = {Cornell University},
%Address = {Ithaca, New York},
%Commitment = {Cal: 0.00, Acad: 1.0, Sumr: 1.0},
%Grant = {DMR-1006633},
%Funds = {one postdoc for 2.5 years and one graduate student for 1 year.},
%Abstract = {},
%Keywords = {grant-Marohn-NSF-DMR-1006633},
%Owner = {jam99},
%Timestamp = {2015.03.22},
%Url = {http://www.nsf.gov/awardsearch/showAward?AWD_ID=1309540&HistoricalAwards=false}
%)
%
% EXAMPLE OUTPUT
%
% ``Scanned-Probe Characterization Of Degradation And Charge Generation In Organic Semiconductors'' (P.I.: John A. Marohn, Cornell Univ.; National Science Foundation; 8/1/13 -- 7/31/16; \$417,000).  This proposal funds time-resolved scanning Kelvin probe microscope (SPKM) studies of (1) charge trapping in $n$-type organic semiconductors and (2) charge photogeneration in organic semiconductor blends. {\bf Ongoing}
% 

% ADDED:
%
%  abstract
%  agency
%  amount
%  commitment
%  duration
%  grant
%  submitted
%  funds
%
%  with the following internal variable
%
%  keywords
%  owner
%  timestamp


ENTRY
  { abstract
  	address
  	agency
	amount
    author
    booktitle
    chapter
    commitment
    duration
    edition
    editor
    funds
    grant
    howpublished
    institution
    journal
    key
    keywords
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    submitted
    title
    type
    volume
    year
    url
    doi
    pmcid
    location
  }
  {}
  { label }

% ====== START COPIED ========

INTEGERS { output.state before.all mid.sentence after.sentence after.block after.item author.or.editor }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
  #4 'after.item :=
}

FUNCTION {add.semicolon}
{ duplicate$
  #-1 #1 substring$ "}" =
      { #-2 #1024 substring$ ";} " * }
      { "; " * }
  if$
}

STRINGS { s t }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
	{ add.semicolon write$
	  newline$
	  "\newblock " write$
	}
	{ output.state before.all =
	    'write$
	    { output.state after.item =
		{ " " * write$ }
	      { add.period$ " " * write$ }
	    if$
	    }
        if$
      }
	if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
	'skip$
	{ after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {new.item}
{ duplicate$ empty$
    { skip$ }
    { output.state mid.sentence =
        { after.item 'output.state := }
        { skip$ }
      if$
    }
  if$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.item.checka}
{ empty$
    'skip$
    'new.item
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "}" * }
  if$
}

FUNCTION {boldface}
{ duplicate$ empty$
    { pop$ "" }
    { "{\bf " swap$ * "}" * }
  if$
}

FUNCTION {paren}
{ duplicate$ empty$
    { pop$ "" }
    { "(" swap$ * ")" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{f.~}{vv~}{ll}{, jj}" format.name$ 't :=
      nameptr #1 >
	{ namesleft #1 >
	    { ", " * t * }
	    { numnames #2 >
		{ "," * }
		'skip$
            if$
	      t "others" =
	      { " et~al." * }
	      { " and " * t * }
            if$
	    }
	  if$
      }
	't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { #1 'author.or.editor :=
      author format.names }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { #2 'author.or.editor :=
      editor num.names$ #1 >
      { "ed. " * }
      { "ed. " * }
      if$
      editor format.names
    }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { title "t" change.case$ }
  if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
	{ t #1 #2 substring$ "--" = not
	    { "--" *
	      t #2 global.max$ substring$ 't :=
	    }
	    {   { t #1 #1 substring$ "-" = }
		{ "-" *
		  t #2 global.max$ substring$ 't :=
		}
	      while$
	    }
	  if$
	}
	{ t #1 #1 substring$ *
	  t #2 global.max$ substring$ 't :=
	}
      if$
    }
  while$
}

%FUNCTION {format.date}
%{ year empty$
%    { month empty$
%	{ "" }
%	{ "there's a month but no year in " cite$ * warning$
%	  month
%	}
%      if$
%    }
%    { month empty$
%	{ year }
%	{ year }
%	{ month " " * year }
%      if$
%    }
%  if$
%}
% Replaced w/ the following 
% John Marohn 2009/01/13

FUNCTION {format.date}
{ year empty$
    { month empty$
	{ "" }
	{ "there's a month but no year in " cite$ * warning$
	  month
	}
      if$
    }
    { month empty$
	{ year boldface }
	{ year boldface }
%	{ month " " * year }
      if$
    }
  if$
}

FUNCTION {format.bdate}
{ year empty$
	{ "there's no year in " cite$ * warning$ }
	'year
  if$
}

FUNCTION {format.btitle}
{ title emphasize
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { "Vol. " volume tie.or.space.connect
      series empty$
	'skip$
	{ " of " * series emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
	{ series field.or.null }
	{ output.state mid.sentence =
	    { "number" }
	    { "Number" }
	  if$
	  number tie.or.space.connect
	  series empty$
	    { "there's a number but no series in " cite$ * warning$ }
	    { " in " * series * }
	  if$
	}
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
	{ edition "l" change.case$ " ed." * }
	{ edition "t" change.case$ " ed." * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
	{ #1 'multiresult := }
	{ t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
	{ "pp." pages n.dashify tie.or.space.connect }
	{ "p." pages tie.or.space.connect }
      if$
    }
  if$
}

%FUNCTION {format.vol.num.pages}
%{ volume boldface field.or.null
%  number empty$
%    'skip$
%    { "(" number * ")" * *
%      volume empty$
%	{ "there's a number but no volume in " cite$ * warning$ }
%	'skip$
%      if$
%    }
%  if$
%  pages empty$
%    'skip$
%    { duplicate$ empty$
%	{ pop$ format.pages }
%	{ ", " * pages n.dashify * }
%      if$
%    }
%  if$
%}
%
% Replaced with function below 
%  by John Marohn 2009/01/12

FUNCTION {format.vol.num.pages}
{ volume emphasize field.or.null
  pages empty$
    'skip$
    { duplicate$ empty$
	{ pop$ format.pages }
	{ ", " * pages n.dashify * }
      if$
    }
  if$
}


FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
	{ "chapter" }
	{ type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
	'skip$
	{ ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
	{ "In " booktitle emphasize * }
	{ "In " format.editors * ", " * booktitle emphasize * }
      if$
    }
  if$
}

FUNCTION {format.in.booktitle.ed}
{ booktitle empty$
    { "" }
    { editor empty$
        { "in " booktitle emphasize * }
        { "in " booktitle emphasize * ", " * format.editors * }
      if$
    }    
  if$
}

FUNCTION {format.pub.address}
{ publisher empty$
    { "" }
    { address empty$
        { publisher }
        { publisher ", " * address *}
      if$
    }    
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
	{ "need key or journal for " cite$ * " to crossref " * crossref *
	  warning$
	  ""
	}
	{ "In {\em " journal * "\/}" * }
      if$
    }
    { "In " key * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor #1 "{vv~}{ll}" format.name$
  editor num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
	'skip$
	{ editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
	    { " et~al." * }
	    { " and " * editor #2 "{vv~}{ll}" format.name$ * }
	  if$
	}
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "In "
    }
    { "Volume" volume tie.or.space.connect
      " of " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ series empty$
	    { "need editor, key, or series for " cite$ * " to crossref " *
	      crossref * warning$
	      "" *
	    }
	    { "{\em " * series * "\/}" * }
	  if$
	}
	{ key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ booktitle empty$
	    { "need editor, key, or booktitle for " cite$ * " to crossref " *
	      crossref * warning$
	      ""
	    }
	    { "In {\em " booktitle * "\/}" * }
	  if$
	}
	{ "In " key * }
      if$
    }
    { "In " format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

%% OLD
%FUNCTION {format.url}
%{ url empty$
%    { "" }
%    { "\href{" url * "}{[url]}" * }
%  if$
%}

%% jam99 -- try to add DOI number if it's present, and if it's not, add URL; if no URL, do nothing
%FUNCTION {format.url}
%{ url empty$
%    { "" }
%    { doi empty$
%    	{ "\href{" url * "}{[url]}" * }
%    	{ "\href{" url * "}{[doi:" * doi * "]}" * }
%     if$
%     }
%  if$
%}

% jam99 -- try to add DOI number if it's present, and if it's not, add URL; if no URL, do nothing
% the opening "[" and closing "]" should not be part of the hyperlink
% 2016/01/22 -- For NIH grant, want doi numbers to appear as 
%  URL http://dx.doi.org/10.1021/nn300941f
% and hyperlinks to appear as
%  URL http://www.google.com
% 
% obsolete:
%FUNCTION {format.url}
%{ url empty$
%    { "" }
%    { doi empty$
%    	{ "URL " "\href{" * url * "}{url}" * }
%    	{ "URL " "\href{" * url * "}{" * url * "}" * }
%     if$
%     }
%  if$
%}
%
% NEW:

FUNCTION {format.url}
{ url empty$
    { "" }
    { doi empty$
    	{ "URL " "\href{" * url * "}{" * url * "}" * }
		{ "URL " "\href{http://dx.doi.org/" * doi * "}{http://dx.doi.org/" * doi * "}" * }
     if$
     }
  if$
}

FUNCTION {format.pmcid}
{ pmcid empty$
    { "" }
    { "\href{http://www.ncbi.nlm.nih.gov/pmc/articlerender.fcgi?artid=PMC" pmcid * "}{PMC" * pmcid * ".}" * }
if$
}

% jam99 -- added, in case note is empty
FUNCTION {format.note}
{ note empty$
    { "" }
    {note}
    if$
}

%% OLD
%FUNCTION {article}
%{ output.bibitem
%  format.authors "author" output.check
%  format.title "title" output.check
%  crossref missing$
%    { journal emphasize "journal" output.check
%      format.date "year" output.check
%      format.vol.num.pages output
%    }
%    { format.article.crossref output.nonnull
%      format.pages output
%    }
%  if$
%  format.url output
%  fin.entry
%}

% jam99 -- Added note line
% jam99 -- Removed note line
FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  format.title "title" output.check
  crossref missing$
    { journal emphasize "journal" output.check
      format.date "year" output.check
      format.vol.num.pages output
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$
  format.url output
  format.pmcid output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  format.btitle "title" output.check
  crossref missing$
    { format.bvolume output
      format.number.series output
      format.pub.address "publisher" output.check
    }
    { format.book.crossref output.nonnull }
  if$
  format.edition output
  format.bdate "year" output.check
  new.block
  fin.entry
}

% We are going to hijack this to format grants.
% See below.
% 
%FUNCTION {booklet}
%{ output.bibitem
%  format.authors output new.item
%  format.title "title" output.check
%  howpublished address new.block.checkb
%  howpublished output
%  address output
%  format.date output
%  new.block
%  fin.entry
%}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull }
  if$
  format.in.booktitle.ed "title" output.check
  crossref missing$
    { format.pub.address "publisher" output.check
      format.bdate "year" output.check
      new.block
      format.bvolume output
      format.chapter.pages "chapter and pages" output.check
	new.block
      format.number.series output
    }
    { format.chapter.pages "chapter and pages" output.check
      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  new.block
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check new.item
  crossref missing$
    { format.in.booktitle.ed "booktitle" output.check
      format.bvolume output
      format.number.series output
      new.block
      format.pub.address "publisher" output.check
      format.edition output
      format.bdate "year" output.check
	new.block
      format.chapter.pages output
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  new.block
  fin.entry
}

% JAM: added the line "format.title "title" output.check new.sentence" after the author line

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check new.item
  format.title "title" output.check new.sentence
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.pages output
      address empty$
	{ organization publisher new.sentence.checkb
	  organization output
	  publisher output
	  format.bdate "year" output.check
	}
	{ address output.nonnull
	  format.bdate "year" output.check
	  new.sentence
	  organization output
	  publisher output
	}
      if$
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  format.url output
  new.block
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  format.title "title" output.check new.sentence
  author empty$
    { organization empty$
	'skip$
	{ organization output.nonnull
	  address output
	}
      if$
    }
    { format.authors output.nonnull new.item }
  if$
  author empty$
    { organization empty$
	{ address new.block.checka
	  address output
	}
	'skip$
      if$
    }
    { organization address new.block.checkb
      organization output
      address output
    }
  if$
  format.edition output
  format.date output
  new.block
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  format.title "title" output.check new.item
  "Master's thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  new.block
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  format.title output
  howpublished new.item.checka
  howpublished output
  format.bdate output
  new.block
  fin.entry
  empty.misc.check
}

% JAM: added "format.url output" line before "new.block" line
FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check new.item
  format.btitle "title" output.check new.item
  "PhD thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  format.url output
  new.block
  fin.entry
}

% JAM: added "format.url output" line before "new.block" line
FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors output.nonnull new.item }
  if$
  new.block
  format.btitle "title" output.check
  format.bvolume output
  format.number.series output
  address empty$
    { editor empty$
	{ publisher new.sentence.checka }
	{ organization publisher new.sentence.checkb
	  organization output
	}
      if$
      publisher output
      format.date "year" output.check
    }
    { address output.nonnull
      format.date "year" output.check
      new.sentence
      editor empty$
	'skip$
	{ organization output }
      if$
      publisher output
    }
  if$
  format.url output
  new.block
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check new.item
  format.title "title" output.check new.item
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  format.date "year" output.check
  new.block
  fin.entry
}

% JAM: Old
%FUNCTION {unpublished}
%{ output.bibitem
%  format.authors "author" output.check
%%  format.title "title" output.check new.item
%  format.btitle "title" output.check
%  note "note" output.check
%  format.date output
%  fin.entry
%}

%JAM: New -- added "format.url output" line before "new.block" line
FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
%  format.title "title" output.check new.item
  format.btitle "title" output.check
  note "note" output.check
  format.date output
  format.url output
  fin.entry
}

FUNCTION {default.type} { misc }

% ======= END COPIED =========

% == jam99 START NEW STUFF ===

% We are going to hijack booklet because that is a bib style that I seldom use.
% I am aiming for something approximately like this:
%
% ``Scanned-Probe Characterization Of Degradation And Charge Generation In Organic Semiconductors'' (P.I.: John A. Marohn, Cornell Univ.; National Science Foundation; 8/1/13 -- 7/31/16; \$417,000).  This proposal funds time-resolved scanning Kelvin probe microscope (SPKM) studies of (1) charge trapping in $n$-type organic semiconductors and (2) charge photogeneration in organic semiconductor blends.

FUNCTION {format.institution}
{ institution 
}

FUNCTION {format.agency}
{ agency
}

FUNCTION {format.grant}
{ grant empty$
	{""}
	{"grant number " grant *}
  if$
}

FUNCTION {format.submitted}
{  submitted empty$
	{""}
	{"submitted " submitted *}
  if$
}

FUNCTION {format.duration}
{  duration 
}

FUNCTION {format.commitment}
{  commitment 
}

FUNCTION {format.amount}
{ amount empty$
	{""}
	{"\$" amount *}
  if$
}

FUNCTION {format.location}
{ amount empty$
	{""}
	{"location: " location *}
  if$
}


FUNCTION {booklet}
{ output.bibitem
  "``" format.title * "'' " * output
  new.item
  "(" format.authors * output
  new.block
  format.institution output
  new.block
  format.agency output
  format.grant output
  new.item
  format.url output
  new.block
  format.location output
  new.block
  format.submitted output
  new.block
  format.duration output
  new.block
  format.amount ")" * output
  new.sentence 
  format.note output
  new.sentence
  format.commitment output
  fin.entry
}

% === jam99 END NEW STUFF ====
% ====== START COPIED ========

READ

STRINGS { longest.label }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}

% ======= END COPIED =========


