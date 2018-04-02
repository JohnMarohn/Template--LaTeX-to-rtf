Template--LaTeX-to-rtf
######################

:author: John A. Marohn (jam99@cornell.edu)
:date: March 20, 2017

Summary
=======

Here I present some Python helper scripts for creating a Microsoft Word document from a TeX document.

Although I do most of my scholarly writing in LaTeX, it is often necessary to write in Microsoft Word when collaborating with others or writing grant reports.  Yet I have built up a large bibliographic database in LaTeX, and it would be nice to harness that database when preparing Microsoft Word documents.  Here I present an example ``tex`` file that can be converted into a ``docx`` or ``rtf`` file openable by Microsoft Word.  I also provide some Python scripts for carrying out the conversion.

Manifest
========

This repository contains the following files

* ``README.rst`` -- this file

* ``LICENSE`` -- GNU general public license (Version 3, 29 June 2007)

* ``test.tex`` -- example text with citations, equations, and a figure

* ``fabfile.py`` -- Python file containing commands to compile to ``rtf`` and ``docx`` formats

* ``cpbib.py`` -- Python file containing helper commands

* ``fabfile.cfg`` -- configuration file read by both fabfile.py and cpbib.py

and the following directories

* ``/bib`` -- contains a small representative ``bib`` file, ``jam99.bib``

* ``/bst`` -- LaTeX bibliographic style files for formatting the bibliography

* ``/csl`` -- citation style language (CSL) files for formatting the bibliography

* ``/docs`` -- contains ``pdf`` copies of the articles cited in the ``tex`` file

* ``/figs`` -- contains a single representative figure, ``ex.pdf``

* ``/output`` -- contains ``pdf``, ``rtf``, and ``docx`` outputs


Requirements
============

To run the scripts you will need the Python packages

* fabric (``conda install fabric`` or ``pip install fabric``) and

* pybtex (``pip install pybtex``),

plus the command line program

* pdflatex

which should come installed with your TeX distribution.  The main file-conversion script ``fabfile.py`` runs one of the two following external programs: 

* latex2rtf (`project <http://latex2rtf.sourceforge.net/index.html>`__ and `download <https://sourceforge.net/projects/latex2rtf/>`__) to generate ``rtf``, or

* pandoc (`project <http://pandoc.org/>`__ and `installing <http://pandoc.org/installing.html>`__) to generate ``docx``.

The citations in the ``docx`` file are generated using the

* citation style language (CSL, `project <http://citationstyles.org/>`__) and

* CSL styles (`github <https://github.com/citation-style-language/styles>`__).

I have included a number of *American Chemical Society* CSL files in the ``csl/`` directory.  You can find other CSL files at the github repository referenced above.

Usage
=====  

pdf
---

You should be able to compile ``test.tex`` to ``test.pdf`` directly using your own LaTeX compiler running pdflatex.  I include a copy of the resulting ``test.pdf`` in the ``outputs/`` folder.  

In order to be compatible with latex2rtf and pandoc, the ``tex`` file should use as few packages as possible.  The ``text.tex`` document is built on the article document class and uses only the packages 

* graphicx,

* geometry,

* hyperref, and 

It uses 

* a homegrown BibTeX style file, ``grants-CV``, included in the ``/bst`` directory;

* the bibliographic database ``jam99.bib``, included in the ``/bib`` directory; and

* the figure ``ex.pdf``, included in the ``/figs`` directory. 

rtf
---

To create an ``rtf`` file from the ``tex`` file you could run at the command line the following commands ::

    pdflatex test
    bibtex test
    pdflatex test
    pdflatex test
    latex2rtf test

To carry out this compilation in one step, use the provided Python script ::

    fab rtf

If you are running in OS X then the script will try to open the resulting ``test.rtf`` file in Microsoft Word.  A copy of the ``test.rtf`` file is included in the ``/output`` directory.  You can see that the citations (bracketed format), equations, figure, and bibliography show up more or less correctly.  

The figure appears at the end of the document as expected.  The figure is properly numbered and cross referenced in the document.  The figure caption shows up with extraneous text in the caption, ``{TC "1 This is a figure" \f f}``, which I think is the result of latex2rtf trying to generate the Microsoft field code required for the figure to show up in the table of contents.  I usually just delete this extraneous caption text by hand.

The command ``fab`` is included with the Python package fabric.  You can read about the fabric package `here <http://www.fabfile.org/>`__.  It's a Python library for creating command-line tools.  To see what commands are available in the ``fabfile.py`` code you can run ``fab -l``.  Doing this, you will see that a command ``clean``, ::

    fab clean

