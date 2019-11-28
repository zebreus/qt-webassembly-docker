ARG EMSCRIPTEN_BASE=
ARG QT_DIRECTORY=

FROM $EMSCRIPTEN_BASE
MAINTAINER Lennart E.

#Tnstall qt for webassembly
#RUN apt update && apt install git
COPY $QT_DIRECTORY /qt5/
WORKDIR /qt5/
#RUN git clone git://code.qt.io/qt/qt5.git
#RUN cd qt5 ; git checkout 5.13
RUN ./init-repository --module-subset=qtbase,qtdeclarative,qtquickcontrols2,qtwebsockets,qtsvg,qtcharts,qtgraphicaleffects,qtxmlpatterns -f
RUN ./configure -feature-thread -xplatform wasm-emscripten -nomake examples -prefix /qtbase -c++std c++17 -opensource -confirm-license
RUN make module-qtbase module-qtsvg module-qtdeclarative module-qtwebsockets module-qtgraphicaleffects module-qtxmlpatterns module-qtquickcontrols2 module-qtcharts
RUN make install
#RUN rm -rf qt5

#Add qt to path
ENV PATH="/qtbase/bin:${PATH}"
