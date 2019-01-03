FROM ruby:2.5.1

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

# PhantomJSのインストール
RUN apt-get -y install build-essential flex bison gperf ruby perl \
   libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
   libpng-dev libjpeg-dev python libx11-dev libxext-dev fonts-migmix

RUN rm -f /etc/fonts/local.conf
COPY docker/rails/phantomjs_font.conf /etc/fonts/local.conf

RUN git clone git://github.com/ariya/phantomjs.git && \
    cd phantomjs && \
    git checkout 2.1.1 && \
    git submodule init && \
    git submodule update

# chromedriverのインストール
RUN curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb

RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install -j4
ADD . /app

EXPOSE 3000
