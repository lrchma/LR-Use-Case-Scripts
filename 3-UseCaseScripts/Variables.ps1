<#
.SYNOPSIS
MASTER FILE USED BY ALL USE CASE SCRIPTS.  TRY NOT TO DELETE, MOVE OR OTHERWISE BREAK.  ALSO, WHY ARE YOU TRYING TO RUN THIS?!?!

.DESCRIPTION
Used by LR Use Case Scripts for variables and stuff.  Set variables as per extensive documentation in this file.

.EXAMPLE
Should not be run, ever!

.NOTES
April 2017 @chrismartin

.LINK
https://github.com/lrchma/Use-Case-Scripts

#>


#Root folder that contains LR Demo scripts, don't include trailing backslash.  You probably want to change this!
$root = "D:\UCG\3-UseCaseScripts"

#Output folder that the LR Demo scripts will be written, do include trailing backslash.  Recommend to leave at c:\logs\ if using LR Demo Script EMDB.  Pre-create this folder or else there will be errors!
$path = "c:\logs\"

#Extension that LR Demo scripts text files will use.  Recommended to leave at .log if using LR Demo Script EMDB
$extension = ".log"

