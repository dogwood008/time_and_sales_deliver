FROM ruby:3.1

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install
CMD ruby import.rb