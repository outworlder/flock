# Makefile for the Flock project

all: paleolithic

flock:
	csc main.scm -o flock

paleolithic: paleolithic.scm
	csc paleolithic.scm -o cgi-bin/paleolithic
