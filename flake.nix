{
    description = "OBS Studio plugin with image that reacts to sound source";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    outputs = { self, nixpkgs, ... }:
    let 
        forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "i686-linux" ];
        nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
        inherit (nixpkgs) lib;
    in {
        packages = forAllSystems (system: 
        let pkgs = nixpkgsFor.${system}; 
        in {
            obs-image-reaction = pkgs.stdenv.mkDerivation {
                pname = "obs-image-reaction";
                version = "1.3";

                src = ./.;
                
                nativeBuildInputs = with pkgs; [ cmake ];
                buildInputs = with pkgs; [ obs-studio ];

                postInstall = ''
                    mkdir $out/lib $out/share
                    mv $out/obs-plugins/64bit $out/lib/obs-plugins
                    rm -rf $out/obs-plugins
                    mv $out/data $out/share/obs
                '';

                meta = with lib; {
                    description = "OBS Studio plugin with image that reacts to sound source";
                    homepage = "https://github.com/L-Nafaryus/obs-image-reaction";
                    maintainers = [];
                    license = licenses.gpl2Plus;
                    platforms = [ "x86_64-linux" "i686-linux" ];
                };
            };

            default = self.packages.${system}.obs-image-reaction;
        });

        devShells = forAllSystems (system: let pkgs = nixpkgsFor.${system}; in {
            default = pkgs.mkShell {
                buildInputs = with pkgs; [ gcc cmake gnumake obs-studio ];
            };
        });
    };
}

