# -*- coding: utf-8 -*-
import glob
import os
import shutil
from fabric.api import task, local, env, settings
import time
import sys
import ConfigParser
from sys import platform

configParser = ConfigParser.RawConfigParser()
configParser.read("fabfile.cfg")

env.bib = configParser.get('bib', 'local')
env.tex = configParser.get('tex', 'main')
env.doc = configParser.get('tex', 'main').rstrip("tex").rstrip(".")
env.csl = configParser.get('pandoc', 'csl')

print(" bib = {{{bib}}}".format(**env))
print(" tex = {{{tex}}}".format(**env))
print(" doc = {{{doc}}}".format(**env))
print(" csl = {{{csl}}}".format(**env))

@task
def docx():
    """Convert tex document to docx format using pandoc and open with Microsoft Word.  Run first: python cpbib.py --min."""
    
    with settings(warn_only=True):

        local("pandoc -s {tex} --filter pandoc-citeproc "
            "--natbib --bibliography {bib} "
            "--csl {csl} -o {doc}.docx".format(**env))

    if platform == "darwin":
        local("open -a 'Microsoft Word' {doc}.docx".format(**env))
    else:
        print("open {doc}.docx manually".format(**env))

@task
def rtf():
    """Convert tex document to rtf format using latex2rtf and open with Microsoft Word."""

    with settings(warn_only=True):

        local("pdflatex {doc}".format(**env))
        local("bibtex {doc}".format(**env))
        local("pdflatex {doc}".format(**env))
        local("pdflatex {doc}".format(**env))
        local("latex2rtf {doc}".format(**env))

    if platform == "darwin":
        local("open -a 'Microsoft Word' {doc}.rtf".format(**env))
    else:
        print("open {doc}.docx manually".format(**env))

@task
def clean():
    """Remove auxiliary files"""
    globs = [
            '*.aux',
            '*.bak',
            '*.bbl',
            '*.bcf',
            '*.blg',
            '*.dvi',
            '*.fgx',
            '*.log',
            '*.lof',
            '*.out',
            '*.run.xml', 
            '*.synctex.gz',
            '*.sav',
            '*.spl',
            '*.tbx',
            '*.toc',
            '*.vdx',
            '*.fdb_latexmk',
            '*.fls',
            '*.mp',
            '*.top',
            '*.tui',
            '*.pyc',
            '*.4ct',
            '*.4tc',
            '*.html',
            '*.idv',
            '*.lg',
            '*.tmp',
            '*.css',
            '*.xref'
            ]
    to_remove = []

    for glob_pattern in globs:
        to_remove.extend(glob.glob(glob_pattern))

    for filename in to_remove:
        os.remove(filename)

    print("Removed aux files")
