Experiments Using XSLT with Topic Maps
======================================

The self-extracting ZIP file is an EXE that will create files and
subdirectories as required.  When treating the EXE file as a ZIP
file on non-DOS systems, the archive must be extracted preserving
subdirectories.

Unpacked Directories:
--------------------
 - resources   - original XTM resource HTML files
               - copied to result directory
 - stylesheets - rendering transformations for topics and index
               - copied to work directory
 - doc         - supporting paper

Resulting Directories:
---------------------
 - result      - resulting topic map rendering
 - work        - intermediate work files
               - synthesized stylesheets

Process:
-------

Execute the "run.bat" batch file with the current directory being the
directory in which that file is found.  This will create the resulting
directories.


$Id: readme.txt,v 1.3 2000/11/29 02:14:45 Administrator Exp $

End of File