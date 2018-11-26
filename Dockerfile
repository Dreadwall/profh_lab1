FROM ruby:2.3.4

ENV port default_port_value
RUN useradd -m  -r appuser
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /home/appuser/app
WORKDIR /home/appuser/app
COPY Gemfile /home/appuser/app/Gemfile
COPY Gemfile.lock /home/appuser/app/Gemfile.lock
RUN bundle install
COPY . /home/appuser/app
RUN rake db:migrate
RUN chown -R appuser:appuser /home/appuser/
USER appuser
ADD . .
CMD ["sh", "-c", "puma -p ${port}"]
