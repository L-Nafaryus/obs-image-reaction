# OBS Image Reaction Plugin

Image that reacts to sound source.

## Building and installing for GNU/Linux:

```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release -S .
cmake --build build

mkdir -p $XDG_CONFIG_HOME/obs-studio/plugins/image-reaction/bin/64bit
cp build/libimage-reaction.so $XDG_CONFIG_HOME/obs-studio/plugins/image-reaction/bin/64bit/
cp -r data  $XDG_CONFIG_HOME/obs-studio/plugins/image-reaction/
```

## Building for Windows via MinGW:

You need to complete several steps before actual building:
- Install MinGW
- Install Wine
- Install OBS Studio to created wine environment: https://github.com/obsproject/obs-studio/releases
- Download OBS Studio sources: https://github.com/obsproject/obs-studio

```bash
# Debian example
cmake \
    -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_SYSTEM_NAME=Windows \
    -DCMAKE_CXX_COMPILER=/usr/bin/x86_64-w64-mingw32-g++-win32 \
    -DCMAKE_C_COMPILER=/usr/bin/x86_64-w64-mingw32-gcc-win32 \
    -DLIBOBS_INCLUDE_DIR=~/git/obs-studio-27.0.1/libobs \
    -DLIBOBS_LIB=~/.wine/drive_c/Program\ Files/obs-studio/bin/64bit/obs.dll \
    -S .
cmake --build build
```

Now move `libimage-reaction.dll` into OBS Plugin directory.

## Installing on NixOS with Nix Flakes

```nix 
{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        obs-image-reaction.url = "github:L-Nafaryus/obs-image-reaction";
    };
    outputs = { nixpkgs, ... } @ inputs:
    {
        nixosConfigurations.foo = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
                ({ pkgs, inputs, ... }: 
                {
                    environment.systemPackages = with pkgs; [
                        (pkgs.wrapOBS {
                            plugins = with pkgs.obs-studio-plugins; [
                                inputs.obs-image-reaction.packages.${pkgs.system}.default
                            ];
                        })
                    ];
                })
            ];
        };
    };
}
```

## References

- Original plugin sources: https://github.com/scaledteam/obs-image-reaction
- Fork with Windows/MacOS bundle support for CMake: https://github.com/ashmanix/obs-image-reaction

## License

Like [obs-studio](https://github.com/obsproject/obs-studio), `obs-image-reaction` is licensed under [GNU General Public License v2.0](./LICENSE).
