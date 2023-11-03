#!/bin/bash

# This script counts the occurrences of opening XML tags included in the list below
# usage: $0 <path to xml file>
# output:
#

set -u

ELEMENTS='abstract
accessrestrict
accruals
acqinfo
address
addressline
altformavail
appraisal
archdesc
archref
arrangement
bibliography
bibref
bioghist
blockquote
c
change
chronitem
chronlist
colspec
container
controlaccess
corpname
creation
custodhist
dao
daodesc
daogrp
daoloc
date
defitem
did
dimensions
dsc
eadheader
eadid
editionstmt
emph
entry
event
eventgrp
extent
extptr
extref
famname
filedesc
fileplan
function
genreform
geogname
head
index
indexentry
item
langmaterial
language
langusage
legalstatus
list
materialspec
name
note
notestmt
num
occupation
odd
originalsloc
origination
otherfindaid
p
persname
physdesc
physfacet
physloc
phystech
prefercite
processinfo
profiledesc
publicationstmt
relatedmaterial
repository
revisiondesc
row
scopecontent
separatedmaterial
subject
table
tbody
tgroup
title
titleproper
titlestmt
unitdate
unittitle
userestrict
'

if [[ $# -ne 1 ]]; then
    echo "incorrect number of arguments" >&2
    echo "usage: $0 <path to EAD xml file>" >&2
    exit 1
fi

file="$1"

if [[ ! -r "$file" ]]; then
    echo "ERROR: $file is not readable" >&2
    exit 1
fi

printf "FILE,"
for e in $ELEMENTS; do
    printf "$e,"
done
printf "\n"

printf "$file,"
for e in $ELEMENTS; do
    regexp="<$e(\s+|>)"
    result=$(grep -c -E "$regexp" "$file")
    printf "$result,"
done
printf "\n"


