BEGIN TRANSACTION;
CREATE TABLE comments (author TEXT, email TEXT, id INTEGER PRIMARY KEY, post_id NUMERIC);
CREATE TABLE posts (content TEXT, id INTEGER PRIMARY KEY, publishdate NUMERIC, title TEXT, visible NUMERIC);
CREATE TABLE posts_tags (id INTEGER PRIMARY KEY, post_id NUMERIC, tag_id NUMERIC);
CREATE TABLE tags (id INTEGER PRIMARY KEY, name TEXT);
CREATE TABLE authentication (id INTEGER PRIMARY KEY, login TEXT, password TEXT);
COMMIT;

-- Inserting default user
INSERT INTO authentication (login, password) values ('admin', '21232f297a57a5a743894a0e4a801fc3');

