
# MakefileViz #

## Background ##
Started as a project to help debugging makefiles marshaling non trivial bioinformatics 
pipelines in the mid 2000's, did its job and was promptly forgotten.
Resurrected spring 2014 in a more open environment and released into the wild. 

## Goal ##

Create a graphical representation of a makefile targets and their dependencies.


## Requirements ##
  * errr ... practically none :^)
  * Pretty much any *nix based system or other OS with __make__ & __awk__ ported.
  * And any tool to view or convert GraphViz's __dot__ format files into an image.
	
## Reasons ##

  * Evidence you are doing what you intend without lapses or redundancy.
  * Figuring out what someone else (or previous self) was thinking.
  * Live Documentation 

## Process ##

  * convert the Makefile into a partial ordered set.
  * convert a partial ordered set into the dot directed graph format
  * generate an image of the dot file

 
##Usage ##

###First Way###
__include__ the __introspect.makefile__ in your makefile
(or another file included by your makefile)
	
then  issue  
```make introspect```
		
you can also invoke the **introspect_clean** target to delete the files created.


###Second Way###
Another way to is to just call the scripts yourself on the command line 
without needing to include anything. something like:
```	
makefile2po.awk <yourmakefile> | potodot.awk -v TAG=<graphname> | dot -Tpng -o <grapname.png>
```

This gives an easy opportunity to filter out  or modify labels before the pipe to potodot.awk
ex.  ```makefile2po.awk <yourmakefile> | grep -vE "PHONY|clean" | potodot.awk ...```
to omit housekeeping labels.

Another use could be for topologically sorting the makefile labels to help find critical paths
```	
makefile2po.awk <yourmakefile> | tsort
```

Or use __ potodot.awk__ to turn _any_ reasonable list of pairs into a graph!
(where reasonable is defined by what the GraphViz dot format accepts) 


## Notes ##
Designed to take the fairly straightforward makefiles 
I tend to generate building data processing workflows
and reduce them to a simplified 'edge list' or 'partially ordered set'. 

###Limitation###
It is just using _pattern matching_, not full on parsing of makefiles. 
So it will not understand suffix rules, conditionals or looping etc.

It will remove all the decorations (non alphanumeric and underscore) from the labels
so your labels should not only differ by decoration if that is important.
i.e. nodes that are not the same being collapsed together	


