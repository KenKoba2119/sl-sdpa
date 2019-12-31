FROM sl

RUN yum -y update && yum -y install mercurial ncurses-devel vim gcc-c++ git gcc wget make man gcc-gfortran libgfortran

ENV APP_PATH=/home
WORKDIR $APP_PATH

RUN mkdir -p $APP_PATH/sdpa
RUN cd $APP_PATH/sdpa && git clone https://github.com/xianyi/OpenBLAS.git
RUN cd $APP_PATH/sdpa/OpenBLAS && \
    make BINARY=64 CC=gcc FC=gfortran USE_OPENMP=0 NO_CBLAS=1 NO_WARMUP=1 libs netlib;

RUN cd $APP_PATH/sdpa && \
    wget https://sourceforge.net/projects/sdpa/files/sdpa/sdpa_7.3.8.tar.gz &&\
    tar xzf sdpa_7.3.8.tar.gz && \
    cd sdpa-7.3.8 && \
    export CC=gcc && \
    export CXX=g++ && \
    export FC=gfortran && \
    export CFLAGS="-funroll-all-loops" && \
    export CXXFLAGS="-funroll-all-loops" && \
    export FFLAGS="-funroll-all-loops" && \
    ./configure --prefix=$APP_PATH/sdpa --with-blas="${APP_PATH}/sdpa/OpenBLAS/libopenblas.a" --with-lapack="${APP_PATH}/sdpa/OpenBLAS/libopenblas.a"  && \
    make && \
    make install

CMD $APP_PATH/sdpa/sdpa-7.3.8/sdpa
