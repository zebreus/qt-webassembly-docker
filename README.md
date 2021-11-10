qt-webassembly-docker
=====================

A container for building Qt applications for the web platform using [Qt for WebAssembly](https://doc.qt.io/qt-5/wasm.html).

This container is based on the official emscripten docker image [emscripten/emsdk](https://github.com/emscripten-core/emsdk).

The [concourse pipeline](https://concourse.madmanfred.com/teams/main/pipelines/qt-webassembly) is constantly building images and putting them on dockerhub [madmanfred/qt-webassembly](https://hub.docker.com/repository/docker/madmanfred/qt-webassembly).

Please create issues related to this image on the associated [GitHub project](https://github.com/Zebreus/qt-webassembly-docker).

## Usage ##
### bash ###
```Shell
docker run --rm -v $(pwd):/src/ -u $(id -u):$(id -g) madmanfred/qt-webassembly qmake
docker run --rm -v $(pwd):/src/ -u $(id -u):$(id -g) madmanfred/qt-webassembly make
```
### powershell ###
```PowerShell
docker run --rm -v $(PWD):/src/ madmanfred/qt-webassembly qmake
docker run --rm -v $(PWD):/src/ madmanfred/qt-webassembly make
```

## Build status ##
[<p align="center"><img src="https://images.madmanfred.com/qt-webassembly-status.jpg"></p>](https://concourse.einhorn.jetzt/teams/main/pipelines/qt-webassembly)

## Improving build time
Here are some tips to speed up your builds for Qt for WebAssembly:

- You can add this to use a local directory as cache:
  ```Shell
  -v ~/.emscripten_cache:/emsdk_portable/.data/cache
  ```

- If you use some of the [emscripten ported libraries](https://github.com/emscripten-ports), you can reduce the build time by   a few seconds by caching `/emsdk_portable/.data/ports`.

- You can also increase the compilation speed a bit by using a parallel build (`make -j`).

- If you disable all optimizations you can reduce your build time significantly. Just add this to your project file:
  ```QMake
  QMAKE_CXXFLAGS_RELEASE -= -O3
  QMAKE_CXXFLAGS_RELEASE *= -O0
  
  QMAKE_LFLAGS_RELEASE -= -O3
  QMAKE_LFLAGS_RELEASE *= -O0
  ```

