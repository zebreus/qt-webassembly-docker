#Base image with emscripten
ARG EMSCRIPTEN_BASE=

#Qt5 source
ARG QT_DIRECTORY=

FROM $EMSCRIPTEN_BASE AS qt-build-stage
MAINTAINER Lennart E.

#Install git
RUN apt update && apt install git

#Copy qt5 source
COPY $QT_DIRECTORY /qt5/

#Change work directory
WORKDIR /qt5/

#Build qt5
RUN ./init-repository --module-subset=qtbase,qtdeclarative,qtquickcontrols2,qtwebsockets,qtsvg,qtcharts,qtgraphicaleffects,qtxmlpatterns -f
RUN ./configure -feature-thread -xplatform wasm-emscripten -nomake examples -prefix /qtbase -c++std c++17 -opensource -confirm-license
RUN make module-qtbase module-qtsvg module-qtdeclarative module-qtwebsockets module-qtgraphicaleffects module-qtxmlpatterns module-qtquickcontrols2 module-qtcharts
RUN make install

#Copy files to new stage
FROM $EMSCRIPTEN_BASE
MAINTAINER Lennart E.
COPY --from=qt-build-stage /qtbase /qtbase
ENV PATH="/qtbase/bin:${PATH}"
