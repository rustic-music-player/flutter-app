FROM adamantium/flutter:latest

RUN cd /opt/flutter && \
    git reset --hard && \
    git pull && \
    flutter doctor -v && \
    yes | flutter doctor --android-licenses > /dev/null

RUN chmod -R 777 /opt/flutter && \
    chmod -R 777 /opt/android-sdk
