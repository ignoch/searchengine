FROM ruby:2.7

RUN addgroup ignoch
RUN adduser --disabled-password --ingroup ignoch ignoch

WORKDIR /app

COPY --chown=ignoch Gemfile Gemfile.lock ./
RUN bundle install
COPY --chown=ignoch . .

USER ignoch
ENTRYPOINT ["./entrypoint.sh"]
