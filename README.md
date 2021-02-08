# wine-chrome
## Docker image to run Windows Chrome in Docker using Wine
---

This repo contains the source to build the [wine-chrome](https://hub.docker.com/repository/docker/niekvdmaas/wine-chrome) Docker image. To use it, run:

```bash
docker run --rm -it -p5900:5900 niekvdmaas/wine-chrome:latest
```

Then, connect a VNC viewer to ``localhost:5900`` on your machine.