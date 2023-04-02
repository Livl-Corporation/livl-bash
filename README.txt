![Livl Bash](img/livl-bash.png)

## What is Livl Bash ?

Livl Bash is a collection of bash utilities interfaces about files,
processes and services. A complete list of the utilities is available in
the [project description](PROJECT.md).

## Requirements

-   Unix based system
-   Bash 4.3+

The services utilities require the `systemctl` service manager. It is
not available on MacOS.

## How to use it ?

Run `main.sh` to open the main menu and choose the utility you want to
use.

You can also directly launch one of the utility scripts :

-   `files.sh`
-   `processes.sh`
-   `services.sh`

### Delegate rights to another user

You can delegate the rights to use the utilities to another user by
running `delegate.sh` as root.

``` bash
sudo ./delegate.sh
```

## Project team

- Julien Von Der Marck
- Franck Gutmann

## Report

You can read our with the file REPORT.md
