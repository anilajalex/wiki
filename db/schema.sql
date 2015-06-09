CREATE TABLE authors (
	id SERIAL PRIMARY KEY, 
	fname VARCHAR, 
	lname VARCHAR, 
	full_name VARCHAR, 
	created_at TIMESTAMP, 
	email VARCHAR NOT NULL, 
	password VARCHAR, 
	phone_number VARCHAR, 
	img VARCHAR
); 

CREATE TABLE categories (
	id SERIAL PRIMARY KEY, 
	name VARCHAR NOT NULL
); 

CREATE TABLE articles (
	id SERIAL PRIMARY KEY, 
	headline VARCHAR NOT NULL, 
	body TEXT NOT NULL, 
	created_at TIMESTAMP, 
	updated TIMESTAMP, 
	summary VARCHAR, 
	category_id INTEGER REFERENCES categories(id),
	author_id INTEGER REFERENCES authors(id)
); 

