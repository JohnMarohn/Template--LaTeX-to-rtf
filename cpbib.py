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
import logging

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
    elements are *not* decapitalized.
    """

    bigstring = ''
    f = open(aux,'r')
    for line in f:
        bigstring = bigstring + line

    ref_key_array = []
    for m in re.finditer("\citation{(.+?)}",bigstring,re.DOTALL):
        ref_key_array.append(m.group(1))

    ref_key_array__sorted = sorted(set(ref_key_array),key=str.lower)

    logger.info("bibkeys found = {{{0}}}".format(len(ref_key_array__sorted)))    
    for bibkey in ref_key_array__sorted:
        logger.info(" {0}".format(bibkey))


    return ref_key_array__sorted

def logbibkeys(bibkeys):
    """Write the list of bibkeys to cpbib.log."""

    fp_log = open('cpbib.log', 'w')
    for bibkey in bibkeys:
        fp_log.write("{0}\n".format(bibkey))
    fp_log.write("references total = {{{}}}\n".format(len(bibkeys)))
    fp_log.flush()

def processpdf(pdf_dir, bibkeys, NOCOPY):
    """Return a list consisting of the names of the pdf files whose names
    start with one of the bibkeys.
    
    Locate all the *.pdf files in the pdf directory.  Use a brute-force search to 
    locate the pdf files whose names start with a bibkey: compare *each*  pdf 
    filename to *all* the reference keys.  Most filenames won't have a match.  
    The variable bibkeys__found stores the found (bibkey, pdf filename) pairs as a
    list of tuples.  If no associated filename was found then the second field of the 
    tuple will be None.
    
    After identifying the pdf filenames associated with each bibkey, copy these pdf
    files from the global pdf directory to the local docs/ directory.  Tack on the
    directory name to obtain the full filename which we need to implement the copy. 
    If the sub-directory docs/ does not exist then create it.  The function
    sys.argv[0] returns full name of the calling program, including the path name.  
    Strip the leading directory name from the full name  of the program using 
    os.path.dirname(). Use the python utility shutil() to carry out the copying.  
    We'll not do any status-checking on the copy; the original file *must* exist 
    since we found it by a search; assume that it's OK to write to the /docs 
    directory, since we created it.
    """
    
    pdf_array = []
    for filename in glob.glob(pdf_dir + '*.pdf'):
        head, tail = os.path.split(filename)
        pdf_array.append(tail)

    logger.info("pdf files found = {{{0}}}".format(len(pdf_array)))

    pdf_array__matched = []
    bibkeys__found = [(key,None) for key in bibkeys]
    
    for filename in pdf_array:
        for index, key in enumerate(bibkeys):
            m = re.match(key,filename)
            if m is not None:
                bibkeys__found[index] = (key,filename)

    pdfs_missing = sum(pdf is None for (bibkey,pdf) in bibkeys__found)
    pdfs_found = len(bibkeys__found) - pdfs_missing

    logger.info("pdfs missing = {{{0}}}".format(pdfs_missing))
    logger.info("pdfs found = {{{0}}}".format(pdfs_found))
    for bibkey, pdf in bibkeys__found:
        logger.info(" ({0},{1})".format(bibkey, pdf))

    name_of_directory = os.path.dirname(sys.argv[0])
    name_of_subdirectory = os.path.join(name_of_directory,'docs')

    if NOCOPY == False:
    
        if not os.path.exists(name_of_subdirectory):
            logger.info("the docs/ subdirectory does not exist; creating it")
            os.mkdir(name_of_subdirectory)
        else:
            logger.debug("the docs/ subdirectory exists")
            
    for bibkey, filename in bibkeys__found:
    
        if filename is not None:
        
            filename_orig = pdf_dir + filename
            filename_copy = os.path.join(name_of_subdirectory,filename)
            logger.debug("{0} ==> copying {{{1}}} to {{{2}}}".format(
                bibkey, filename_orig, filename_copy))
        
            if NOCOPY == False:
            
                logger.info("{0} ==> copying {{{1}}} to {{{2}}}".format(
                    bibkey, filename_orig, filename_copy))

                shutil.copy(filename_orig, filename_copy)
                
        else:
            logger.debug("{0} ==> no associated pdf file to copy".format(bibkey))

    return bibkeys__found

def addoptions(optParser):
    """Add useful options to the option parser."""

    newOptParser = deepcopy(optParser)

    newOptParser.add_option("", "--full",
        dest="FULL",
        action="store_true",
        default=False,
        help="create local bib by copying master bib")

    newOptParser.add_option("", "--min",
        dest="MIN",
        action="store_true",
        default=False,
        help="create local bib from citations in .aux")

    newOptParser.add_option("", "--pdf",
        dest="PDF",
        action="store_true",
        default=False,
        help="for each citation in .aux, copy associated pdf file to docs/")

    newOptParser.add_option("", "--nocopy",
        dest="NOCOPY",
        action="store_true",
        default=False,
        help="analyze .aux, but don't copy associated pdf file")

    newOptParser.add_option("", "--log",
        dest="LOGLEVEL",
        action="store",
        default="WARNING",
        help="logging level (debug, info, warning, error, critial)")
        
    return newOptParser

# ========================

if __name__ == "__main__":

    usage = """usage: %prog [options].
    Make a copy of your master BibTeX file in the /refs subdirectory.
    """

    optParser = OptionParser(usage=usage)  # parses command line options
    optParser = addoptions(optParser)
    (options, remainingargs) = optParser.parse_args()

    numeric_level = getattr(logging, options.LOGLEVEL.upper(), None)
    if not isinstance(numeric_level, int):
        raise ValueError("Invalid log level: {0}".format(options.LOGLEVEL))

    if remainingargs != []: # check for leftover arguments
        raise RuntimeError, "argument(s) \"%s\" not recognized" % (remainingargs[0])

    configParser = ConfigParser.RawConfigParser()   
    configFilePath = "fabfile.cfg"
    configParser.read(configFilePath)
    
    BIB_MASTER = configParser.get('bib', 'master')
    BIB_LOCAL = configParser.get('bib', 'local')
    TEX_MAIN = configParser.get('tex', 'main')
    PDF_DIR = configParser.get('pdf', 'master')
    
    # https://fangpenlin.com/posts/2012/08/26/good-logging-practice-in-python/
    logger = logging.getLogger(__name__)    
    logger.setLevel(logging.DEBUG)
    
    handler1 = logging.FileHandler('cpbib.log', mode='w')
    handler1.setLevel(logging.INFO)
    
    logger.addHandler(handler1)
    
    handler2 = logging.StreamHandler()
    handler2.setLevel(level=numeric_level)
    
    logger.addHandler(handler2)
    
    logger.info("     master bib = {{{0}}}".format(BIB_MASTER))
    logger.info("      local bib = {{{0}}}".format(BIB_LOCAL))
    logger.info("       main tex = {{{0}}}".format(TEX_MAIN))
    logger.info("  pdf directory = {{{0}}}".format(PDF_DIR))

    if options.FULL == True:
    
        if not os.access(BIB_LOCAL, os.F_OK):

            shutil.copy(BIB_MASTER, BIB_LOCAL)
            logger.info("copying {0} -> {1}".format(BIB_MASTER,BIB_LOCAL))
        
        else:

            sys.stderr.write( "WARNING! {0} exists. overwrite? [Y|n]".format(BIB_LOCAL))
            inputStr = raw_input("")
            if inputStr.lower() == "n":
                sys.exit(1)
            sys.stderr.write("\n")
            shutil.copy(BIB_MASTER,BIB_LOCAL)
            logger.info("copying {0} => {1}".format(BIB_MASTER,BIB_LOCAL))

    if options.MIN == True:

        oldbib = bibtex.Parser()
        logger.info("parsing {0} (this may take a minute) ".format(BIB_MASTER))
        oldbib.parse_file(BIB_MASTER)

        logger.info("creating minimal {} file with entries".format(BIB_LOCAL))       
        newbib =  bibtex.Parser()

        bibkeys = processaux(getaux())        
        for key in bibkeys:
            newbib.data.add_entry(key,oldbib.data.entries[key])

        logger.info("write {}".format(BIB_LOCAL)) 
        newbib.data.to_file(file=BIB_LOCAL,bib_format="bibtex")

    if options.PDF == True:
    
        bibkeys = processaux(getaux())
        bibkeys__found = processpdf(PDF_DIR, bibkeys, options.NOCOPY)