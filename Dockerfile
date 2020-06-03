FROM ubuntu:bionic
RUN apt-get clean && apt-get update
RUN apt-get install -yq build-essential
RUN mkdir -p /home/user/gdmlutils/geant4
RUN mkdir -p /home/user/gdmlutils/stl-2-geant4
RUN mkdir -p /home/user/gdmlutils/gdmlviewer
RUN apt-get install -yq wget
WORKDIR /home/user/gdmlutils
RUN wget http://cern.ch/geant4-data/releases/geant4.10.06.p02.tar.gz
RUN apt-get install -yq cmake
RUN apt-get install -yq libxerces-c-dev
RUN apt-get install -yq qt5-default
RUN apt-get install -yq libboost-all-dev
RUN mkdir -p /home/user/gdmlutils/geant4/src
RUN mkdir -p /home/user/gdmlutils/geant4/build
RUN mkdir -p /home/user/gdmlutils/geant4/install
WORKDIR /home/user/gdmlutils/geant4/src
RUN tar -zvxf /home/user/gdmlutils/geant4.10.06.p02.tar.gz
RUN mkdir -p /home/user/gdmlutils/data
WORKDIR /home/user/gdmlutils/geant4/build
RUN apt-get install -yq libxmu-dev
RUN cmake -DCMAKE_INSTALL_PREFIX=/home/user/gdmlutils/geant4/install -DGEANT4_USE_OPENGL_X11=ON -DGEANT4_INSTALL_DATA=ON -DGEANT4_USE_GDML=ON -DGEANT4_USE_QT=ON /home/user/gdmlutils/geant4/src/geant4.10.06.p02
RUN make -j4
RUN make install
WORKDIR /home/user/gdmlutils/geant4/install/bin
RUN ["/bin/bash", "-c", "source geant4.sh"]
RUN rm -rf /home/user/gdmlutils/geant4.10.06.p02.tar.gz
RUN rm -rf /home/user/gdmlutils/geant4/src
RUN rm -rf /home/user/gdmlutils/geant4/build
RUN mkdir -p /home/user/gdmlutils/gdmlviewer/src
WORKDIR /home/user/gdmlutils/gdmlviewer/src
RUN apt-get install -yq git
RUN git clone https://github.com/JeffersonLab/gdmlview.git
WORKDIR /home/user/gdmlutils/gdmlviewer/build
ENV CMAKE_PREFIX_PATH="${CMAKE_PREFIX_PATH}:/home/user/gdmlutils/geant4/install/lib/Geant4-10.6.2"
RUN cmake /home/user/gdmlutils/gdmlviewer/src/gdmlview
RUN make -j4
RUN make install
WORKDIR /home/user/gdmlutils/stl-2-geant4
RUN git clone https://github.com/tihonav/cad-to-geant4-converter.git
WORKDIR /home/user/gdmlutils/gdmlviewer/build
COPY entry.sh /usr/local/bin/entry.sh
RUN chmod +x /usr/local/bin/entry.sh
WORKDIR /home/user/gdmlutils/data
ENTRYPOINT entry.sh
