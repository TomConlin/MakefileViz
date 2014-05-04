# MakefileViz #

## Background ##
Started as a project to help debugging makefiles marshaling non trivial bioinformatics 
pipelines in the mid 2000's, did its job and was promptly forgotten.
Resurrected spring 2014 in a more open environment and released into the wild. 

## Goal ##

Create a graphical representation of a makefile targets and their dependencies.

![Sample MakefileViz ourput](https://raw.githubusercontent.com/TomConlin/MakefileViz/master/makefile.png)


## Requirements ##
  * errr ... practically none (_"We don't need no steenking requirements"_)
  * Pretty much any *nix based system or other OS with __make__ & __awk__ ported.
  * And any tool to view or convert GraphViz's __dot__ format files into an image.
	
## Reasons ##

  * Evidence you are doing what you intend without lapses or redundancy.
  * Figuring out what someone else (or previous self) was thinking.
  * Live Documentation 

## Process ##

  * convert the Makefile into a partially ordered set.
  * convert a partial ordered set into the dot directed graph format
  * generate an image of the dot file

 
##Usage ##

###One Way###
__include__  __introspect.makefile__ in your makefile
(or another file included by your makefile) 
adjust paths to dot and the awk scripts if necessary, then  issue  
```$ make introspect```
		
you can also invoke the **introspect_clean** target to delete the files created.


###Another Way###
Call the awk scripts yourself on the command line 
without needing to include anything in the makefile. something like:
```	
$ makefile2po.awk _yourmakefile_ | potodot.awk -v "TAG=_graphname_" | dot -Tpng -o _graphname.png_
```

This gives an easy opportunity to filter out  or modify labels before the pipe to __potodot.awk__

ex:  
```$ makefile2po.awk yourmakefile | grep -vE "PHONY|clean" | potodot.awk ...```

to keep housekeeping nodes & edges from cluttering up the graph.

Other uses include topologically sorting the makefile labels to help find critical paths
```	
$ makefile2po.awk <yourmakefile> | tsort
```

Or use __potodot.awk__ to turn _any_ reasonable list of pairs into a graph!

(where reasonable is defined by what the GraphViz dot format accepts as node labels) 


## Notes ##
Designed to take the fairly straightforward makefiles 
I tend to generate building data processing workflows
and reduce them to a simplified 'adjacency list' aka 'partially ordered set'.

Currently excluding nodes not participating in an edge but I may revisit that.

Depending on how you want to look at it
  * root nodes are displayed as rectangular boxes
  * interior nodes are ovals
  * leaf nodes are __bolded__ ovals
  * dependency arrows point to targets that required them 

###Limitations###
It is just using _pattern matching_, not full on parsing of makefiles. 
So it will not understand suffix rules, conditionals or looping etc.

It will remove all the decorations (non alphanumeric and underscore) from the labels
so your labels should not only differ by decoration if that is important.
i.e. nodes that are not the same being collapsed together.	


