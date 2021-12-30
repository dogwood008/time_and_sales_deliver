FROM ruby:3.1

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

WORKDIR /app
CMD ruby app.rb