FROM trzeci/emscripten:sdk-tag-1.38.30-64bit
MAINTAINER Lennart E.

#Tnstall qt for webassembly
RUN apt update && apt install git
RUN git clone git://code.qt.io/qt/qt5.git
RUN cd qt5 ; git checkout 5.13
RUN cd qt5 ; ./init-repository --module-subset=qtbase,qtdeclarative,qtquickcontrols2,qtwebsockets,qtsvg,qtcharts,qtgraphicaleffects,qtxmlpatterns -f
RUN cd qt5 ; ./configure -feature-thread -xplatform wasm-emscripten -nomake examples -prefix /qtbase -c++std c++17 -opensource -confirm-license
RUN cd qt5 ; make module-qtbase module-qtsvg module-qtdeclarative module-qtwebsockets module-qtgraphicaleffects module-qtxmlpatterns module-qtquickcontrols2 module-qtcharts
RUN cd qt5 ; make install
RUN rm -rf qt5

#Add qt to path
ENV PATH="/qtbase/bin:${PATH}"
