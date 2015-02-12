# evgen Dockfile
# Build and deploy example:
# sudo docker build --no-cache -t evgen:latest . && sudo docker run -i -t -d -p 1337:1337 evgen:latest

FROM debian:latest
MAINTAINER Christer Jonassen <christer@csdnserver.com>

ENV DEBIAN_FRONTEND noninteractive

#update & get required software
RUN apt-get update && apt-get install -y \
  git \
  imagemagick \
  locate \
  python-dev \
  python-pip \
  wget \
  && rm -rf /var/lib/apt/lists/*

RUN pip install virtualenv

# add user evgen
RUN groupadd -r evgen && \
useradd -r -g users evgen && \
mkdir /home/evgen && \
chown evgen:users /home/evgen

# font install
WORKDIR /home/evgen
RUN \
mkdir fonts && \
cd fonts && \
wget \
https://github.com/chr1573r/evgen/raw/master/misc/typomoderno_bold_by_g3_drakoheart.ttf \
http://www.imagemagick.org/Usage/scripts/imagick_type_gen && \
updatedb && \
fc-cache fonts && \ 
perl imagick_type_gen > types.xml && \
mv types.xml /etc/ImageMagick/type.xml && \
rm imagick_type_gen
 
##evgen app
USER evgen
WORKDIR /home/evgen

RUN git clone http://github.com/chr1573r/evgen
WORKDIR /home/evgen/evgen
RUN chmod +x evgen.sh
RUN mkdir venv && virtualenv venv/ && . venv/bin/activate && pip install Flask
EXPOSE 1337
CMD . venv/bin/activate && python evgen.py
