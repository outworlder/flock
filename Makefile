# Makefile for the Flock project

all: paleolithic post

paleolithic: paleolithic.scm
	csc paleolithic.scm -o cgi-bin/paleolithic
	chmod +x cgi-bin/paleolithic

post: post.scm
	csc post.scm -o cgi-bin/post
	chmod +x cgi-bin/