# wiki

Welcome to **Make Believe**, an internal wiki for a marketing company that specializes in targeting millennials on social media. 

**Feature Spec**
My ERD: 

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

**Using:**
Redcarpet - a ruby gem that displays markdown in lieu of regular text

**Runs on:**
Sinatra and Postgres