is provided that deletes auxiliary LaTeX files.

docx
----

The command required to create a ``docx`` file from the ``tex`` file using pandoc is much more involved, ::

    pandoc -s test.tex --filter pandoc-citeproc --bibliography bib/jam99.bib --csl csl/american-chemical-society-with-titles-sentence-case-doi.csl -o text.docx

The reason for using a ``csl`` file and not a LaTeX ``bst`` file to set the bibliography format is that I could not figure out a way to pass the ``bst`` file to pandoc (the pandoc manual is `here <http://pandoc.org/MANUAL.html>`__).  To carry out this compilation in one step, use the provided Python script ::

    fab docx

If you are running in OS X then the script will try to open the resulting ``test.docx`` file in Microsoft Word.  A copy of the ``test.docx`` file is included in the ``/output`` directory.  You can see that the citations (superscript format), equations (editable), figure, and bibliography show up more or less correctly.

I say *more or less* because pandoc does not quite get the figure conversion right and the hyperlinks in the bibliography only sort-of work.  The figure now appears in the middle of the document, is not properly cross referenced (``Fig. [fig:sine]`` instead of ``Fig 1``), and there is no figure number in the figure caption.  The improper cross referencing of figures is a documented bug of pandoc (`link <https://github.com/jgm/pandoc/issues/3110>`__).  Right clicking on each hyperlink in the bibliography and selecting ``Hyperlink > Open Hyperlink`` sends you to the journal page for each reference as expected.  Yet if I save the ``docx`` file to  ``pdf`` format, the hyperlinks are *not* retained in the resulting pdf.  So the hyperlinks only sort-of work.  

cfg
---

The ``fabfile.py`` looks to the included configuration file ``fabfile.cfg`` for the names of files used in the conversions.  The configuration file looks like ::

    [bib]
    master = /Users/jam99/Dropbox/UNSORTED/UNSORTED_bib.bib
    local = bib/jam99.bib

    [pdf]
    master = /Users/jam99/Dropbox/UNSORTED/

    [tex]
    main = test.tex

    [pandoc]
    csl = csl/american-chemical-society-with-titles-sentence-case-doi.csl

The information below ``[tex]``, ``[pandoc]``, and the ``local =`` line following ``[bib]`` are read whenever the ``fabfile`` is  executed.   The other information in the configuration file is used by the included ``cpbib.py`` code.  The name of the ``bib`` file in the ``local =`` line should agree with the name of the ``bib`` file called in ``test.tex``.

cpbib
-----

I found that having a bare-minimum ``bib`` file was important for getting pandoc to work properly.  I found that the pandoc program crashed if the ``bib`` file contained, for example, citation keys with an apostrophe and other "unusual" text (which LaTeX and BibTeX are perfectly happy with).  It is my practice to work with a single, master ``bib`` file; this master file contains at present over 3000 citations.  I *really* did not want to track down and remove all the "unusual" text in this master ``bib`` file in order get pandoc to compile my short document.  So instead I wrote Python code that looks in ``test.aux`` to determine which papers are cited and uses the Python package pybtex to read the master ``bib`` file and create a minimal ``bib`` file containing only the cited references.

When working with collaborators it often helpful for them to have easy access to copies of the papers you are citing.  So I wrote Python code which collects in the ``/docs`` directory ``pdf`` copies of the papers cited in ``test.tex``.  This code assumes that these files are located in a single, master pdf-file directory, and assumes that the name of the associated ``pdf`` file begins with the relevant BibTeX citation key.  The code looks in ``test.aux`` to determine which papers are cited, extracts their BibTex citations keys, looks in the master pdf-file directory for ``pdf`` files whose names start with those citations keys, and copies this subset of ``pdf`` files to the ``/docs`` directory.

The Python program ``cpbib.py`` handles both these tasks.  It contains functions which allow you to, from the command line, (1) create a minimal bibliography database file in ``/bib`` from a master bibliography file located elsewhere and (2) copy ``pdf`` files associated with the cited references from a master locations to the ``/docs`` subdirectory.  To see what commands are available, type ::

    python cpbib.py --help

which will print out ::

    Usage: cpbib.py [options].
        Make a copy of your master BibTeX file in the /refs subdirectory.
    

    Options:
      -h, --help      show this help message and exit
      --full          create local bib by copying master bib
      --min           create local bib from citations in .aux
      --pdf           for each citation in .aux, copy associated pdf file to docs/
      --nocopy        analyze .aux, but don't copy associated pdf file
      --log=LOGLEVEL  logging level (debug, info, warning, error, critial)

Bare-minimum bib file
^^^^^^^^^^^^^^^^^^^^^

