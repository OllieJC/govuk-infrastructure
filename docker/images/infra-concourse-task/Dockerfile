FROM ruby:2.7.3
RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y build-essential && apt-get clean

ENV INFRA_HOME /src
RUN mkdir $INFRA_HOME

WORKDIR $INFRA_HOME
ADD Gemfile* $INFRA_HOME/
ADD .ruby-version $INFRA_HOME/
RUN bundle install --jobs 4
ADD concourse $INFRA_HOME/concourse
ADD lib $INFRA_HOME/lib
ADD Rakefile $INFRA_HOME/

CMD /bin/bash
