FROM ubuntu:20.10

# Install deps
ENV DEBIAN_FRONTEND noninteractive
# ENV WINEARCH win32
ENV WINEARCH win64
RUN dpkg --add-architecture i386 \
    && apt update \
    # Basic dependencies
    && apt install -y xvfb blackbox x11vnc pulseaudio software-properties-common aria2 \
    # Wine from HQ repo
    && aria2c "https://dl.winehq.org/wine-builds/winehq.key" \
    && apt-key add winehq.key \
    && yes | add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ groovy main' \
    && apt update \
    && apt install -y --install-recommends winehq-staging winetricks winbind wine64 wine32 \
    # Update winetricks to latest git version
    && yes Y | winetricks --self-update \
    # Install necessary Windows stuff
    && winetricks -q --country=US winhttp allfonts riched20 riched30 mf \
    # Clean up
    && apt -y autoclean \
    && apt -y autoremove \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# Install Chrome, see https://github.com/Hibbiki/chromium-win64/releases/latest
RUN aria2c "https://github.com/Hibbiki/chromium-win64/releases/download/v88.0.4324.150-r827102/chrome.sync.7z" \
    && 7z x chrome.sync.7z \
    && rm -rf chrome.sync.7z

# Run Chrome
ADD run.sh /root/
ENTRYPOINT ["/root/run.sh"]