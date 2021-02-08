FROM ubuntu:rolling

# Install deps
ENV DEBIAN_FRONTEND noninteractive
ENV WINEARCH win64
RUN apt update \
    && apt install -y xvfb blackbox x11vnc wine-development winetricks winbind wine64 pulseaudio \
    && yes Y | winetricks --self-update \
    && winetricks -q winhttp allfonts riched20 riched30 mf

# Install Chrome
RUN aria2c "https://github.com/Hibbiki/chromium-win64/releases/download/v88.0.4324.150-r827102/chrome.sync.7z" \
    && 7z x chrome.sync.7z \
    && rm -rf chrome.sync.7z

# Run Chrome
ENTRYPOINT ["./run.sh"]