#!/bin/sh

KDE_MIRROR="${KDE_MIRROR:-http://download.kde.org}"

# The extra slash at the end of the URL is necessary to stop wget
# from recursing over the whole server! (No, it's not a bug.)
$(nix-build ../../.. -A autonix.manifest) \
    "${KDE_MIRROR}/unstable/plasma/5.2.95/" \
    -A '*.tar.xz'