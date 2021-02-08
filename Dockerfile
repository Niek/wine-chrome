FROM ubuntu:rolling

# Install deps
ENV DEBIAN_FRONTEND noninteractive
ENV WINEARCH win64
RUN apt update \
    # Basic dependencies
    && apt install -y xvfb blackbox x11vnc wine-development winetricks winbind wine64 pulseaudio \
    # Update winetricks to latest git version
    && yes Y | winetricks --self-update \
    # Install necessary Windows stuff
    && winetricks -q --country=US winhttp allfonts riched20 riched30 mf \
    # Clean up
    && apt -y autoclean \
    && apt -y autoremove \
    && rm -rf /var/lib/apt/lists/*

# Install Chrome, see https://github.com/Hibbiki/chromium-win64/releases/latest
RUN aria2c "https://github.com/Hibbiki/chromium-win64/releases/download/v88.0.4324.150-r827102/chrome.sync.7z" \
    && 7z x chrome.sync.7z \
    && rm -rf chrome.sync.7z

# Run Chrome
ENTRYPOINT ["./run.sh"]