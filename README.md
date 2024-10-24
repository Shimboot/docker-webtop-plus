## WebTop Plus

features:
* Real Gnome Shell
* Flatpaks (require --privileged flag)

Original WebTop: [linuxserver/webtop](https://github.com/linuxserver/docker-webtop)

Massive thanks to the [udroid](https://udroid-rc.gitbook.io/udroid-wiki) team for the gnome fixes that allow running it without systemd.

## Supported Architectures

The architectures supported by this image are:

| Architecture | Available |
| :----: | :----: |
| x86-64 | ✅ |
| arm64 | ❌ |
| armhf | ❌ |

## Version Tags

This image provides various versions that are available via tags. Please read the descriptions carefully and exercise caution when using unstable or development tags.

| Tag | Available | Description | Notes |
| :----: | :----: | :----: |--- |
| master | ✅ | GNOME (42) Ubuntu 22.04 | Works Fine, but some apps are not themed correctly. |
| ubuntu-2404 | ✅ | GNOME (46) Ubuntu 24.04 | Works Fine. |

## Usage

### docker cli ([click here for more info](https://docs.docker.com/engine/reference/commandline/cli/))

```bash
docker run -d \
  --name=webtop \
  --security-opt seccomp=unconfined `#optional` \
  --privileged `#optional but required to run flatpaks` \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e SUBFOLDER=/ `#optional` \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/data:/config \
  --device /dev/dri:/dev/dri `#optional` \
  --shm-size="1gb" \
  --restart unless-stopped \
  ghcr.io/mollomm1/docker-webtop-plus:master
```

## Parameters

Containers are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 3000` | Web Desktop GUI |
| `-p 3001` | Web Desktop GUI HTTPS |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Etc/UTC` | specify a timezone to use, see this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List). |
| `-e SUBFOLDER=/` | Specify a subfolder to use with reverse proxies, IE `/subfolder/` |
| `-e TITLE=Webtop` | String which will be used as page/tab title in the web browser. |
| `-v /config` | abc users home directory |
| `-v /var/run/docker.sock` | Docker Socket on the system, if you want to use Docker in the container |
| `--device /dev/dri` | Add this for GL support (Linux hosts only) |
| `--shm-size=` | We set this to 1 gig to prevent modern web browsers from crashing |
| `--security-opt seccomp=unconfined` | For Docker Engine only, many modern gui apps need this to function on older hosts as syscalls are unknown to Docker. |
