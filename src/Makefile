# Makefile for the Flock project
CSC=csc
OBJECTS=blog
MODULES=flock
FLAGS=

.PHONY: all clean

all: modules $(OBJECTS) 

modules:
	$(CSC) -s flock.scm -j flock -o ../cgi-bin/flock.so  $(FLAGS)
	$(CSC) -s flock.import.scm -o ../cgi-bin/flock.import.so $(FLAGS)

%::%.scm
	$(CSC) $@.scm -o ../cgi-bin/$@ $(FLAGS)

clean:
	rm ../cgi-bin/*

