# RUBY ON RAILS - Q&A APPLICATION - DIBI 2012

## INITIAL SETUP 

* At the command line (Terminal, Windows cmd)
* Create a new skeleton application:
 
```shell
$ rails new dibi
```

* Change your current directory to the Rails application: 

```shell
$ cd dibi
```

* Start the server: 

```shell
$ rails server
```

* open up your browser of choice and browse to: http://localhost:3000.

## QUESTION MODEL AND MIGRATION

Run the generator to create a model:

```shell
$ rails generate model Question title:string body:text user_name:string
```

This creates the following files:

* `/db/migrate/(time_stamp)_create_questions.rb` Database migration to create the `questions` table
* `/app/models/question.rb` : The `Question` model
* `/test/unit/question_test.rb` A file for unit testing `Question` in this file
* `/test/fixtures/question.yml` A fixtures file to assist with unit testing

Let’s have a look at the questions Migration, start you editer / IDE and go to `db/migrate/<time_stamp>_create_questions.rb` and you’ll notice what the generator has done for us:

```ruby
def change
  create_table :questions do |t|
    t.string :title
    t.text :body
    t.string :user_name
    t.timestamps
  end
end
```

Save that migration file and run the following command:

```shell
$ rake db:migrate
```

If all is well this will have created the `questions` table. We can now test this using rails console:

```shell
$ rails console
```

Try out the following 

```ruby
>> Time.now  # Gives you the current time
>> q = Question.new
>> q.title = "Why is Rails so good?"
>> q.body = "Has it got anything to do with Ruby?"
>> q.save
>> Question.all
>> exit # Exits the console 
```

shout up if you have any errors or questions.

We now we will take a look at the model open up `/app/models/question.rb`. We will be re-visiting the `Question` model soon but for now we will put in some basic validations: 

```ruby
class Question
  validates_presence_of :title, :body, :user_name
end
```

