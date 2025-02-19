## ead-analysis-tools

This repo contains a set of minimal scripts that allow users to analyze the structure and composition of [EAD files](https://www.loc.gov/ead/).  


## Available Tools
* [DAO Role Extractor](#dao-role-extractor)
* [Element-Nesting Depth Analyzer](#element-nesting-depth-analyzer)
* [Element Union Analyzers](#element-union-analyzers)
* [Element Union Analyzers with Child-Element Sequence Data](#element-union-analyzers-with-child-element-sequence-data)
* [Element Hierarchy Analyzers](#element-hierarchy-analyzers)
* [Element Count Analyzer](#element-count-analyzer)

<hr>  

### DAO Role Extractor
**Purpose:**  
This script collects the set of `<dao @xlink:role>` attributes found in a set of EADs.

**Script:**  
[`dao-role-extractor-multi.rb`](./bin/dao-role-extractor-multi.rb)

**Usage:**
```
dao-role-extractor-multi.rb <path to file containing paths of EADs to analyze>
```
**Example:**
```
# from this project's test/ directory
../bin/dao-role-extractor-multi.rb fixtures/dao-role-extractor-file-list.txt
```

**Sample Output (STDOUT):**  
```
ROLES:
audio-service
electronic-records-service
image-service

ERRORS:
file: ./fixtures/mc_74-missing-role.xml has 1 error(s)
dao@xlink:role value is nil in file: ./fixtures/mc_74-missing-role.xml
```
**Sample Output (STDERR):**  
```
processing ./fixtures/Omega-EAD-extra-nesting.xml
processing ./fixtures/aia_074.xml
processing ./fixtures/mc_74.xml
processing ./fixtures/mc_74-missing-role.xml
```
[back to Available Tools](#available-tools)
<hr>

### Element-Nesting Depth Analyzer
**Purpose:**   
This script determines the maximum nesting level for the specified element in an EAD.  

**Script:**   
[`element-depth-analyzer.rb`](./bin/c-element-depth-analyzer.rb)

**Usage:**
```
element-depth-analyzer.rb <path to EAD file> <element of interest>
```
**Example:**
In the example below, the `foo/bar.xml` file is being analyzed to determine the maximum nesting level of the `<c>` element. 
The number returned indicates the depth of the deepest `<c>` element hierarchy in the `foo/bar.xml` file.   

For example, if the deepest <c> element hierarchy in foo/bar.xml is:
```
        <c>
          ...
          <c>
            ...
            <c>
              ...
            </c>
          </c>
        </c>
```
Then the script output will look like this:
```
$ element-depth-analyzer.rb foo/bar.xml c
3,./foo/bar.xml
```
**Sample Output (STDOUT):**  
```
5,vlp/mss_lapietra_001.xml
```  

**Performance Note:**  
This code is **not** optimized. It takes about 30 minutes to grind through a set of 2,111 EADs on a MacBook Pro with 16 GB of RAM.

[back to Available Tools](#available-tools)
<hr>

### Element Union Analyzers
**Purpose:**  
These scripts gather the set of attributes, parent/child relationships, peer-element relationships, and nesting level for every element of interest listed in the scripts.

**Scripts:**  
[`element-union-multi.rb`](./bin/element-union-multi.rb)  
[`element-union-single.rb`](./bin/element-union-single.rb)  

#### Multi-file analyzer:
**Usage:**
The multi-file analyzer script takes as an argument a file containing paths to a set of EAD files to analyze.  
```
element-union-multi.rb <path to file containing paths of EADs to analyze>
```

**Example:**
```
element-union-multi.rb dlts-finding-aids-ead-poly-file-list.txt 
```

#### Single-file analyzer:
**Usage:**
The single-file analyzer script takes as an argument the path of the EAD file to analyze.  
```
element-union-single.rb <path of EAD file to analyze>
```

**Example:**
```
element-union-single.rb fales/mss_208.xml 
```

**Sample Output:**  
```
name;needs_array?;max_depth;attributes;children
abbr;false;0;["expan"];["text"]
abstract;false;0;["id"];["emph", "lb", "text", "title"]
accessrestrict;false;0;["id"];["head", "legalstatus", "list", "p", "text"]
accruals;false;0;["id"];["head", "p", "text"]
acqinfo;false;0;["id"];["head", "p", "text"]
address;false;0;[];["addressline", "text"]
addressline;true;0;[];["extptr", "text"]
altformavail;false;0;["id"];["head", "p", "text"]
appraisal;false;0;["id"];["head", "p", "text"]
archdesc;false;0;["level"];["accessrestrict", "accruals", "acqinfo", "altformavail", "appraisal", "arrangement", "bibliography", "bioghist", "controlaccess", "custodhist", "did", "dsc", "odd", "originalsloc", "otherfindaid", "phystech", "prefercite", "processinfo", "relatedmaterial", "scopecontent", "separatedmaterial", "text", "userestrict"]
archref;false;0;[];["extref", "physloc", "text"]
arrangement;false;0;["id"];["head", "p", "text"]
author;false;0;[];["text"]
bibliography;false;0;["id"];["bibref", "head", "p", "text"]
bibref;true;0;[];["corpname", "emph", "lb", "name", "persname", "text", "title"]
bioghist;false;0;["id"];["head", "p", "text"]
blockquote;false;0;[];["p", "text"]
c;true;5;["id", "level", "otherlevel"];["accessrestrict", "accruals", "acqinfo", "appraisal", "arrangement", "bibliography", "bioghist", "c", "controlaccess", "custodhist", "did", "fileplan", "index", "odd", "originalsloc", "otherfindaid", "phystech", "prefercite", "processinfo", "relatedmaterial", "scopecontent", "separatedmaterial", "text", "userestrict"]
change;false;0;[];["date", "item", "text"]
chronitem;false;0;[];["date", "eventgrp", "text"]
chronlist;false;0;[];["chronitem", "head", "text"]
container;true;0;["altrender", "id", "label", "parent", "type"];["text"]
controlaccess;false;0;[];["corpname", "famname", "function", "genreform", "geogname", "occupation", "persname", "subject", "text", "title"]
corpname;false;0;["role", "rules", "source"];["text"]
creation;false;0;[];["date", "text"]
custodhist;false;0;["id"];["head", "p", "text"]
dao;false;0;["actuate", "href", "role", "show", "title", "type"];["daodesc", "text"]
daodesc;false;0;[];["p", "text"]
daogrp;false;0;["title", "type"];["daodesc", "daoloc", "text"]
daoloc;true;0;["href", "role", "title", "type"];[]
date;false;0;["type"];["text"]
defitem;true;0;[];["item", "label", "text"]
descrules;false;0;[];["text"]
did;false;0;[];["abstract", "container", "dao", "daogrp", "langmaterial", "materialspec", "origination", "physdesc", "physloc", "repository", "text", "unitdate", "unitid", "unittitle"]
dimensions;false;1;["id", "label"];["dimensions", "text"]
dsc;false;0;[];["c", "text"]
ead;false;0;["schemaLocation"];["archdesc", "eadheader", "text"]
eadheader;false;0;["countryencoding", "dateencoding", "findaidstatus", "langencoding", "repositoryencoding"];["eadid", "filedesc", "profiledesc", "revisiondesc", "text"]
eadid;false;0;["url"];["text"]
editionstmt;false;0;[];["p", "text"]
emph;false;0;["render"];["text"]
event;false;0;[];["emph", "text", "title"]
eventgrp;false;0;[];["event", "text"]
extent;true;0;["altrender", "unit"];["emph", "lb", "text"]
extptr;false;0;["href", "show", "title", "type"];[]
extref;false;0;["href", "show", "title", "type"];["text"]
famname;false;0;["role", "rules", "source"];["text"]
filedesc;false;0;[];["editionstmt", "notestmt", "publicationstmt", "text", "titlestmt"]
fileplan;false;0;["id"];["head", "p", "text"]
function;false;0;["source"];["text"]
genreform;true;0;["source"];["text"]
geogname;false;0;["source"];["text"]
head;false;0;[];["emph", "extptr", "text"]
head01;false;0;[];["text"]
head02;false;0;[];["text"]
index;false;0;["id"];["head", "indexentry", "p", "text"]
indexentry;true;0;[];["corpname", "name", "subject", "text"]
item;true;0;[];["bibref", "corpname", "emph", "lb", "name", "text"]
label;false;0;[];["text"]
langmaterial;false;0;["id"];["emph", "language", "text"]
language;false;0;["encodinganalog", "langcode"];["text"]
langusage;false;0;[];["language", "text"]
lb;false;0;[];[]
legalstatus;false;0;["id"];["text"]
list;true;0;["numeration", "type"];["defitem", "head", "item", "listhead", "text"]
listhead;false;0;[];["head01", "head02", "text"]
materialspec;false;0;["id"];["text"]
name;true;0;[];["text"]
note;false;0;[];["p", "text"]
notestmt;false;0;[];["note", "text"]
num;true;0;["type"];["text"]
occupation;true;0;["source"];["text"]
odd;false;0;["id"];["head", "list", "p", "text"]
originalsloc;false;0;["id"];["head", "p", "text"]
origination;true;0;["label"];["corpname", "famname", "persname", "text"]
otherfindaid;false;0;["id"];["head", "p", "text"]
p;true;0;[];["abbr", "address", "archref", "bibref", "blockquote", "chronlist", "corpname", "date", "genreform", "lb", "list", "name", "num", "occupation", "subject", "text"]
persname;false;0;["role", "rules", "source"];["text"]
physdesc;true;0;["altrender", "id", "label"];["dimensions", "extent", "physfacet", "text"]
physfacet;false;0;["id", "label"];["emph", "text"]
physloc;true;0;["id"];["text"]
phystech;false;0;["id"];["head", "p", "text"]
prefercite;false;0;["id"];["head", "p", "text"]
processinfo;false;0;["id"];["head", "p", "text"]
profiledesc;false;0;[];["creation", "descrules", "langusage", "text"]
publicationstmt;false;0;[];["address", "p", "publisher", "text"]
publisher;false;0;[];["text"]
relatedmaterial;false;0;["id"];["head", "p", "text"]
repository;false;0;[];["corpname", "text"]
revisiondesc;false;0;[];["change", "text"]
scopecontent;false;0;["id"];["head", "p", "text"]
separatedmaterial;false;0;["id"];["head", "p", "text"]
sponsor;false;0;[];["text"]
subject;true;0;["source"];["text"]
subtitle;false;0;[];["text"]
text;false;0;[];[]
title;true;0;["render", "source", "type"];["emph", "text"]
titleproper;true;0;["type"];["emph", "lb", "num", "text"]
titlestmt;false;0;[];["author", "sponsor", "subtitle", "text", "titleproper"]
unitdate;true;0;["normal", "type"];["text"]
unitid;false;0;[];["text"]
unittitle;false;0;[];["corpname", "emph", "lb", "name", "persname", "text", "title"]
userestrict;false;0;["id"];["head", "p", "text"]
```

#### Adding results to the Element Analysis Google spreadsheet:
Open the [Google Sheets example document](https://docs.google.com/spreadsheets/d/1_G_BuDhZJN3kXHp3cIaSj75UgIsMQRwINX_Nn3PR_ow/edit?usp=sharing)  
Make a copy for your own use  
Duplicate an existing "union analysis" sheet   
Rename the duplicated sheet as appropriate   

Copy the output from the `element-union-multi.rb` command.  
Paste it into a new *Excel* workbook as column A (a single column).   
(Excel is needed so that you can use a semicolon as a column delimiter)  

In Excel, click on the following menu items:   
  Data --> Text to Columns... --> Delimited --> Next --> (Select "Semicolon" checkbox) --> Finish  
Copy columns A::E from the Excel spreadsheet  

In your new Google "union analysis" sheet:  
Paste the copied Excel columns into Google Sheet columns A::E  

Review the results.  

**Performance Note:**  
Performance depends on the size of the EAD file in question.  
For example, the analysis of the Omega-EAD XML file (82 KB) takes less
than a second while the analysis of the tamwag/photos_223.xml file (15
MB) takes ~3 min 15 sec.

[back to Available Tools](#available-tools)
<hr>


### Element Union Analyzers with Child-Element Sequence Data:
**Purpose:**  
These scripts gather the set of attributes, parent/child relationships, peer-element relationships, nesting level, **and the sequence of the child elements** for every element of interest listed in the scripts.

[`element-union-with-child-sequences-multi.rb`](./bin/element-union-with-child-sequences-multi.rb)
[`element-union-with-child-sequences-single.rb`](./bin/element-union-with-child-sequences-single.rb)


#### Multi-file analyzer:

**Usage:**  
The multi-file analyzer script takes as an argument a file containing paths to a set of EAD files to analyze.
```
element-union-with-child-sequences-multi.rb <path to file containing paths of EADs to analyze>
```
**Example:**  
```
element-union-with-child-sequences-multi.rb dlts-finding-aids-ead-poly-file-list.txt 
```

#### Single-file analyzer:  
**Usage:**  
The single-file analyzer script takes as an argument the path of the EAD file to analyze.  
```
element-union-with-child-sequences-single.rb  <path of EAD file to analyze> 
```
**Example:**
```
element-union-single.rb tamwag/tam_709.xml 
```

**Sample Output:**
```
name;needs_array?;max_depth;attributes;children;child_sequences
abstract;false;0;["id"];["text"];["text"]
accessrestrict;false;0;["id"];["head", "p"];["head_p"]
archdesc;false;0;["level"];["accessrestrict", "arrangement", "bioghist", "controlaccess", "custodhist", "did", "dsc", "prefercite", "processinfo", "scopecontent", "userestrict"];["did_custodhist_arrangement_scopecontent_bioghist_bioghist_prefercite_userestrict_accessrestrict_processinfo_controlaccess_dsc"]
arrangement;false;0;["id"];["head", "list", "p"];["head_p_p_p_list_p"]
author;false;0;[];["text"];["text"]
bioghist;true;0;["id"];["chronlist", "head", "list", "p"];["head_chronlist", "head_p_p_p_p_p_p_p_p_list"]
...
```
**Example with Analysis:**
```
# Run script and capture output
element-union-with-child-sequences-single.rb fales/mss_270.xml | tee fales-mss_270-with-child-sequences.txt

# Filter output: select element name and child sequences
cut -d';' -f1,6 fales-mss_270-with-child-sequences.txt 

# Filtered output
name;child_sequences
abstract;["text"]
accessrestrict;["head_p"]
archdesc;["did_custodhist_arrangement_scopecontent_bioghist_bioghist_prefercite_userestrict_accessrestrict_processinfo_controlaccess_dsc"]
arrangement;["head_p_p_p_list_p"]
author;["text"]
bioghist;["head_chronlist", "head_p_p_p_p_p_p_p_p_list"]
...
```
[back to Available Tools](#available-tools)
<hr>  

### Element Hierarchy Analyzers  
**Purpose:**  
These scripts show the element hierarchies for an element of interest.  This is useful when identifying cases requiring order-preservation.  One script simply outputs the element hierarchy, while the other outputs the hierarchy **and** displays where text was detected.  (The EAD 2002 schema supports "formatting" elements, e.g., `<emph>`, `<lb>`, `<blockquote>`. These must be handled differently from other elements when stream parsing because the text and formatting elements need to be treated as a single unit.) 

**Scripts:**  
[`element-hierarchy-analyzer.rb`](./bin/element-hierarchy-analyzer.rb)  
[`element-hierarchy-analyzer-with-text-detection.rb`](./bin/element-hierarchy-analyzer-with-text-detection.rb)  

#### Element Hierarchy Analyzer  
**Usage:**  
```
element-hierarchy-analyzer.rb <path of EAD file to analyze> <element of interest>
```

**Example:**  
```
element-hierarchy-analyzer.rb archives/mc_177.xml bioghist
```

**Sample Output:**
```
<bioghist><head></head><p></p><p></p><p><blockquote><p></p></blockquote></p><p><emph></emph><emph></emph></p><p></p><p><emph></emph><emph></emph><emph></emph></p></bioghist>,test/fixtures/mc_177.xml
<bioghist><head></head><p></p><p><blockquote><p></p></blockquote></p><p></p></bioghist>,archives/mc_177.xml
```

#### Element Hierarchy Analyzer with Text Detection
**Usage:**  
```
element-hierarchy-analyzer-with-text-detection.rb <path of EAD file to analyze> <element of interest>
```

**Example:**  
```
element-hierarchy-analyzer-with-text-detection.rb archives/mc_177.xml bioghist
```

**Sample Output:**
```
<bioghist><head>TEXT</head><p>TEXT</p><p>TEXT</p><p><blockquote><p>TEXTTEXT</p></blockquote></p><p>TEXT<emph>TEXT</emph>TEXT<emph>TEXT</emph>TEXT</p><p>TEXT</p><p>TEXT<emph>TEXT</emph>TEXTTEXT<emph>TEXT</emph>TEXT<emph>TEXT</emph>TEXT</p></bioghist>,archives/mc_177.xml
<bioghist><head>TEXT</head><p>TEXT</p><p><blockquote><p>TEXT</p></blockquote></p><p>TEXT</p></bioghist>,archives/mc_177.xml
```

back to Available Tools](#available-tools)
<hr>

### Element Count Analyzer
**Purpose:**  
This script counts the total number of occurrences of the elements of interest throughout an EAD.  (Please refer to the [gen-element-counts.sh](./bin/gen-element-counts.sh) script  
to see the list of elements.)

### NOTE: THE EAD FILES MUST BE PRETTY PRINTED BEFORE RUNNING THE ANALYZER OR THE COUNTS WILL BE INACCURATE!!!
To pretty print an EAD, one can use [`xmllint`](https://xmllint.com/) like this:
```
xmllint --format my-non-pretty-printed-ead.xml > pretty-printed-ead.xml
```

To bulk pretty-print a directory hierarchy of EADs and overwrite the original EADs, one can use `xmllint` like this:
```
for f in $(find . -type f -name '*.xml' | sort -V); do  echo "$f"; xmllint --format $f > foo.xml && mv foo.xml $f;  done
```

**Script:**  
[`gen-element-counts.sh`](./bin/gen-element-counts.sh)

**Usage:**
```
gen-element-counts.sh <path of EAD file to analyze>
```

**Example:**  
```
gen-element-counts.sh fales/mss_003.xml
```

**Sample Output:**
```c
FILE,abstract,accessrestrict,accruals,acqinfo,address,addressline,altformavail,appraisal,archdesc,archref,arrangement,bibliography,bibref,bioghist,blockquote,c,change,chronitem,chronlist,colspec,container,controlaccess,corpname,creation,custodhist,dao,daodesc,daogrp,daoloc,date,defitem,did,dimensions,dsc,eadheader,eadid,editionstmt,emph,entry,event,eventgrp,extent,extptr,extref,famname,filedesc,fileplan,function,genreform,geogname,head,index,indexentry,item,langmaterial,language,langusage,legalstatus,list,materialspec,name,note,notestmt,num,occupation,odd,originalsloc,origination,otherfindaid,p,persname,physdesc,physfacet,physloc,phystech,prefercite,processinfo,profiledesc,publicationstmt,relatedmaterial,repository,revisiondesc,row,scopecontent,separatedmaterial,subject,table,tbody,tgroup,title,titleproper,titlestmt,unitdate,unittitle,userestrict,
foo/bar.xml,1,1,0,1,0,0,0,0,1,0,1,0,0,1,0,1,0,0,0,0,1,1,2,1,0,0,0,0,0,2,0,2,0,1,1,1,0,0,0,0,0,2,0,0,0,1,0,0,0,0,8,0,0,0,1,0,1,0,0,0,0,0,0,1,0,0,0,1,0,9,1,1,0,1,0,1,1,1,1,0,1,0,0,1,0,2,0,0,0,0,1,1,2,2,1,
```
**Example with Analysis:**
```
# ----------------------------------------------------------
# Element Count Analyzer script execution / data processing
# ----------------------------------------------------------

# extract element counts
#  (in this example, file-list.txt contains the paths of 2,111 EADs)
for f in $(cat file-list.txt); do 
  ./bin/gen-element-counts.sh $f | tee -a element-counts.txt
done

# extract the header line
head -1 element-counts.txt > element-counts.csv

# extract the data and append it to csv file
grep -v FILE element-counts.txt >> element-counts.csv

# check that the line count equals the EAD file count + 1 (for the header row)
wc -l element-counts.csv 
    2112 element-counts.csv

# open the element-counts.csv file in a spreadsheet application
```

[back to Available Tools](#available-tools)
<hr>

## Testing
```
# to test the command-line utilities
cd test/
./run-tests

# to test the Ruby classes
# cd to the project root directory, then type the following:
ruby -I lib test/nyudl/ead/analysis_node_test.rb 
```
<hr>
