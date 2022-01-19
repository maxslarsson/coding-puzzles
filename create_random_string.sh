#!/bin/sh

head -n 16 /dev/urandom | sha256sum | head -c 6
