This project requires a typical Mavenlink system in terms of bundler, rvm, etc. RVM is used to create a local gemset so we can use the latest rails et al in this directory.


Cheatsheet

* `bundle install && bundle exec rails server`
* Prefix all commands with `bundle exec <COMMAND>` so we use the local version e.g. `bundle exec rails -v`
* Use `rvm gemset list` to ensure on prototypes gemset (should happen just be cd'ing in to this directory).

Resources

[Ruby on Rails Tutorial](http://www.railstutorial.org/)
[updating rails](http://railsapps.github.io/updating-rails.html)

Misc Notes
`rvm use ruby-2.3.1@prototypes --ruby-version --create`

Listing Routes
`bundle exec rake routes`

Generating controller
`$ bundle exec rails generate controller StaticPages home help`
Removing controller
`$ bundle exec rails destroy  controller StaticPages home help`

Issues

I had an issue with Puma:
"<Puma::HttpParserError: Invalid HTTP format, parsing fails. #1128" which was resolved with:

Solution: 
3 dots -> More Tools -> Clear Browsing History -> check 1. cookies and .., 2 cached images
see: https://github.com/puma/puma/issues/1128