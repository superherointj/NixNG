# SPDX-FileCopyrightText:  2021 Richard Brežák and NixNG contributors
#
# SPDX-License-Identifier: MPL-2.0
#
#   This Source Code Form is subject to the terms of the Mozilla Public
#   License, v. 2.0. If a copy of the MPL was not distributed with this
#   file, You can obtain one at http://mozilla.org/MPL/2.0/.

# These arguments are provided by the overarching NixNG repository and are not user confugurable.
{ nglib
, overlay
}:
# These arguments are user configurable
{ nixpkgs
, name
, system
, config
, defaultModules ? import ../modules/list.nix
, extraModules ? []
}:
with nixpkgs.lib;
let
  evaledModules = evalModules
    {
      modules = defaultModules ++ extraModules ++ [
        ({ ... }: {
          system.name = name;
        })
        config
        ({ ... }:
          {
            _module.args = {
              pkgs = nixpkgs.legacyPackages.${system}.appendOverlays [ overlay ];
              inherit system nglib;
            };
          }
        )
      ];
    };

  failedAssertions = map (x: x.message) (filter (x: !x.assertion) evaledModules.config.assertions);
  configValid =
    if failedAssertions != [ ] then
      throw "\nFailed assertions:\n${concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
    else
      evaledModules.config;
in
evaledModules // { config = configValid; }
