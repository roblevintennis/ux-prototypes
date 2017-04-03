This project requires a typical Mavenlink system in terms of bundler, rvm, etc. RVM is used to create a local gemset so we can use the latest rails et al in this directory.

# Creating a Prototype

* Add a route in `config/routes.rb` like: `get 'static_pages/your_prototype'`
* Add an _action_ in `app/controllers/static_pages_controller.rb`:
```ruby
def your_prototype 
end
```
* Add a corresponding view: `app/views/static_pages/your_prototype.html.erb` with desired markup
* Add a corresponding SCSS: `app/assets/stylesheets/prototypes/your_prototype.scss` with desired markup
* Import that SCSS in `app/assets/stylesheets/application.scss` like:
```css
@import "prototypes/your_prototype";
```
* Do similar thing for JS; add: `app/assets/javascripts/prototypes/your_prototype.coffee` (.js is also fine)
* Import it from `app/assets/javascripts/application.js`:
```javascript
// require ./prototypes/your_prototype
```
* `bundle install && bundle exec rails server` and visit `http://localhost:3000/static_pages/your_prototype`

### Learning Resources

* [Ruby on Rails Tutorial](http://www.railstutorial.org/)—a fairly comprehensive tutorial
* [rails cheatsheet](https://gist.github.com/mdang/95b4f54cadf12e7e0415)—pretty good up and running quickly if you have some dev experience
* [rails cheatsheet 2](http://www.pragtob.info/rails-beginner-cheatsheet/)
* [rails cheatsheet 3](https://teamgaslight.com/blog/ready-to-try-ruby-an-awesome-rails-cheat-sheet)
* [updating rails](http://railsapps.github.io/updating-rails.html)

### Misc Notes

* Prefix all commands with `bundle exec <COMMAND>` so we use the local version e.g. `bundle exec rails -v`
* Use `rvm gemset list` to ensure on prototypes gemset (should happen just be cd'ing in to this directory).
`rvm use ruby-2.3.1@prototypes --ruby-version --create`

### Listing Routes
`bundle exec rake routes`

### Generating controllers
`$ bundle exec rails generate controller StaticPages home help`

### Removing controllers
`$ bundle exec rails destroy  controller StaticPages home help`

### Issues

I had an issue with Puma:
"<Puma::HttpParserError: Invalid HTTP format, parsing fails. #1128" which was resolved with:

Solution: 
3 dots -> More Tools -> Clear Browsing History -> check 1. cookies and .., 2 cached images
see: https://github.com/puma/puma/issues/1128
