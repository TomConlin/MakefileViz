#!/usr/bin/env -S awk -f 

# For including the calling directory as metadata
# does not work in shebang line, move to outside call
# -v TAG=`pwd`
# -v TAG=${PWD##*/}  -> Last dir only

# usage: potodot.awk -v TAG=`pwd` <file.po>
# convert a partial order (edge list) into a graphviz dot digraph

BEGIN {
	# I'm choosing to pass the current directory as variable TAG,
	# but whatever works, the name is not really used here
	# but helps to keep track of where something came from

	z=split(TAG, gname,"/");
	print "","digraph " gname[z] " {\n/***";
	printf("%s", "\t");
	system("date");
	print "\t",TAG  "\n***/"

	r=0;l=0;
	OFS="\t"
}
#!/.*PHONY|clean/
{ # avoid house keeping dependencies
	print "", $1 " -> " $2 " ;";
	leaf[l++]=$1;root[r++]=$2
}
END {

  i=0;
  for(r in root) {
	for(l in leaf) {
	  if (root[r] == leaf[l]) {
		node[i++] = root[r];
		delete root[r];
		delete leaf[l]
	  }
	}
  }
# there may be duplicate interior nodes so double check
  for (i in node) {
	for(r in root) if (root[r] == node[i]) delete root[r];
	for(l in leaf) if (leaf[l] == node[i]) delete leaf[l]
  }

# there may be duplicate root/leaf nodes so double check
  #asort(root); asort(leaf);
  for(r in root) {
	  if (root[r] == NULL ) delete root[r];
	  if (root[r] == root[r+1] ) delete root[r];
  }
  for(l in leaf) {
	if (leaf[l] == NULL) delete leaf[l];
	if (leaf[l] == leaf[l+1]) delete leaf[l]
  }

  # give the roots and leafs nodes different attributes
  for(r in root) if (root[r] != NULL ){print "\t" root[r] " [penwidth=4];" };
  for(l in leaf) if (leaf[l] != NULL ){print "\t" leaf[l] " [shape=box];" };

  print "}"
}
