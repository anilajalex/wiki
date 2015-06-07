require_relative "db/connection"

enable :method_override

module App
	class Server < Sinatra::Base 

		configure do
	    register Sinatra::Reloader
	    set :sessions, true
    end

    def current_user
    	session[:user_id]
    end 

    def logged_in?
    	!current_user.nil?
    end 

    def markdown(text)
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :hard_wrap => true, :space_after_headers => true )
      markdown.render(text)
    end 


   	#HOMEPAGE

   	get('/') do
   		erb :index
   	end 

   	#ARTICLES

   	get('/articles') do
   		#get all articles
   		@articles = $db.exec_params("SELECT articles.*, authors.fname, authors.lname, authors.email FROM articles JOIN authors ON authors.id = articles.author_id;")
   		erb :articles
   	end 

   	get('/articles/:id') do
   		#show one article via id
   		id = params[:id]
   		query = "SELECT categories.*, articles.*, authors.* FROM categories INNER JOIN articles ON categories.id = articles.category_id INNER JOIN authors ON authors.id = articles.author_id WHERE articles.id = $1;"
   		@article = $db.exec_params(query, [id])
   		erb :article
   	end 

   	get('/new') do
   		#create a new article
   		@all_categories = $db.exec_params("SELECT * FROM categories;")
   		@all_authors = $db.exec_params("SELECT articles.*, authors.id AS auth_id, authors.full_name AS full_name,  authors.email FROM articles JOIN authors ON articles.author_id = authors.id;")
   		erb :article_new
   	end 

   	post('/new') do
	   		#add new articles 
	   	headline = params[:headline]
	   	category_id = params[:category_id].to_i
			author_id = params[:author_id].to_i
			summary = params[:summary]
			body = params[:body]
   		
   		new = $db.exec_params("INSERT INTO articles (headline, body, created_at, updated, summary, category_id, author_id) VALUES ($1, $2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, $3, $4, $5) RETURNING id;", [headline, body, summary, category_id, author_id])

   		redirect "/articles/#{new.first["id"]}"
   		erb :article_new
   	end 

   	get('/articles/:id/edit') do
   		article_id = params[:id]
      query = "SELECT categories.*, articles.id AS art_id, articles.headline AS headline, articles.summary AS summary, articles.body AS body, articles.updated AS updated, articles.created_at AS created_at, authors.full_name AS author_name FROM categories INNER JOIN articles ON articles.category_id = categories.id INNER JOIN authors ON articles.author_id = authors.id WHERE articles.id = $1"
   		@art = $db.exec_params(query, [article_id])
   		erb :article_edit
   	end 

   	patch('/articles/:id') do
   		article_id = params[:id]
      art_id = params[:id]
      headline = params[:headline]
      summary = params[:summary]
      body = params[:body]
      update = "UPDATE articles SET headline = $1, summary = $2, body = $3, updated = CURRENT_TIMESTAMP WHERE id = $4"
      $db.exec_params(update, [headline, summary, body, article_id])
      redirect "/articles/#{article_id}"
   	end 

   # 	delete('/articles/:id') do
   # 		#delete an article
   # 		id = params[:id]
   # 		query = "DELETE FROM articles WHERE id = $1"
			# @delete_article = $db.exec_params(query, [id])
   # 		redirect '/articles'
   # 	end 

   	#CATEGORIES 

   	get('/categories') do
   		#access links to all categories
   		@categories = $db.exec_params("SELECT * FROM categories;")
   		erb :categories
   	end 

   	get('/categories/:id') do
   		#access all articles associated with a specific category
   		id = params[:id]
   		query = "SELECT categories.*, articles.headline, articles.id, articles.summary FROM categories JOIN articles ON categories.id = articles.category_id WHERE categories.id = $1;"
   		@category = $db.exec_params(query, [id])
   		erb :category
   	end 

   	post('/categories') do
   		#add new category
   		name = params[:name]
   		id = $db.exec_params("INSERT INTO categories (name) VALUES ($1) RETURNING id;", [name])
   		redirect "/categories/#{id.first["id"]}"
   	end 

   	# delete('/categories/:id') do
    #   #delete a category
    #   id = params[:id]
    #   query = "DELETE FROM categories WHERE id = $1;"
    #   @delete_category = $db.exec_params(query, [id]).first
    #   redirect "/categories"
    # end 

   	#AUTHORS

   	get('/authors') do
   		#access all authors
   		@authors = $db.exec_params("SELECT * FROM authors;")
   		erb :authors
   	end 

   	get('/authors/:id') do
   		#access specific author
   		id = params[:id]
   		query = "SELECT authors.*, articles.id AS article_id, articles.headline FROM authors JOIN articles ON authors.id = articles.category_id WHERE authors.id = $1;"
   		@author = $db.exec_params(query, [id]).first
   		erb :author
   	end 

   	post('/authors') do
   		#add a new author
   		fname = params[:fname]
   		lname = params[:lname]
   		full_name = params[:full_name]
   		email = params[:email]
   		password = params[:password]
   		id = $db.exec_params("INSERT INTO authors (fname, lname, full_name, created_at, email, password) VALUES ($1, $2, $3, CURRENT_TIMESTAMP, $4, $5) RETURNING id;", [fname, lname, full_name, email, password])
   		redirect "/authors/#{id.first["id"]}"	
   	end 

   	post('/authors/login') do
   		@user = $db.exec_params("SELECT * FROM authors WHERE email = $1 AND password = $2", [params[:email],params[:password]])
   		if @user.first.nil?
   			@message = "Whoops, try again"
   			erb :index
   		else 
   			user_id = @user.first["id"]
   			session[:user_id] = user_id
   			redirect "/authors/#{user_id}"
   		end 
   	end 

   	delete('/authors/login') do
   		session[:user_id] = nil
   		redirect '/'
   	end 

   end

end 
