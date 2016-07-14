
# [<img src=".bluebeluga.png" height="100" width="200" style="border-radius: 50%;" alt="@fancyremarker" />](https://github.com/blue-beluga/docker-geminabox) bluebeluga/geminabox

Simple Geminabox docker image w/ HTTP Basic Authentication. Uses Thin to load the Rack config file.

## Launching

The setup is optimized for usage on CoreOS but can also be used on other systems. Ensure that any mounted data volume from your host is accessible by the geminabox user from the container (uid 1000, gid 1000).

### localhost

The container is reachable from the docker host. You can find out the url by running ```echo "http://`sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' geminabox`:9292"``` in the console. Refer to the exemplary run script and customize to your requirements to launch the container. If you want to use the `--log-driver` flag you need at least Docker v. 1.7.

### CoreOS

You can use the following config in your cloud-config file. The unit will automatically start after every reboot and restart after failures. Please note that this is only exemplary, your setup might vary depending on your environment.

```
coreos:
    units:
        -
          name: docker-geminabox.service
          command: start
          content: |
            [Unit]
            Description=Gemserver
            After=docker.service
            Requires=docker.services

            [Service]
            TimeoutStartSec=0
            Restart=on-failure
            EnvironmentFile=/etc/environment
            ExecStartPre=-/usr/bin/docker kill geminabox
            ExecStartPre=-/usr/bin/docker rm geminabox
            ExecStartPre=/usr/bin/docker pull aventurini/docker-geminabox
            ExecStart=/usr/bin/docker run --name geminabox \
              -p 9292:9292 \
              -v /var/lib/docker/geminabox:/usr/src/app/data \
              -e GEMBOX_USER=${GEMBOX_USER} \
              -e GEMBOX_PASSWORD=${GEMBOX_PASSWORD} \
              aventurini/docker-geminabox
            ExecStop=/usr/bin/docker stop geminabox

            [Install]
            WantedBy=multi-user.target
```

Provide GEMBOX_USER/GEMBOX_PASSWORD in `/etc/environment` like so

```
write_files:
    - path: /etc/environment
      content: |
          GEMBOX_USER=user
          GEMBOX_PASSWORD=password
```

## Setup

Once the container is running set it up as your private gem repository with `gem inabox -c`. Enter the Host in the following format:

```
"http://$USER:$PASSWORD@<IP>:9292"
```

e.g. `http://user:password@172.17.0.10:9292`

Push to your new Gemserver via `gem inabox push <GEMFILE>`
