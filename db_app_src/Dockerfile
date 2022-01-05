FROM ruby:3.1

WORKDIR /tmp
COPY Gemfile /tmp/Gemfile
COPY Gemfile.lock /tmp/Gemfile.lock
RUN bundle install

WORKDIR /app

EXPOSE 4567
CMD ["bundle", "exec", "ruby", "server.rb"]