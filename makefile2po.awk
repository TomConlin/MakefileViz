#! /bin/awk -f

# given a makefile 
# attempts to emmit a brief representation of
# each dependency and its target one pair per line.

# drop everything from a hash on (line comment)
function uncomment(loc,   end){
	if(end=index(loc,"#")){
		loc=substr(loc,1,end)
	} 
	return loc
}

# keep underscore, letters & numbers 
# change the rest to (a single) underscore sans leading & trailing
function simplify(str){
	gsub(/[^[:alpha:][:digit:]_]+/,"_",str);  # CHANGEME: if you want different chars to pass
	gsub(/^_+|_+$/, "",str);
	gsub(/__*/,"_",str);
	return str
}
	
BEGIN{OFS="\t"}

{ # all lines are considered (in blocks if escaped newlines are present)
	 line=uncomment($0);
	 while(match(line,/\\$/)) {
	 	line=substr(line,1,length(line)-1);
	 	getline;
	 	line=(line "\t" uncomment($0))
	 }
	 $0=line
}

# if the (modified) line appears to be:  <target> : [dependent [dependent ...]] 
# strip cruft of the words and output them a pair per line target second 
# note on past systems awk wanted hex \09 instead of the current \011 octal
/^[^\011:][^:]*:.*/  {
	t=simplify($1);
	for(n=2;n<=NF;n++){
		s=simplify($n);
		if((s!="")&&(t!="")){
			print s,t
		}# else non-edge
	}
} 
{} # thats all