The ``test.aux`` and ``fabfile.cfg`` files must be present, and you should edit ``fabfile.cfg`` so that it contains the location and name of *your* master ``bib`` file.  To create the minimum ``bib`` file run ::

    python cpbib.py --min

This command can take a while to execute if the master bibliography file contains a few thousand references like mine does.  If you want to see what's going on, run instead ::

    python cpbib.py --min --log=info
    
When I run this command I see the output ::

         master bib = {/Users/jam99/Dropbox/UNSORTED/UNSORTED_bib.bib}
          local bib = {bib/jam99.bib}
           main tex = {test.tex}
      pdf directory = {/Users/jam99/Dropbox/UNSORTED/}
    parsing /Users/jam99/Dropbox/UNSORTED/UNSORTED_bib.bib (this may take a minute) 
    creating minimal bib/jam99.bib file with entries
    bibkeys found = {2}
     Ernst1987
     Kuehn2008feb
    write bib/jam99.bib

This information is available in the log file ``cpbib.log`` (``cat cpbib.log`` at the command line).  To instead copy of the *entire* master ``bib`` file run ::

    python cpbib.py --full --log=info
    
which for me will output ::

         master bib = {/Users/jam99/Dropbox/UNSORTED/UNSORTED_bib.bib}
          local bib = {bib/jam99.bib}
           main tex = {test.tex}
      pdf directory = {/Users/jam99/Dropbox/UNSORTED/}
    WARNING! bib/jam99.bib exists. overwrite? [Y|n]Y

    copying /Users/jam99/Dropbox/UNSORTED/UNSORTED_bib.bib => bib/jam99.bib

Note that the program asked me if I wanted to overwrite the existing local ``bib`` file; I answered ``Y``.  Copying over the master ``bib`` file is quick.  The above diagnostic  information will likewise be echoed to ``cpbib.log``.

Copy cited pdfs
^^^^^^^^^^^^^^^

The ``test.aux`` and ``fabfile.cfg`` files must be present, and you should edit ``fabfile.cfg`` so that it contains the location of *your* pdf files. First, do a dry run::

    python cpbib.py --pdf --nocopy --log=info

When I run this command it outputs ::

         master bib = {/Users/jam99/Dropbox/UNSORTED/UNSORTED_bib.bib}
          local bib = {bib/jam99.bib}
           main tex = {test.tex}
      pdf directory = {/Users/jam99/Dropbox/UNSORTED/}
    bibkeys found = {2}
     Ernst1987
     Kuehn2008feb
    pdf files found = {2969}
    pdfs missing = {1}
    pdfs found = {1}
     (Ernst1987,None)
     (Kuehn2008feb,Kuehn2008feb advances in mechanical detection of magnetic resonance 10.1063:1.2834737 *.pdf)

I can see that no associated ``pdf`` file was found for the first reference, ``Ernst1987`` (a book), while a ``pdf`` with a very long name was found for the second reference, ``Kuehn2008feb``.  Now run the program again to actually copy the files::

    python cpbib.py --pdf

If I want to see what was done, I can print out the log file ::

    cat cpbib.log

which for me outputs ::

         master bib = {/Users/jam99/Dropbox/UNSORTED/UNSORTED_bib.bib}
          local bib = {bib/jam99.bib}
           main tex = {test.tex}
      pdf directory = {/Users/jam99/Dropbox/UNSORTED/}
    bibkeys found = {2}
     Ernst1987
     Kuehn2008feb
    pdf files found = {2969}
    pdfs missing = {1}
    pdfs found = {1}
     (Ernst1987,None)
     (Kuehn2008feb,Kuehn2008feb advances in mechanical detection of magnetic resonance 10.1063:1.2834737 *.pdf)
    Kuehn2008feb ==> copying {/Users/jam99/Dropbox/UNSORTED/Kuehn2008feb advances in mechanical detection of magnetic resonance 10.1063:1.2834737 *.pdf} to {docs/Kuehn2008feb advances in mechanical detection of magnetic resonance 10.1063:1.2834737 *.pdf}

We can see that only one ``pdf`` file was copied to the ``/docs`` directory.  This citation is one from my group.  It was published with an Open Access copyright and so I have included it in this repository.

Further reading
===============

* Andy Clifton's AccessibleMetaClass (`github <https://github.com/AndyClifton/AccessibleMetaClass>`__)

* How to convert a scientific manuscript from LaTeX to Word using Pandoc? (`link <https://tex.stackexchange.com/questions/111886/how-to-convert-a-scientific-manuscript-from-latex-to-word-using-pandoc>`__)



.. NOTE!  import latexcodec