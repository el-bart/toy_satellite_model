FROM debian:11
RUN apt-get update && apt-get install -y --no-install-recommends \
    kicad \
    kicad-packages3d
RUN apt-get update && apt-get install -y --no-install-recommends \
    freecad
RUN apt-get update && apt-get install -y --no-install-recommends \
    make
COPY \
  gen_model_preview \
  generate_gerber \
  step2stl \
  /usr/local/bin/
