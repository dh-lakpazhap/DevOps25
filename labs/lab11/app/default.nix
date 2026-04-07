{ pkgs ? import <nixpkgs> {} }:

pkgs.buildGoModule {
  pname = "app";
  version = "0.1.0";
  src = ./.;
  vendorHash = null;
}