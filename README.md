# Wrapper for SimplexMQ 

[<img src="icon.png" alt="SimpleX logo" width="10%"/>](https://simplex.chat/)

SimpleX is a highly secure and sovereign messenger. 

Currently the packaging process is somewhat involved. I was able to get support for ARM builds [merged](https://github.com/simplex-chat/simplexmq/pull/679), however as of 2023-06-07, SimpleX have an [open issue](https://github.com/simplex-chat/simplexmq/issues/740) for  not publishing ARM builds to Docker Hub. All of this is further complicated by the fact that Haskell cross compilation of SimpleXMQ is fairly broken - even using 30GB of RAM on an M1 Pro was not enough resources.

This wrapper therefore uses a multi-architecture Docker image hosted on my personal Docker Hub. This multi-architecture image can be created as follows:

- Check out the SimpleXMQ repo on an ARM machine  - `git@github.com:simplex-chat/simplexmq.git`
- Build the docker image using their instructions, which, as of writing, was `DOCKER_BUILDKIT=1 docker buildx build --platform linux/arm64 -t shyfire131/smp-server:arm --build-arg APP="smp-server" --build-arg APP_PORT="5223" . --push`
- Then, mirror the official AMD64 image as follows:
```
docker pull simplexchat/smp-server
docker tag simplexchat/smp-server <your-dockerhub-username>/smp-server:amd64
docker push <your-dockerhub-username>/smp-server:amd64
```
- At this point you need to do some manifest hacking:
- `docker buildx imagetools create -t shyfire131/smp-server:latest shyfire131/smp-server:arm shyfire131/smp-server:amd6`

You can then reference `shyfire131/smp-server` in your Dockerfile, of course replacing shyfire131 with your own username in all of the above.

Other than that, building the .s9pk is fairly straightforward and doesn't need any special dependencies.
## Cloning

Clone the project locally:

```
git clone git@github.com:shyfire131/startOS-simplexMQ-wrapper.git
cd startOS-simplexMQ-wrapper
make
```

## Testing performed

- [X] Smoke testing - DMs work on macOS, iOS and Android
- [X] Continuity testing - Server config persists across service restarts
- [X] DR testing - Backups restore successfully 

## Roadmap
- [ ] Support for XFTP Server (sending large attachments, will either be a standalone Service or bundled once multi-container services are supported)
- [ ] Server statistics (`log_stats: on` in `smp-server.ini`)
- [ ] Clearnet support will obviously be a superpower once available
- [ ] Use official multi-architecture Docker Hub once SimpleX team fixes that
