FROM ruby:2.5.1

ENV APP_ROOT /usr/src/appdir

WORKDIR $APP_ROOT

RUN dpkg -l > $APP_ROOT/test

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
                       --no-install-recommends

RUN apt-get -y install build-essential flex bison gperf ruby perl \
   libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
   libpng-dev libjpeg-dev python libx11-dev libxext-dev fonts-migmix

RUN rm -f /etc/fonts/local.conf
COPY docker/phantomjs_font.conf /etc/fonts/local.conf

RUN git clone git://github.com/ariya/phantomjs.git && \
    cd phantomjs && \
    git checkout 2.1.1 && \
    git submodule init && \
    git submodule update

WORKDIR $APP_ROOT

# chromedriverのインストール
RUN curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb

COPY ./Gemfile $APP_ROOT
COPY ./Gemfile.lock $APP_ROOT

RUN \
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \
  bundle config --global build.nokogiri --use-system-libraries && \
  bundle config --global jobs 4 && \
  bundle install && \
  rm -rf ~/.gem

COPY ./ $APP_ROOT

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
