# OpenTibiaBR - Canary

[![Discord Channel](https://img.shields.io/discord/528117503952551936.svg?style=flat-square&logo=discord)](https://discord.gg/gvTj5sh9Mp)
[![GitHub issues](https://img.shields.io/github/issues/opentibiabr/canary)](https://github.com/opentibiabr/canary/issues)
[![GitHub pull request](https://img.shields.io/github/issues-pr/opentibiabr/canary)](https://github.com/opentibiabr/canary/pulls)
[![Contributors](https://img.shields.io/github/contributors/opentibiabr/canary.svg?style=flat-square)](https://github.com/opentibiabr/canary/graphs/contributors)
[![GitHub](https://img.shields.io/github/license/opentibiabr/canary)](https://github.com/opentibiabr/canary/blob/master/LICENSE)

![GitHub repo size](https://img.shields.io/github/repo-size/opentibiabr/canary)

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=opentibiabr_canary&metric=alert_status)](https://sonarcloud.io/dashboard?id=opentibiabr_canary)

## Builds

[![Build - Ubuntu](https://github.com/opentibiabr/canary/actions/workflows/build-ubuntu.yml/badge.svg)](https://github.com/opentibiabr/canary/actions/workflows/build-ubuntu.yml)
[![Build - Windows - CMake](https://github.com/opentibiabr/canary/actions/workflows/build-windows-cmake.yml/badge.svg)](https://github.com/opentibiabr/canary/actions/workflows/build-windows-cmake.yml)
[![Build - Windows - Solution](https://github.com/opentibiabr/canary/actions/workflows/build-windows-solution.yml/badge.svg)](https://github.com/opentibiabr/canary/actions/workflows/build-windows-solution.yml)

## Docker

`docker pull opentibiabr/canary:latest`<br><br>
[![Automation](https://img.shields.io/docker/cloud/automated/opentibiabr/canary)](https://hub.docker.com/r/opentibiabr/canary)
[![Image Size](https://img.shields.io/docker/image-size/opentibiabr/canary)](https://hub.docker.com/r/opentibiabr/canary/tags?page=1&ordering=last_updated)
![Pulls](https://img.shields.io/docker/pulls/opentibiabr/canary)
[![Build](https://img.shields.io/docker/cloud/build/opentibiabr/canary)](https://hub.docker.com/r/opentibiabr/canary/builds)

## Project

OpenTibiaBR - Canary is a free and open-source MMORPG server emulator written in C++.

It is a fork of the [OTServBR-Global](https://github.com/opentibiabr/otservbr-global) project. You can see the
repository history in the [releases](https://github.com/opentibiabr/otservbr-global/releases/).

This project was created with the intention of being a base as clean as possible, to work as an MMORPG engine and not
necessarily linked to Tibia Global, although it will also work. The OpenTibiaBR - Global was adapted to work with the
source of the Canary, so that it will be the first repository to use this engine.

To connect to the server and to take a stable experience, you can
use [mehah's otclient](https://github.com/mehah/otclient)
or [tibia client](https://github.com/dudantas/tibia-client/releases/latest) and if you want to edit something, check
our [customized tools](https://docs.opentibiabr.com/opentibiabr/downloads/tools).

If you want edit the map, use the [own remere's map editor](https://github.com/opentibiabr/remeres-map-editor/).

You are subject to our code of conduct, read
at [this link](https://github.com/opentibiabr/canary/blob/master/CODE_OF_CONDUCT.md).

### Getting **Started**

* [Gitbook](https://docs.opentibiabr.com/projects/canary).
* [Wiki](https://github.com/opentibiabr/canary/wiki).

### Issues

We use the [issue tracker on GitHub](https://github.com/opentibiabr/canary/issues). Keep in mind that everyone who is
watching the repository gets notified by e-mail when there is an activity, so be thoughtful and avoid writing comments
that aren't meant for an issue (e.g. "+1"). If you'd like for an issue to be fixed faster, you should either fix it
yourself and submit a pull request, or place a bounty on the issue.

### Pull requests

Before [creating a pull request](https://github.com/opentibiabr/canary/pulls) please keep in mind:

* Do not send Pull Request changing the map, as we can't review the changes it's better to use
  our [Discord](https://discord.gg/gvTj5sh9Mp) to talk about or send the map changes to the responsible for updating it.
* Focus on fixing only one thing, mixing too much things on the same Pull Request make it harder to review, harder to
  test and if we need to revert the change it will remove other things together.
* Follow the project indentation, if your editor support you can use the [editorconfig](https://editorconfig.org/) to
  automatic configure the indentation.
* There are people that doesn't play the game on the official server, so explain your changes to help understand what
  are you changing and why.
* Avoid opening a Pull Request to just update one line of an xml file.

### Special Thanks

* our partners
* our crew (majesty, gpedro, eduardo dantas, foot)
* [our contributors](https://github.com/opentibiabr/canary/graphs/contributors)
* [fear lucien](https://github.com/FearLucien)
* [cjaker](https://github.com/Eternal-Scripts)
* [slavidodo](https://github.com/slavidodo)
* [mignari and our awesome tools](https://github.com/ottools)
* [mattyx14/otxserver](https://github.com/mattyx14/otxserver) and contributors
* [otland/forgottenserver](https://github.com/otland/forgottenserver) and contributors
* [saiyansking/optimized_forgottenserver](https://github.com/SaiyansKing/optimized_forgottenserver) and contributors
* if we forget someone, we apologize by forgot you. but you know, **forgot**tenserver.

### **Sponsors**

See our [donate page](https://docs.opentibiabr.com/home/donate)

## Project supported by JetBrains

We extend our heartfelt gratitude to Jetbrains for generously granting us licenses to collaborate on this and various
other open-source initiatives.

<a href="https://jb.gg/OpenSourceSupport/?from=https://github.com/opentibiabr/canary/">
  <img src="https://resources.jetbrains.com/storage/products/company/brand/logos/jb_beam.svg" alt="JetBrains" width="150" />
</a>

## Project supported by [TNT Cloud](https://tntcloudbr.com.br/)

Thanks for supporting our open-source project with your game cloud hosting services.

<a href="https://tntcloudbr.com.br/">
  <img src="https://tntcloudbr.com.br/logo.png" alt="TNT Cloud - Game Hosting" width="300" />
</a>

### Partners

[![Supported by OTServ Brasil](https://raw.githubusercontent.com/otbr/otserv-brasil/main/otbr.png)](https://forums.otserv.com.br)
