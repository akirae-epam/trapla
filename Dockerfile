FROM ruby:2.5.1

ENV APP_ROOT /usr/src/appdir

WORKDIR $APP_ROOT

RUN apt-get update && \
    apt-get install -y nodejs \
                       mysql-client \
                       postgresql-client \
                       sqlite3 \
                       libappindicator1 \
                       fonts-liberation \
                       libappindicator3-1 \
                       libasound2 \
                       libnspr4 \
                       libnss3 \
                       libxss1 \
                       libxtst6 \
                       lsb-release \
                       xdg-utils \
                       g++ \
                       qt5-default \
                       libqt5webkit5-dev \
                       gstreamer1.0-plugins-base \
                       gstreamer1.0-tools \
                       gstreamer1.0-x \
                       --no-install-recommends && \
    apt-get install -f && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb

COPY Gemfile $APP_ROOT
COPY Gemfile.lock $APP_ROOT

RUN \
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \
  bundle config --global build.nokogiri --use-system-libraries && \
  bundle config --global jobs 4 && \
  bundle install && \
  rm -rf ~/.gem

COPY . $APP_ROOT

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
