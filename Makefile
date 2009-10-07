# Makefile for the Flock project

all: paleolithic post comment_posted

paleolithic: paleolithic.scm
	csc paleolithic.scm -o cgi-bin/paleolithic

post: post.scm
	csc post.scm -o cgi-bin/post

comment_posted: comment_posted.scm
	csc comment_posted.scm -o cgi-bin/comment_posted
