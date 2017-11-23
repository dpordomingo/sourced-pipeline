# Default shell
SHELL := /bin/bash

## Config
CONFIG_ROVERS_VERSION ?= 2.5.3
CONFIG_BORGES_VERSION ?= 0.8.3
CONFIG_BBLFSH_VERSION ?= 2.2.0
CONFIG_ENGINE_VERSION ?= 0.1.8

CONFIG_DBUSER ?= gemini
CONFIG_DBPASS ?= geminis
CONFIG_DBNAME ?= geminidb

# env
wd := $(shell pwd)
envFile := $(wd)/.env
envExample := $(wd)/.env.example

$(envFile):
	$(copy) $(envExample) $(envFile)

# Tools
copy := cp -R

# Makefiles
-include makefiles/Makefile.dep
-include makefiles/Makefile.docker
-include $(envFile)

## Enters in a brand new container with a brand new image
fresh-start: rebuild restart

## Rebuilds docker image after cleaning the current image and container
rebuild: dependencies docker-image-rebuild

## Restarts the container
restart: docker-run

## Enters in the container
sh: docker-sh

## View container logs
logs: docker-logs

## Builds the dependencies
dependencies: dependencies-build

## Cleans container, images and built dependencies
clean: docker-clean-dangling dependencies-clean

## Cleans the container, and intermediate layers, keeping the main image
clean-intermediate-layers: docker-clean-intermediate-layers
