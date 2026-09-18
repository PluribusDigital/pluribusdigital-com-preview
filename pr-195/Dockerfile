FROM ruby:3.1.7-slim-bookworm

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libyaml-dev \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/jekyll

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 4000
EXPOSE 35729

CMD ["bundle", "exec", "ruby", "docker/jekyll_serve.rb"]
