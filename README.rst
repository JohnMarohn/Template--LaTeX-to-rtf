Template--LaTeX-to-rtf
######################

:author: John A. Marohn (jam99@cornell.edu)
:date: March 20, 2017

Here I collect an example file and helper scripts for creating a Microsoft Word document starting from a TeX file.

Although I do most of my scholarly writing in LaTeX, it is often necessary to write in Microsoft Word when collaborating with others.  Yet I have built up a large bibliographic database in LaTeX, and it would be nice to harness that database when preparing Microsoft Word documents.  Here I provide an example ``tex`` file and scripts for converting it into a ``docx`` file or an ``rtf`` file that can be opened by Microsoft word.

**Manifest**.  This repository contains the following files

* ``README.rst`` -- this file

* ``LICENSE`` -- GNU general public license (Version 3, 29 June 2007)

* ``test.tex`` -- example text with citations, equations, and a figure

* ``fabfile.py`` -- python file for running commands to compile to rtf and docx

* ``cpbib.py`` -- python file containing helper commands

* ``fabfile.cfg`` -- configuration file read by both fabfile.py and cpbib.py    

**Requirements**.  To run the scripts requires the following two python packages:

* fabric (``conda install fabric`` or ``pip install fabric``),

* pybtex (``pip install pybtex``), and

* pdflatex (should come installed with your TeX distributioin)

The main file-conversion script runs one of the two following external programs: 

* latex2rtf (`project <http://latex2rtf.sourceforge.net/index.html>`__ and `download <https://sourceforge.net/projects/latex2rtf/>`__) to generate ``rtf``, or

* pandoc (`project <http://pandoc.org/>`__ and `installing <http://pandoc.org/installing.html>`__) to generate ``docx``.

The citations in the ``docx`` file are generated using the

* citation style language (CSL, `project <http://citationstyles.org/>`__) and

* CSL styles (`github <https://github.com/citation-style-language/styles>`__).

I have included a number of *American Chemical Society* CSL files in the ``csl/`` directory.  You can find other CSL files at the github repository referenced above.

**Further reading**

* Andy Clifton's AccessibleMetaClass (`github <https://github.com/AndyClifton/AccessibleMetaClass>`__)

* How to convert a scientific manuscript from LaTeX to Word using Pandoc? (`link <https://tex.stackexchange.com/questions/111886/how-to-convert-a-scientific-manuscript-from-latex-to-word-using-pandoc>`__)



.. NOTE!  import latexcodec