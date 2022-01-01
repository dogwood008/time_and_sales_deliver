FROM ruby:3.1

WORKDIR /tmp
COPY Gemfile /tmp/Gemfile
COPY Gemfile.lock /tmp/Gemfile.lock
RUN bundle install

WORKDIR /app
CMD ruby app.rb