# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  flexcpp = {
    pname = "flexcpp";
    version = "dcc05b1f1d2610572666b7ac77200ed41f558503";
    src = fetchgit {
      url = "https://gitlab.com/fbb-git/flexcpp";
      rev = "dcc05b1f1d2610572666b7ac77200ed41f558503";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-hnsWJATdA24kxuOmH7x8HMH9nPFXAAThofXvshuWk0s=";
    };
    date = "2024-06-22";
  };
  lyricer = {
    pname = "lyricer";
    version = "f0f8d99b23102755ce7c70830127b23cfde96f3e";
    src = fetchFromGitHub {
      owner = "moelife-coder";
      repo = "lyricer";
      rev = "f0f8d99b23102755ce7c70830127b23cfde96f3e";
      fetchSubmodules = false;
      sha256 = "sha256-sviP/0b77uu+C9ihfHnYNwIehStBp5m2WIDW9sqVq1k=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./lyricer-f0f8d99b23102755ce7c70830127b23cfde96f3e/Cargo.lock;
      outputHashes = {
        
      };
    };
    date = "2020-11-15";
  };
  rime-ls = {
    pname = "rime-ls";
    version = "v0.4.0";
    src = fetchFromGitHub {
      owner = "wlh320";
      repo = "rime-ls";
      rev = "v0.4.0";
      fetchSubmodules = false;
      sha256 = "sha256-ZqoRFIF3ehfEeTN+ZU+/PAzA4JyS1403+sqZdzwJHA8=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./rime-ls-v0.4.0/Cargo.lock;
      outputHashes = {
        "librime-sys-0.1.0" = "sha256-zJShR0uaKH42RYjTfrBFLM19Jaz2r/4rNn9QIumwTfA=";
      };
    };
  };
  sjtu-canvas-helper = {
    pname = "sjtu-canvas-helper";
    version = "1.3.19";
    src = fetchurl {
      url = "https://github.com/Okabe-Rintarou-0/SJTU-Canvas-Helper/releases/download/app-v1.3.19/sjtu-canvas-helper_1.3.19_amd64.deb";
      sha256 = "sha256-dQUgiX2zWZA/2sH3gFPkZ7OQbyEJxEtG61piwmncFNU=";
    };
  };
}