Why dont you take a look at [Rails Validations](http://guides.rubyonrails.org/active_record_validations_callbacks.html) to see the other options available. 

Now we know we have a working database it’s time to set up the web interface.

## Controllers and Routes

We need to link up some routes to a controller, so we will start by creating a RESTful resource for questions, go to `config/routes.rb` and add this line:

```ruby
resources :questions
```
then run:

```shell
$ rake routes
```

and review the routing table. you should see the following;

```shell
    questions GET    /questions(.:format)          {:action=>"index", :controller=>"questions"}
              POST   /questions(.:format)          {:action=>"create", :controller=>"questions"}
 new_question GET    /questions/new(.:format)      {:action=>"new", :controller=>"questions"}
edit_question GET    /questions/:id/edit(.:format) {:action=>"edit", :controller=>"questions"}
     question GET    /questions/:id(.:format)      {:action=>"show", :controller=>"questions"}
              PUT    /questions/:id(.:format)      {:action=>"update", :controller=>"questions"}
              DELETE /questions/:id(.:format)      {:action=>"destroy", :controller=>"questions"}
```

now run the following generator to create the questions controller: 

```shell
$ rails generate controller questions
```

This creates the following.

* `app/controllers/questions_controller.rb` The controller file.
* `app/views/questions` The directory to contain the view templates.
* `test/functional/questions_controller_test.rb` Funcitonal tests file.
* `app/helpers/questions_helper.rb` A helper file to assist views.
* `test/unit/helpers/questions_helper_test.rb` Helper test file.
* `app/assets/javascripts/questions.js.coffee` A CoffeeScript file
* `app/assets/stylesheets/questions.css.scss` An SCSS stylesheet

now its time to work in the controller, we will create the CRUD methods in the controller as below.

```ruby
class QuestionsController < ApplicationController
  respond_to :html

  def index
    @questions = Question.all
    respond_with(@questions)
  end

  def show
    @question = Question.find(params[:id])
    respond_with(@questions)
  end
  
  def new
    @question = Question.new
    respond_with(@question)
  end 
  
  def create
    @question = Question.create(params[:question])
    respond_with(@question)
  end 
  
  def edit  
    @question = Question.find(params[:id])  
    respond_with(@question)  
  end  
  
  def update  
    @question = Question.find(params[:id])  
    if @question.update_attributes(params[:question])  
      flash[:notice] = "Successfully updated question."  
    end  
    respond_with(@question)  
  end  
    
  def destroy  
    @question = Question.find(params[:id])  
    @question.destroy  
    flash[:notice] = "Successfully destroyed question."  
    respond_with(@question)  
  end
end
```

Once we are all happy we can move onto the views.

# Layouts, Views, Partials (& The Asset Pipeline)

## Layouts
Go to `app/views/layouts/application.html.erb`, here you will find the default application layout.

You may notice the Rails asset_tags and helpers e.g.,

```erb
<%= stylesheet_link_tag    "application" %>
<%= javascript_include_tag "application" %>
<%= yield %>
```

This is not a frontend workshop but to make it a little easier on the eye we will provide a basic stylesheet. For now the only change we need to make to the file is to add a `div` with a CSS `class` of `container`.

```erb
 <div class="container">
    <%= yield %>
  </div>
```

we can now move onto the views for the controller CRUD code we wrote earlier, 

## Views 
 
Go to app/views/questions/ add a new file called `index.html.erb`, open the file and enter the following:

```erb
<h1>Questions</h1>
<%= link_to "Add a Question", new_question_path, :class => "button" %>
<%= render @questions %>
```

now visit http://localhost:3000/questions

### Partials

Oh bum! What is the application whining about?

We need to add a question partial; Partials are a way of packaging reusable view template code. Create new file in `app/views/questions/` called `_question.html.erb` and add in the following code:

```erb
<div class="question-container">
  <h2><%= link_to question.title, question_path(question) %></h2>
  <div class="question-block">
    <%= simple_format(question.body) %>
    <p>
      <small><%= question.user_name %> - <%= time_ago_in_words(question.created_at) %></small>
    </p>
  </div>
</div>
```

Above we used some awesome Rails View Helper methods. Check out the documentation to get more information and to see what else is available [http://api.rubyonrails.org/classes/ActionView/Helpers/TextHelper.html] you will notice `simple_format` as an option, and then [http://api.rubyonrails.org/classes/ActionView/Helpers/DateHelper.html] where you will spot `time_ago_in_words` and other options available. Give some of the other methods a try.  

Now re-visit http://localhost:3000/questions and click on the "Add new question" link, 

### Exceptions and Error Messages

Oops, We now need to add the view for the New question page, Create a new file called new.html.erb and enter the code below:

```erb
<h1>New Question</h1>
<%= form_for @question do |f| %>
  <ul>
    <li><%= f.text_field :title, {:placeholder => 'Please add a title...'} %></li>
    <li><%= f.text_area :body, {:placeholder => 'Please add your question...'} %></li>
    <li><%= f.text_field :user_name, {:placeholder => 'Please add your name...'} %><li>
    <li><%= f.submit %></li>
  </ul>
<% end %>
<%= link_to "Back", questions_path, :class => "button" %>
```

take a little look at [http://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html] to find out more about the Rails Form Helpers.

Refresh the page and click submit on the form, nothing happens; this is because we put validation in the model, add the following code to the new.html.erb within the form and re-submit.

```ruby
 <%- @question.errors.full_messages.each do |msg| %>
     <li><%= msg %></li>
  <% end %>
```
 new.html.erb should now look something like this;
 
```erb
<h1>New Question</h1>
<%= form_for @question do |f| %>
  <%- @question.errors.full_messages.each do |msg| %>
     <li><%= msg %></li>
  <% end %>
  <ul>
    <li><%= f.text_field :title, {:placeholder => 'Please add a title...'} %></li>
    <li><%= f.text_area :body, {:placeholder => 'Please add your question...'} %></li>
    <li><%= f.text_field :user_name, {:placeholder => 'Please add your name...'} %><li>
    <li><%= f.submit %></li>
  </ul>
<% end %>
<%= link_to "Back", questions_path, :class => "button" %>
```

you should now see the error messages, Now try filling in the form and submitting.

### what ?! another error.

Read the error massage and try and figure out what the issue is, shout up if you get stuck

```erb
<div class="question-container">
  <h1><%= @question.title %></h1>
  <div class="question-block">
    <%= simple_format(@question.body) %>
    <p>
      <small><%= @question.user_name %> - <%= time_ago_in_words(@question.created_at) %></small>
    </p>
  </div>
</div>

<%= link_to "Back", questions_path, :class => "button" %>
```

Refresh and we should now be able to create questions, but we are not finished there, as we are a friendly trusting bunch we can also add in the edit and delete funcionallity for the question.   

Create another view called edit.html.erb all we need on this is the same form we used on the new.html.erb. as we are using the same code in 2 places we can make it into a partial.

Create a new file and call it _form.html.erb and add the following code (we used above)

```erb
<%= form_for @question do |f| %>
  <%- @question.errors.full_messages.each do |msg| %>
     <li><%= msg %></li>
  <% end %>
  <ul>
    <li><%= f.text_field :title, {:placeholder => 'Please add a title...'} %></li>
    <li><%= f.text_area :body, {:placeholder => 'Please add your question...'} %></li>
    <li><%= f.text_field :user_name, {:placeholder => 'Please add your name...'} %><li>
    <li><%= f.submit %></li>
  </ul>
<% end %>
```

now create the edit.html.erb file and add the following code;

```erb
<h1>Edit Question</h1>
<%= render :partial => 'form'%>
<%= link_to "Back", questions_path, :class => "button" %>
```

and replace the form on new.html.erb with the _form.html.erb partial, the view should now look like below;

```erb
<h1>New Question</h1>
<%= render :partial => 'form' %>

<%= link_to "Back", questions_path, :class => "button" %>
```

Now if we ever need to change the form we only need to do it in one place and we also clean up the view files, win win.

To add the delete is short and sweet, all we need is to add in a link to hit the controller method and delete the question. We may as well also add the link to edit the question at the same time, both links are added to the _question.html.erb as below;

```erb
<div class= "question-container">
  <h2><%= link_to question.title, question_path(question) %></h2>
  <div class="question-block">
    <%= simple_format(question.body) %>
    <p>
      <small><%= question.user_name %> - <%= time_ago_in_words(question.created_at) %></small>
    </p>
  </div>
 
  <%= link_to "Delete", question, :confirm => 'Are you sure?', :method => :delete %>
  -
  <%= link_to "Edit", edit_question_path(question) %>
</div>
```


This now gives us full CRUD interface although it is looking a little shoddy, 

Its not going to win any style awards but you can add in the pre-made css, go to `app/assets/stylesheets/application.css` and copy in the following; 


```css


/* -- RESET -------------------------------------------------- */

html,body,div,span,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,abbr,address,cite,code,del,dfn,em,img,ins,kbd,q,samp,small,strong,sub,sup,var,b,i,dl,dt,dd,ol,ul,li,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td,article,aside,canvas,details,figcaption,figure,footer,header,hgroup,menu,nav,section,summary,time,mark,audio,video{margin:0;padding:0;border:0;outline:0;font-size:100%;vertical-align:baseline;background:transparent}body{line-height:1}article,aside,details,figcaption,figure,footer,header,hgroup,menu,nav,section{display:block}nav ul, ul{list-style:none}blockquote,q{quotes:none}blockquote:before,blockquote:after,q:before,q:after{content:'';content:none}a{margin:0;padding:0;font-size:100%;vertical-align:baseline;background:transparent}ins{background-color:#ff9;color:#000;text-decoration:none}mark{background-color:#ff9;color:#000;font-style:italic;font-weight:bold}del{text-decoration:line-through}abbr[title],dfn[title]{border-bottom:1px dotted;cursor:help}table{border-collapse:collapse;border-spacing:0}hr{display:block;height:1px;border:0;border-top:1px solid #ccc;margin:1em 0;padding:0}input,select{vertical-align:middle}

/* -- END RESET --------------------------------------------- */

body{
  font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
	font-size:16px;
	}

small{
	font-size:smaller;
	}

h1{
	font-size:50px;
	margin-bottom:20px;
	color:#375265;
	}

h2{
	font-size:35px;
	margin-bottom:20px;
	color:#375265;
	}

h3{
	font-size:18px;
	margin-bottom:20px;
	
	}

p{
	margin:10px 0;
	}

a{
	text-decoration:none;
	color:#FF9900;
	}

a:hover{
	text-decoration:none;
	color:#375265;
	}
	
li{
	margin:10px 0;
		
	}

.container{
	width:800px;
	margin:10px auto;
	}

.button{
  cursor: pointer;
  display:block;
  padding:10px;
  margin:20px 0;
  text-align:center;
  line-height:1;
	box-shadow : 1px, 1px, 2px, 0px, rgba(0, 0, 0, 0.2);
	color: #333;
	border: 1px solid #666;
	font-size:18px;
	background:#F9F9F9;
	}

.button:hover{
  text-decoration: none;
  opacity: 0.8;
  }
  
.question-container{
	margin:10px 0;
	padding:10px 0;
	border-bottom: 1px solid #CCC;
	}

.answers-container{
	margin:10px 0;
	padding:10px 0;
	border-top: 1px solid #CCC;
	}

.question-container .question-block{
	margin:10px 0;
	border-left:8px solid #0099FF;
	padding-left:10px;
	display:block;
	}

.answers-container .answers-block{
	margin:20px 0;
	border-left:5px solid #FF9900;
	padding-left:10px;
	}

/* -- FORMS -----------------------------------------------------------------*/

input[type="text"]{
  padding-top: 10px;
  padding-bottom: 10px;
  padding-left:10px;
  border: solid 1px #ccc;
  margin-bottom: 5px;
  outline:0;
  color:#666;
	}

textarea{
  height:100px;
  width:95%;
  border: solid 1px #ccc;
  padding-top: 10px;
	padding-bottom: 10px;
	padding-left:10px;
  }

/* -- END FORMS -------------------------------------------------------------*/
```

## Add in Answers for the question

Thats better, but what are questions without Answers, as with questions lets run a generator for a Answer Model. Note, Answers are related to Questions as one question can have many answers.

## Migration 

```ruby
  def change
    create_table :answers do |t|
      t.text :body
      t.string :user_name
      t.references :question
      t.timestamps
    end
  end
```

you will see odd addition that wasnt in the Question migration,  t.references :question adds in the referance to question. 

Remember to Run the migration task
 
## Models, Relationships and ORM 

Now open up the Question model, and add: 

```ruby
has_many :answers
```

now open the Answer model and add: 

```ruby
belongs_to :question
```

While we are in the Answers model we may as well add the validation code as before: 

```ruby
  validates_presence_of :body, :user_name
```
## Controllers and Routes

Now we have the models in place, we need to run the code to generate a controller. Then direct to the answer controller and add the create method to add the following code;

```ruby
class AnswersController < ApplicationController
  respond_to :html
  
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(params[:answer])
    if @answer.save
      flash[:notice] =  "Your answer has been added successfully"
    else
      flash[:notice] =  "There is an issue with the answer have you provided"
    end 
    respond_with(@question)
  end
end
```
The create method differs to the previous as its using a flash message to notify the success of the form submittion. 
 
## routes

We need to add a nested resource to the routes so that we can Add answers to questions, shown below; 

```ruby
  resources :questions do 
    resources :answers
  end
```

## Views

We now need to add two partials one form to submit the answers and another partial to display the answer..

add two files to the views/answers/ folder; 

_form.html.erb

```erb
<p class="flash"><%= flash[:notice] %></p>

<%= form_for(:answer, :url => question_answers_path(question)) do |f| %>
  <ul>
    <li><%= f.text_area :body, {:placeholder => 'Please add your response...'} %></li>
    <li><%= f.text_field :user_name, {:placeholder => 'Please add your name...'} %></li>
    <li><%= f.submit "Respond"%></li>
  </ul>
<% end %>
```

_answer.html.erb

```erb
<div class="answers-block">
  <%= simple_format(answer.body) %>
  <p>
    <small><%= answer.user_name %> - <%= time_ago_in_words(answer.created_at) %></small>
  </p>
</div>
```

All we need to do now is include the above in the questions show page, this is shown below ;

```erb
<h3>Add your response...</h3>

<%= render :partial => "answers/form", :locals => { :question => @question} %>

<div class="answers-container">
  <h2>Answers</h2>
  <%= render :partial => 'answers/answer', :collection => @question.answers %>
</div>
```

questions/show.html.erb should now be as below;

```erb

<div class="question-container">
  <h1><%= @question.title %></h1>
  <div class="question-block">
    <%= simple_format(@question.body) %>
    <p>
      <small><%= @question.user_name %> - <%= time_ago_in_words(@question.created_at) %></small>
    </p>
  </div>
</div>

<h3>Add your response...</h3>

<%= render :partial => "answers/form", :locals => { :question => @question} %>

<div class="answers-container">
  <h2>Answers</h2>
  <%= render :partial => 'answers/answer', :collection => @question.answers %>
</div>

<%= link_to "Back", questions_path, :class => "button" %>

```
Go back to http://localhost:3000/.. Success, you are the proud owner of a basic rails application. Oh wait thats not the application, thats the default hello Rails page, we need to specify a root this is done as below; 

Open up the routes.rb

```erb
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'questions#index'
```

Then, as it says in the comments goto the public/ folder and delete index.html.

Now, Go back to http://localhost:3000/.. Success !

If we have time we will all go over Gems if not please feel free to visit [link]. 




























