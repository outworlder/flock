# Makefile for the Flock project
CSC=csc
OBJECTS=blog

.PHONY: all clean

all: $(OBJECTS)

%::%.scm
	$(CSC) $@.scm -o ../cgi-bin/$@

clean:
	rm ../cgi-bin/*

