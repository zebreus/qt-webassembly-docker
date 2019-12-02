#Base image with emscripten
ARG EMSCRIPTEN_BASE=

FROM $EMSCRIPTEN_BASE AS qt-build-stage
MAINTAINER Lennart E.

#Qt5 source
ARG QT_DIRECTORY=

# Options to be appended to configure
ARG QT_CONFIGURE_OPTIONS=

# Options to be appended to init-repository --module-subset
ARG QT_MODULE_SUBSET=

# Additional modules to make
ARG QT_MODULES=


#Install git
#RUN apt update && apt install git

#Copy qt5 source
COPY $QT_DIRECTORY /qt5

#Change work directory
WORKDIR /qt5/

#Build qt5
#RUN ./init-repository --module-subset=qtbase,qtdeclarative,qtquickcontrols2,qtwebsockets,qtsvg,qtcharts,qtgraphicaleffects,qtxmlpatterns,$QT_MODULE_SUBSET -f
#RUN ./init-repository --module-subset=qtbase,qtdeclarative,qtquickcontrols2,qtwebsockets,qtsvg,qtcharts,qtgraphicaleffects,qtxmlpatterns,$QT_MODULE_SUBSET
RUN ./configure -xplatform wasm-emscripten -nomake examples -prefix /qtbase -c++std c++14 -opensource -confirm-license $QT_CONFIGURE_OPTIONS
#RUN make module-qtbase module-qtsvg module-qtdeclarative module-qtwebsockets module-qtxmlpatterns module-qtquickcontrols2 module-qtgraphicaleffects module-qtcharts $QT_MODULES
RUN make module-qtbase module-qtsvg module-qtdeclarative module-qtwebsockets module-qtxmlpatterns module-qtquickcontrols2 $QT_MODULES
RUN make install

#Copy files to new stage
FROM $EMSCRIPTEN_BASE
MAINTAINER Lennart E.
COPY --from=qt-build-stage /qtbase /qtbase
ENV PATH="/qtbase/bin:${PATH}"
