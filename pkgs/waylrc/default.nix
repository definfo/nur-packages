{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "waylrc";
  version = "2.2.3-4";

  src = fetchFromGitHub {
    owner = "hafeoz";
    repo = "waylrc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-18eKaL3bAmA9dO3H5ho9jG8KIKTj21UgW1O+/gWnkcc=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-zYtRQ7KhG7z+FOaeT7juvgtsLCNlXW9GGXfgh4PXSHo=";

  meta = {
    description = "An addon for waybar to display lyrics";
    homepage = "https://github.com/hafeoz/waylrc";
    license = with lib.licenses; [
      bsd0
      cc0
      wtfpl
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ definfo ];
  };
})
