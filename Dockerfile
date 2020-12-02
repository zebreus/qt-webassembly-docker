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

# Additional modules to make
ARG CPP_STD=


#Install git
#RUN apt update && apt install git

#Copy qt5 source
COPY $QT_DIRECTORY /qt5

#Change work directory
WORKDIR /qt5/

#Build qt5
#RUN ./init-repository --module-subset=qtbase,qtdeclarative,qtquickcontrols2,qtwebsockets,qtsvg,qtcharts,qtgraphicaleffects,qtxmlpatterns,$QT_MODULE_SUBSET -f
#RUN ./init-repository --module-subset=qtbase,qtdeclarative,qtquickcontrols2,qtwebsockets,qtsvg,qtcharts,qtgraphicaleffects,qtxmlpatterns,$QT_MODULE_SUBSET
RUN ./configure -xplatform wasm-emscripten -nomake examples -prefix /qtbase -c++std $CPP_STD -opensource -confirm-license $QT_CONFIGURE_OPTIONS
#RUN make module-qtbase module-qtsvg module-qtdeclarative module-qtwebsockets module-qtxmlpatterns module-qtquickcontrols2 module-qtgraphicaleffects module-qtcharts $QT_MODULES
RUN make -j 24 -l 80 module-qtbase module-qtdeclarative $QT_MODULES
RUN make install

#Copy files to new stage
FROM $EMSCRIPTEN_BASE AS final-stage
MAINTAINER Lennart E.
COPY --from=qt-build-stage /qtbase /qtbase
ENV PATH="/qtbase/bin:${PATH}"

#Set workdir to /src to maintain compatibility with older versions of this container
WORKDIR /src/

#Create new entrypoint to use emscripten entrypoint and set path, because the
# emscripten entrypoint ignores the path
RUN mkdir -p /qt-webassembly/ ; \
    echo "#""!""/bin/sh" > /qt-webassembly/entrypoint ; \
    echo "if test -f /emsdk_portable/entrypoint ; then /emsdk_portable/entrypoint sh -c \"PATH=\\\"/qtbase/bin:\\\$PATH\\\" \$* \" ; else \$* ; fi" >> /qt-webassembly/entrypoint ; \
    chmod -R a+r /qt-webassembly ; \
    chmod a+x /qt-webassembly/entrypoint
ENTRYPOINT ["/qt-webassembly/entrypoint"]
CMD []
