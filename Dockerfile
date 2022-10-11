FROM --platform=linux/amd64 ubuntu:22.04

# Install deps
ENV DEBIAN_FRONTEND noninteractive
# ENV WINEARCH win32
ENV WINEARCH win64
RUN dpkg --add-architecture i386 \
    && apt update \
    # Basic dependencies
    && apt install -y xvfb openbox x11vnc pulseaudio software-properties-common aria2 file \
    # Wine from HQ repo
    && aria2c "https://dl.winehq.org/wine-builds/winehq.key" \
    && apt-key add winehq.key \
    && yes | add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ jammy main' \
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

# TODO: https://dl.google.com/tag/s/appguid%3D%7B11111111-1111-1111-1111-111111111111%7D%26iid%3D%7111111111-1111-1111-1111-111111111111%7D%26lang%3Den%26browser%3D4%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Ddefaultbrowser/chrome/install/ChromeStandaloneSetup64.exe
# Install Chrome, see https://github.com/Hibbiki/chromium-win64/releases/latest
RUN aria2c "https://github.com/Hibbiki/chromium-win64/releases/download/v106.0.5249.91-r1036826/chrome.sync.7z" \
    && 7z x chrome.sync.7z \
    && rm -rf chrome.sync.7z

# Run Chrome
ADD run.sh /root/
ENTRYPOINT ["/root/run.sh"]
