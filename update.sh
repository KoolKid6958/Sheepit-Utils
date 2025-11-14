#!/usr/bin/env bash
set -e

git pull
git submodule update --init --recursive
rm -rf ./public
hugo