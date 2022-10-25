* Reference the uploaded JSON data;
filename indata filesrvc "&_WEBIN_FILEURI";

* Use the JSON engine to provide read-only sequential access to JSON data;
libname indata json;

* Create a CAS session ;
cas mysession;

* Assign a library pointing to the casuser library;
libname myCAS cas caslib="casuser";

* Create a CAS table under the casuser library and populate it with JSON data;
data myCAS.CarsRate (append=yes);
length make model $200;
set indata.root ;
drop ordinal_root;
run;

* Check if CAS table already has global state and promote it if not;
proc cas;
table.tableexists result=info /caslib="casuser" name="CarsRate";
if info.exists = 1 then do;
action table.promote /caslib="casuser" name="CarsRate";
end;
run;

* Assign the _webout filename to write the response for the job;
filename _webout filesrvc  parenturi="&SYS_JES_JOB_URI" name='_webout.json';

* Write to the _webout the JSON data for the execution status and the username;
proc json out=_webout pretty nosastags;
    write open object ;
    write values 'syscc';
    write values &syscc;
    write values 'sysuserid';
    write values &sysuserid;
    write close;
run;
quit;
