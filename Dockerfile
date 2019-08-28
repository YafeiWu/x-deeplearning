FROM registry.cn-hangzhou.aliyuncs.com/xdl/xdl:ubuntu-cpu-mxnet1.3
ENV WORKPATH=/tdm_mock

RUN apt-get update --fix-missing && \
    apt-get install -y apt-transport-https ca-certificates && \
    apt-get install -y swig && \
    apt-get install -y git && \
    pip install sklearn

RUN git clone -b tdm.v1.2 https://github.com/YafeiWu/x-deeplearning.git /xdeeplearning && \
    cd /xdeeplearning && git submodule update --init --recursive && \
    cp -r /xdeeplearning/xdl-algorithm-solution/TDM/script/tdm_ub_att_ubuntu/ "$WORKPATH" && \
    cd /xdeeplearning/xdl-algorithm-solution/TDM/src && \
    mkdir build && cd build && \
    cmake .. && \
    make && \
    cp -r ../python/store/store/ "$WORKPATH" && \
    cp -r ../python/dist_tree/dist_tree/ "$WORKPATH" && \
    cp -r ../python/cluster/ "$WORKPATH" && \
    cp tdm/lib*.so "$WORKPATH" && \
    cp -r /xdeeplearning/xdl/test/binary/hadoop-2.8.5 "$WORKPATH"/hadoop && \
    cd $WORKPATH/hadoop && ./run.sh && \
    rm -r /xdeeplearning && \
    cd $WORKPATH

WORKDIR $WORKPATH

ENV PATH=$PATH:$WORKPATH/hadoop/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$WORKPATH