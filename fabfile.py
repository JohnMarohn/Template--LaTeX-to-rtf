# -*- coding: utf-8 -*-
import glob
import os
import shutil
from fabric.api import task, local, env, settings
import time
import sys
import ConfigParser

configParser = ConfigParser.RawConfigParser()
configFilePath = "fabfile.cfg"
configParser.read(configFilePath)

env.bib = configParser.get('bib', 'local')
env.tex = configParser.get('tex', 'main')
env.doc = configParser.get('tex', 'main').rstrip("tex").rstrip(".")

print(" bib = {{{bib}}}".format(**env))
print(" tex = {{{tex}}}".format(**env))
print(" doc = {{{doc}}}".format(**env))

@task
def docx():
    """convert tex document to docx format.  Run first: python cpbib.py --min."""
    
    with settings(warn_only=True):

        local("pandoc -s {tex} --filter pandoc-citeproc --natbib --bibliography {bib} --csl csl/american-chemical-society-with-titles-sentence-case-doi.csl  -o {doc}.docx".format(**env))

@task
def rtf():
    """convert tex document to rtf format"""

    with settings(warn_only=True):

        local("latex {doc}".format(**env))
        local("bibtex {doc}".format(**env))
        local("latex {doc}".format(**env))
        local("latex {doc}".format(**env))
        local("latex2rtf {doc}".format(**env))
    
@task
def odocx():
    """open the docx document with Microsoft word (OS X only)"""
    local("open -a 'Microsoft Word' {doc}.docx".format(**env)) 

@task
def ortf():
    """open the rtf document with Microsoft word (OS X only)"""
    local("open -a 'Microsoft Word' {doc}.rtf".format(**env))

@task
def clean():
    """Remove Vitae aux files"""
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
