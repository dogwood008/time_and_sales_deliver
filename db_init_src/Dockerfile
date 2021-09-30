FROM ruby:3.0

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install
CMD ruby import.rb