{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (_finalAttrs: {
  pname = "waylrc";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "hafeoz";
    repo = "waylrc";
    rev = "63927f9260374ee2ed9dc17325f9fe55c9ebfc0f";
    hash = "sha256-pomWIUVVyMpPYP7AyG7P7TTCeW1+T4hnR8fgtFm76uo=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-vCBwPhaSYbTvpus0ZbQplbsWIzVt8SqkauXh1lneRgw=";

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
