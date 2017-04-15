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

See the Dockerfiles here for internal structure.

-----

&nbsp;

### License

[MIT](./LICENSE) © [Bernhard Grünewaldt](https://github.com/clouless)
