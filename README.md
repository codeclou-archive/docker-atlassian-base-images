# docker-atlassian-base-images

Base Images of Atlassian Software used in other Images based on Alpine Linux with Oracle JDK 8.

Used by:

 * [docker-atlassian-confluence-data-center](https://github.com/codeclou/docker-atlassian-confluence-data-center)
 * [docker-atlassian-jira-data-center](https://github.com/codeclou/docker-atlassian-jira-data-center)

-----

&nbsp;

### Usage

You can extend from such a base image in your `Dockerfile` like so:

```
FROM codeclou/docker-atlassian-base-images:confluence-6.1.1

...
```

See the Dockerfiles here for internal structure. Basically all images have the following structure:

 * `/confluence/` = where Confluence is extracted to
 * `/confluence-home/` = Confluence Home
 * `/confluence-shared-home/` = Confluence Shared Home for Confluence Data Center
 * User `worker` with UID and GID 10777 is created and all files and dirs are owned by him
 * `/work` can be used as Volume when inspecting container to exchange data
 * `/work-private` can be used to place files like docker-entrypoint.sh and other configs.
 * jinja2-cli is installed, so that you can run `jinja2 myscript.sh.jinja2 env-variables.json > myscript.sh`

-----

&nbsp;

### License

[MIT](./LICENSE) © [Bernhard Grünewaldt](https://github.com/clouless)
