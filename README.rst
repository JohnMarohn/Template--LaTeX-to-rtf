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

* ``bib/`` -- contains a small representative ``bib`` file, ``jam99.bib``

* ``bst/`` -- LaTeX bibliographic style files for formatting the bibliography

* ``csl/`` -- citation style language (CSL) files for formatting the bibliography

* ``docs/`` -- contains ``pdf`` copies of the articles cited in the ``tex`` file

* ``figs/`` -- contains a single representative figure, ``ex.pdf``


Requirements
============

To run the scripts you will need the Python packages

* fabric (``conda install fabric`` or ``pip install fabric``) and

* pybtex (``pip install pybtex``)

plus the command line program ``pdflatex``, which should come installed with your TeX distribution.  The main file-conversion script ``fabfile.py`` runs one of the two following external programs: 

* latex2rtf (`project <http://latex2rtf.sourceforge.net/index.html>`__ and `download <https://sourceforge.net/projects/latex2rtf/>`__) to generate ``rtf``, or

* pandoc (`project <http://pandoc.org/>`__ and `installing <http://pandoc.org/installing.html>`__) to generate ``docx``.

The citations in the ``docx`` file are generated using the

* citation style language (CSL, `project <http://citationstyles.org/>`__) and

* CSL styles (`github <https://github.com/citation-style-language/styles>`__).

I have included a number of *American Chemical Society* CSL files in the ``csl/`` directory.  You can find other CSL files at the github repository referenced above.

Usage
=====  

Further reading
===============

* Andy Clifton's AccessibleMetaClass (`github <https://github.com/AndyClifton/AccessibleMetaClass>`__)

* How to convert a scientific manuscript from LaTeX to Word using Pandoc? (`link <https://tex.stackexchange.com/questions/111886/how-to-convert-a-scientific-manuscript-from-latex-to-word-using-pandoc>`__)



.. NOTE!  import latexcodec