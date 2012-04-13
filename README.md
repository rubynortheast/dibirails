# RUBY ON RAILS - QA APPLICATION - DIBI 2012

## INITIAL SETUP 

* Open Terminal or Command 
line(cmd)
* Create a new skeleton application:
 
```ruby
rails new qa_demo
```

* Change Current Directory to the rails application: 

```ruby
cd qa_demo
```


* Start the server: 

```ruby
rails server
```

* open up your browser of choise and goto; http://localhost:3000. 

## QUESTION MODELS AND MIGRATION

Open Terminal or Command line(cmd) and Run the generator to create a model: 

```ruby
rails generate model Question 
```

This creates the following;

* /db/migrate/(time_stamp)_create_questions.rb : Database migration to create the questions table
* /app/models/question.rb : The file for the model code
* /test/unit/question_test.rb : A file for unit tests for Question
* /test/fixtures/question.yml : A fixtures file to assist with unit testing 

Firstly we will create the questions Migration, go to db/migrate/(time_stamp)_create_questions.rb and populate the migration with the code block below.

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


Save that migration file, goto terminal / command line(cmd), and run the following command: 

```ruby
rake db:migrate
```


If all is well this will have create the Questions table, we can now test this using rails console, while in cmd enter:

```ruby
rails console
```


Try out the following 

```ruby
Time.now - Give you the current time
q = Question.new
q.title = "Sample Question Title"
q.body = "This is the body text for the Question."
q.save
Question.all
```

shout up if you have any errors or questions.

We now we will take a look at the model open up /app/models/question.rb. We will be re-visiting the Question modal soon but for now we will put in some basic Validations : 

```ruby
validates_presence_of :title, :body, :user_name
```


Why dont you take a look at rails validations [link] to see the other options availible. 

Now we know we have a working database it time to set up the web interface.

## Controllers and Routes

Setting up the routing for questions, we will start by creating a restful resource for questions, go to config/routes.rb.
Add in:

```ruby
resources :questions
```
then run:

```ruby
rake routes
```
 in cmd and review the routing table. you should see the following;

           questions GET    /questions(.:format)                               {:action=>"index", :controller=>"questions"}
                     POST   /questions(.:format)                               {:action=>"create", :controller=>"questions"}
        new_question GET    /questions/new(.:format)                           {:action=>"new", :controller=>"questions"}
       edit_question GET    /questions/:id/edit(.:format) {:action=>"edit", :controller=>"questions"}
            question GET    /questions/:id(.:format)                           {:action=>"show", :controller=>"questions"}
                     PUT    /questions/:id(.:format)                           {:action=>"update", :controller=>"questions"}
                     DELETE /questions/:id(.:format)                           {:action=>"destroy", :controller=>"questions"}


while in cmd lets now run the following generator to create the question controller: 

```ruby
rails generate controller questions
```


This creates the following.

* app/controllers/articles_controller.rb : The controller file
* app/views/articles : The directory to contain The view templates
* test/functional/articles_controller_test.rb : Unit tests file
* app/helpers/articles_helper.rb : A helper file to assit views
* test/unit/helpers/articles_helper_test.rb : Unit test helper
* app/assets/javascripts/articles.js.coffee : A CoffeeScript file 
* app/assets/stylesheets/articles.css.scss : An SCSS stylesheet 


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
    @answer = Answer.new
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
  
end
```

We will review the above code together once everyone has it in place.

Once we are all happy we can move onto the views. 

# Layouts, Views, Partials And assets pipeline

## layouts
goto layouts/application, here you will find the application template that is used across all other view unless specified.. 

you may notice the rails asset_tags and helpers eg 

```erb
<%= stylesheet_link_tag    "application" %>
<%= javascript_include_tag "application" %>
<%= yield %>
```


Open up [link] and we will now expand on these a little. 

This is not a frontend workshop but to make it a little easier on the eye we will provide a basic stylesheet but for now all we need to add to this is a contianer div as below
```erb
 <div class= "container">
    <%= yield %>
  </div>
```


we can now move onto the views for the controller CRUD code we wrote earlier, 

## Views 
 
goto views/questions add a new file called index.html.erb open the file and enter the following,

```erb
<h1>Questions</h1>
<%= link_to "Add a Question", new_question_path, :class => "button" %>
<%= render @questions %>
```

a little strange right ? do a search to find a little more information about the link_to rails helper [link]

now goto http://localhost:3000/questions

### OH BUM

Whats is whining about ?……

We need to add a question partial, Partials are a way of packaging reusable view template code. Create new file called _question.html.erb and add in the following;

```erb
<div class= "question-container">
  <h2><%= link_to question.title, question_path(question) %></h2>
  <div class="question-block">
    <%= simple_format(question.body) %>
    <p>
      <small><%= question.user_name %> - <%= time_ago_in_words(question.created_at) %></small>
    </p>
  </div>
</div>
```

Above we utilised some awesome rails view helper method check out to see what else is avilible [http://api.rubyonrails.org/classes/ActionView/Helpers/TextHelper.html] you will notice simple_format as a option, and then http://api.rubyonrails.org/classes/ActionView/Helpers/DateHelper.html where you will spot time_ago_in_words and other options availible. Give some of the other methods a try.  

Now Re-visit http://localhost:3000/questions and Click on the "Add new question" link, 

### ERROR  

Oops, We now need to add the view for the New question page, Create a new file called new.html.erb and enter the code below;

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

take a little look at [http://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html] to find out more about the rails form helpers.

Refresh the page and click submit on the form, nothing happens, 
this is because we put validation in the model, add the following code and resubmit a empty form.

```ruby
 <%- @question.errors.full_messages.each do |msg| %>
     <li><%= msg %></li>
  <% end %>
```

you should now see the errors, Now try filling in the form and submitting.

### what ?! another error.

Now saying we need to create the show view for the questions do this by creating a show.html.erb page and entering the following: 

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

Refresh and we should now be able to create questions although they are looking a little shoddy. 

go to assets/stylesheets/application.css and enter the following; 

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

Now we have the models in place, we need to run the code to generate a controller. Direct to the answer controller and add the create method to add the following code;

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
Go back to http://localhost:3000/.. Success, you are the proud owner of a basic rails application.

If we have time we will all go over Gems if not please feel free to visit [link]. 




























