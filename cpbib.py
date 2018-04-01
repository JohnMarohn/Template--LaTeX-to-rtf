#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
cpbib.py
John A. Marohn (jam99@cornell.edu)
2018.03.31

Make a copy of your master BibTeX file in the /refs subdirectory.
"""

import os
import sys
import shutil
from optparse import OptionParser
from copy import deepcopy
import glob
import re
from pybtex.database.input import bibtex
import ConfigParser

# ========================

def getaux():
    """Return the most-recently generated .aux file.
    
    The variable aux is a list of tuples storing the names and file-creation
    times of the all the aux files in the current directory.  The time is in
    units of seconds since the start of the epoch.  Sort these tuples from the
    newest to oldest creation time.  The 0th element of the list is the
    newest one.
    """

    aux = []  # the names of all the aux files in the current directory

    for filename in glob.glob('*.aux'):
        aux.append((filename,os.path.getmtime(filename)))

    aux_sorted = sorted(aux, key=lambda elem: elem[1],reverse=True)
    aux_newest_filename, aux_newest_time = aux_sorted[0]
    
    return aux_newest_filename

def processaux(aux):
    """Return a list of the bibkeys found in the .aux file
    
    The .aux file contains lines like the following ones.  Some of the
    lines will be repeated.

        \citation{Ernst1987}
        \citation{Wiener1966aug}

    We want to extract into a list the text Ernst1987, Wiener1966aug, and
    so on.  It's easiest to process the entries in the file if we convert
    the whole file to a *single* long string, bigstring, that we search on.
    Scan the bigstring for the pattern \citation{stuff}; find text in between
    '\citation{' and the nearest '}', and use the DOTALL option in
    re.finditer() to read through newline \n characters.  We can count on
    there being only one entry between the opening '{' and the closing '}';
    consequently, we only need to look at the first element, m.group(1). 
    We next alphabetize the bibkeys in the list. First convert the list to
    a set, which serves to remove the duplicate items.  Then ask sorted()
    to sort on a de-caplitalized version/copy of the list; we do this using
    the option sorted(..., key=str.lower).  Note that the final sorted list
    elements are *not* decapitalized."""

    bigstring = ''
    f = open(aux,'r')
    for line in f:
        bigstring = bigstring + line

    ref_key_array = []
    for m in re.finditer("\citation{(.+?)}",bigstring,re.DOTALL):
        ref_key_array.append(m.group(1))
    
    ref_key_array__sorted = sorted(set(ref_key_array),key=str.lower)

    return ref_key_array__sorted

def logbibkeys(bibkeys):
    """Write the list of bibkeys to cpbib.log."""

    fp_log = open('cpbib.log', 'w')
    for bibkey in bibkeys:
        fp_log.write("{0}\n".format(bibkey))
    fp_log.write("references total = {{{}}}\n".format(len(bibkeys)))
    fp_log.flush()

def addoptions(optParser):
    """Add useful options to the option parser."""

    newOptParser = deepcopy(optParser)

    newOptParser.add_option("", "--min",
        dest="MIN",
        action="store_true",
        default=False,
        help="create the local bib from citations in the most recent .aux file")

    return newOptParser

# ========================

if __name__ == "__main__":

    usage = """usage: %prog [options].
    Make a copy of your master BibTeX file in the /refs subdirectory."""

    optParser = OptionParser(usage=usage)  # parses command line options
    optParser = addoptions(optParser)
    (options, remainingargs) = optParser.parse_args()

    if remainingargs != []: # check for leftover arguments
        raise RuntimeError, "argument(s) \"%s\" not recognized" % (remainingargs[0])

    configParser = ConfigParser.RawConfigParser()   
    configFilePath = "fabfile.cfg"
    configParser.read(configFilePath)
    
    BIB_MASTER = configParser.get('bib', 'master')
    BIB_LOCAL = configParser.get('bib', 'local')
    TEX_MAIN = configParser.get('tex', 'main')
    PDF_DIR = configParser.get('pdf', 'master')
    
    print("    master bib = {{{0}}}".format(BIB_MASTER))
    print("     local bib = {{{0}}}".format(BIB_LOCAL))
    print("      main tex = {{{0}}}".format(TEX_MAIN))
    print(" pdf directory = {{{0}}}".format(PDF_DIR))

    if options.MIN == False:
    
        if not os.access(BIB_LOCAL, os.F_OK):

            shutil.copy(BIB_MASTER, BIB_LOCAL)
            print("copying {0} -> {1}".format(BIB_MASTER,BIB_LOCAL))
        
        else:

            sys.stderr.write( "WARNING! {0} exists. overwrite? [Y|n]".format(BIB_LOCAL))
            inputStr = raw_input("")
            if inputStr.lower() == "n":
                sys.exit(1)
            sys.stderr.write("\n")
            shutil.copy(BIB_MASTER,BIB_LOCAL)
            print("copying {0} => {1}".format(BIB_MASTER,BIB_LOCAL))

    if options.MIN == True:

        oldbib = bibtex.Parser()
        print("parsing {0} (this may take a minute) ".format(BIB_MASTER))
        oldbib.parse_file(BIB_MASTER)

        print("creating minimal {} file with entries".format(BIB_LOCAL))       
        newbib =  bibtex.Parser()

        bibkeys = processaux(getaux())        
        for key in bibkeys:
        
            print("  {0}".format(key))
            newbib.data.add_entry(key,oldbib.data.entries[key])

        print("write {}".format(BIB_LOCAL)) 
        newbib.data.to_file(file=BIB_LOCAL,bib_format="bibtex")
        
        logbibkeys(bibkeys)
        print("write cpbib.log") 