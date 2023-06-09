FROM ruby:2.7.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client nano
COPY . /myapp/Procfile
WORKDIR /myapp
COPY Gemfile* ./
RUN bundle install
COPY . .
