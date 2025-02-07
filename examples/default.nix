# SPDX-FileCopyrightText:  2021 Richard Brežák and NixNG contributors
#
# SPDX-License-Identifier: MPL-2.0
#
#   This Source Code Form is subject to the terms of the Mozilla Public
#   License, v. 2.0. If a copy of the MPL was not distributed with this
#   file, You can obtain one at http://mozilla.org/MPL/2.0/.

{ nglib, nixpkgs }:
let
  examples =
    { "gitea" = ./gitea;
      "apache" = ./apache;
      "nginx" = ./nginx;
      "crond" = ./crond;
      "nix" = ./nix;
      "hydra" = ./hydra;
      "certbot" = ./certbot;
      "postfix" = ./postfix;
      "pantalaimon" = ./pantalaimon;
      "jmusicbot" = ./jmusicbot;
      "php-fpm" = ./php-fpm;
      "minecraft" = ./minecraft;
      "home-assistant" = ./home-assistant;
      "syncthing" = ./syncthing;
    };
in
  nixpkgs.lib.mapAttrs (_: v: import v { inherit nixpkgs nglib; }) examples
