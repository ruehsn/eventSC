
Full command	Shortcut
$ rails server	  $ rails s
$ rails console	  $ rails c
$ rails generate	$ rails g
$ rails test	    $ rails t
$ bundle install	$ bundle

From <https://www.learnenough.com/ruby-on-rails-6th-edition-tutorial/static_pages> 


 rails generate scaffold Employee first_name:string last_name:string 

Scaffolding 
 rails g scaffold Student first_name:string last_name:string notes_url:string living_area_id:integer advisor_id:integer
 rails g scaffold Advisor first_name:string last_name:string email:string
 rails g scaffold LivingArea name:string description:text
 rails g scaffold Event name:string date:date survey_month:text
 rails g scaffold EventOption description:text cost:decimal event_id:integer office_holds_cash:boolean transportation_required:boolean
 rails g model StudentEventOption student:references event:references event_option:references
 rails d model StudentEventOption student:references event:references event_option:references
 rails g model SurveyMonth index show
 rails g controller Survey index show

 rails g scaffold Vehicle name:text passenger_capacity:integer working:boolean

 rails generate scaffold Dataset name:string program:string statement:string job:string step:string breadcrumb:string
 rails generate scaffold Program name:string desc:text
 rails generate scaffold Player name:string 
 rails generate scaffold Hand bid:integer bidder_id:integer color:string bidder_win:boolean game_id:integer 
 rails generate scaffold Game players:integer player1_id:integer player2_id:integer player3_id:integer player4_id:integer player5_id:integer player6_id:integer order:string team1_score:integer team2_score:integer team3_score:integer team4_score:integer team5_score:integer winning_team:integer
 
 rails generate scaffold Person name:string role:string
 rails generate scaffold Group leader:integer location:string
 rails generate scaffold Event date:date description:string 
 rails generate scaffold LineItem product:references cart:belongs_to
 
 rails destroy scaffold StudentEventOption
 rails destroy scaffold Freeform name:string description:text
 
 #many to many intersection table
 rails g model bookstore_books book:references bookstore:references
 rails g model person_event person:references event:references
 
int, integer           Fixnum
float, double          Float
decimal, numeric       BigDecimal
char, varchar, string  String
interval, date         Date
datetime, time         Time
clob, blob, text       String

rails g migration AddSearchNameToDataset search_name:string 
#This will destroy your db and then create it and then migrate your current schema:
rake db:reset
rake db:drop db:create db:migrate db:seed
rails _5.0.0.rc1_ --version  # locks the version rails uses when creating new apps
rails about   #shoud information about current rails install
bundle exec rails about  #same as above

#Naming Conventions 
Controller  Plural    rails g controller Users index show
Helper      Plural    rails g helper Users
Mailer      Singular  rails g mailer UserMailer
Migration   Plural    rails g migration AddEmailToUsers email:string
Model       Singular  rails g model User name:string
Observer    Singular  rails g observer User
Resource    Plural*   resources :users, :only => [:index, :show]
Scaffold    Singular  rails g scaffold User name:string
Table       Plural    SELECT * FROM users;
View        N/A       app/views/users/index.html.erb – comprised of controller (plural) and action (singular)

------- associations ----------------
belongs_to  1:1
has_one
has_many
has_many :through
has_one :through
has_and_belongs_to_many
class Author < ApplicationRecord
  has_many :books, dependent: :destroy
end
 
class Book < ApplicationRecord
  belongs_to :author
end
------- models
  validates :title, :description, :image_url, presence: true
  validates :title, uniqueness: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :image_url, allow_blank: true, format: { 
    with: %r{\. (gif|jpg|png) \Z}i,
    message: =must be a URL for GIF, JPG or PNG image.=}
  
      <% @steps.each{|s| } %> >
<%=s.job %>
<%}%>

rails test #runs test in Rails application
--------- test controllers
    assert_select =#columns #side a=, minimum: 4
    assert_select =#main .entry=, 3
    assert_select =h3=, =Programming Ruby 1.9=
    assert_select =.price=, /\$[,\d]+\.\d\d/
--------- Rails configuration settings:
rails dev:cache  # turns on caching in development

rails sever  
  
------ testing
rails test test/models/event_test.rb

  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---------- Git Notes --------------
http://gitref.org/
git config --global --add user.name "Nathan Ruehs"
git config --global --add user.email ruehsn@gmail.com
ssh-keygen -t ed25519 -C "ruehsn@gmail.com"


git config --global --list  #verify setup
git init
git add .
git commit -m "Depot Scaffold"
git checkout .  #roles back changes 
git commit -a -m =Validation!=  #adds and commits changs to database

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---------- ruby notes --------------------
#declaring a hash with symbols:
inst_section = {
  cello:    =string= ,
  clarinet: =woodwind= ,
  drum:     =percussion= 
}
#handling nil
a || b
The expression a || b evaluates a. If it isn ’t false or nil, then evaluation stops,
and the expression returns a. Otherwise, the statement returns b. This is
a common way of returning a default value if the first value hasn ’t been
set.

a ||= b
The assignment statement supports a set of shortcuts: a op= b is the same
as a = a op b. This works for most operators.
count += 1 # same as count = count + 1
price *= discount # price = price * discount
count ||= 0 # count = count || 0
So, count ||= 0 gives count the value 0 if count doesn ’t already have a value.

|-- app
|   |-- assets
|   |   |-- images
|   |   |-- javascripts
|   |   |   =-- application.js
|   |   =-- stylesheets
|   |       =-- application.css
|   |-- controllers
|   |   |-- application_controller.rb
|   |   =-- concerns                       Shared Controller Logic
|   |-- helpers                            Shared Viewer Logic
|   |   =-- application_helper.rb
|   |-- mailers                            
|   |-- models                         
|   |   =-- concerns                       Shared Model logic
|   =-- views                              
|       =-- layouts                        
|           =-- application.html.erb       
|-- bin
|   |-- bundle
|   |-- rails
|   |-- rake
|   |-- setup
|   =-- spring
|-- config
|   |-- application.rb
|   |-- boot.rb
|   |-- database.yml
|   |-- environment.rb
|   |-- environments
|   |   |-- development.rb
|   |   |-- production.rb
|   |   =-- test.rb
|   |-- initializers
|   |   |-- assets.rb
|   |   |-- backtrace_silencers.rb
|   |   |-- cookies_serializer.rb
|   |   |-- filter_parameter_logging.rb
|   |   |-- inflections.rb
|   |   |-- mime_types.rb
|   |   |-- session_store.rb
|   |   =-- wrap_parameters.rb
|   |-- locales
|   |   =-- en.yml
|   |-- routes.rb
|   =-- secrets.yml
|-- config.ru
|-- db
|   =-- seeds.rb
|-- Gemfile
|-- Gemfile.lock
|-- lib
|   |-- assets
|   =-- tasks
|-- log
|-- public
|   |-- 404.html
|   |-- 422.html
|   |-- 500.html
|   |-- favicon.ico
|   =-- robots.txt
|-- Rakefile
|-- README.rdoc
|-- test
|   |-- controllers
|   |-- fixtures
|   |-- helpers
|   |-- integration
|   |-- mailers
|   |-- models
|   =-- test_helper.rb
|-- tmp
|   =-- cache
|       =-- assets
=-- vendor
=-- assets
    |-- javascripts
    =-- stylesheets
