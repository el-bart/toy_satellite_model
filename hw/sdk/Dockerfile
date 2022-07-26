FROM debian:11
RUN apt-get update && apt-get install -y --no-install-recommends \
    kicad \
    kicad-packages3d
RUN apt-get update && apt-get install -y --no-install-recommends \
    freecad
RUN apt-get update && apt-get install -y --no-install-recommends \
    make

COPY \
  generate_gerber \
  generate_stl \
  step2stl \
  /usr/local/bin/

ENV HOME=/tmp/
RUN mkdir -p /tmp/.config/
COPY kicad /tmp/.config/kicad
