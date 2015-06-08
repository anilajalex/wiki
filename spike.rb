#MISC CODE

<form action ="/categories/<%= @delete_category[id] %>" method="POST">
    <input type="hidden" name="_method" value="DELETE">
    <input type="submit" value="Delete Category">
</form>


<form action ="/articles/<%= @delete_article['id'] %>" method="POST">
    <input type="hidden" name="_method" value="DELETE">
    <input type="submit" value="Delete Article">
</form>

    patch('/authors/:id') do
      #update categories
      #display updated timestamp
    end 

    delete('/authors/:id') do
      #delete an author
    end 

select articles.*, categories.* from articles join categories on articles.category_id = categories.id;

get('/categories/:id') do
   		#access all articles associated with a specific category
   		@category = $db.exec_params("SELECT * FROM category WHERE id = $1;", [params[:id]]).first
   		erb :category
   	end 

	@category = $db.exec_params("SELECT categories.*, articles.headline, articles.id FROM categories JOIN articles ON articles.category_id = categories.id  WHERE id = $1;", [params[:id]]).first

	<dl>
	<dt>Category:</dt>
	<a href="/article/<%= @category['id'] %>"<dd><%= @category['name'] %><dd>
</dl></a>

<article>
		<h1><%= article['headline'] %></h1>
		<a href="mailto:<%=article['email']%>?Subject=Hello" target="_top"><%= article['full_name'] %></a>
		<br>
		Created: <%= article['created_at'] %> Updated: <%= article['updated'] %>
		<br>
		Summary: <%= article['summary'] %>
		<br>
		Body: <%= article['body'] %>
	</article>

	get('/articles/:id') do
   		#show one article via id
   		id = params[:id]
   		query = "SELECT articles.*, authors.* FROM articles JOIN authors ON articles.author_id = authors.id WHERE articles.id = $1;"
   		@article = $db.exec_params(query, [id]); 
   		erb :article
   	end 

   	#get edit CODE
   	id = params[:id]
   		query = "SELECT articles.*, authors.* FROM articles JOIN authors ON articles.author_id = authors.id WHERE articles.id = $1;"
   		@article = $db.exec_params(query, [id]); 




  # more edit code 
  select categories.id as cat_id, categories.name as cat_name, articles.*, authors.* from categories inner join articles on categories.id = articles.id inner join authors on authors.id = articles.author_id;