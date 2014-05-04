#-----------------  Auto Documentation  -------------------------
# Tom Conlin, first in the mid 2000's on solaris machines and  
# then in the mid teens on CentOS

# if your GraphViz dot is somewhere else then change the next line
DOT = /usr/bin/dot  # CHANGEME

# expects makefiletopo.awk and potodot.awk to be findable
# not finding a way to get the path of an included file. so ...
# where the awk files live is.  

VPATH = ~/bin/  # CHANGEME

.PHONY : introspect

# first in list -> makfile invoked
SELF = $(word 1 ,$(MAKEFILE_LIST))

$(SELF).partial_order: $(SELF) makefile2po.awk
	@ makefile2po.awk $(SELF) > $@
	@ # making unique & rearanging with sort -u 
	@ # could hide parallel edges. so not doing.

$(SELF).dot: potodot.awk $(SELF).partial_order
	@  potodot.awk -v "TAG=`pwd`" $(SELF).partial_order > $@

$(SELF).png: $(SELF).dot $(DOT)
	@ $(DOT) -Tpng $< -o $@	

introspect:	$(SELF).png
	@ # echo -e "\tUtility targets  (.PHONYs?)"
	@ # echo "--------------------------------------------"
	@ # grep -E '^[^\011:]+:[ \011]*$$' $(SELF)

introspect_clean:
	rm -f $(SELF).partial_order $(SELF).dot $(SELF).png
