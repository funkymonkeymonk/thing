[![Travis](https://travis-ci.org/skandragon/thing.png)]()
[![CodeClimate](https://codeclimate.com/github/skandragon/thing.png)]()
[![Coveralls](https://coveralls.io/repos/skandragon/thing/badge.png)]()

# Thing: a meeting place

## Development Setup
### Initial setup
* clone this repo
* `bundle`
* Copy config/secrets.yml.sample to config/secrets.yml
* Fill out the relevant secrets

### Database Setup
* Install postgres
* Create a 'thing' role as a super user
  * `createuser -sPE thing`
* Prepare the database
  * `bundle exec rake db:setup`


### Running the tests
`bundle exec rspec`
