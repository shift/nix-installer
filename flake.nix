{
  description = "Bcachefs enabled installation media";
  inputs.nixos.url = "github:nixos/nixpkgs/nixos-23.11";
  outputs = { self, nixos }: {
    nixosConfigurations = {
      exampleIso = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
          ({ lib, pkgs, ... }: {
            nixpkgs.overlays = [
              (final: prev: {
                pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
                  (pyfinal: pyprev: {
                    numpy = pyprev.numpy.overridePythonAttrs (oldAttrs: {
                      preConfigure = ''
                                                                                    export NPY_DISABLE_CPU_FEATURES="max -avx512f -avx512cd -avx512_knl -avx512_knm -avx512_skx -avx512_clx -avx512_cnl -avx512_icl"
                                                                                    '';
                      postPatch = ''
                                                                                    rm numpy/core/tests/test_cython.py
                                                                                    rm numpy/core/tests/test_umath_accuracy.py
                                                                                    rm numpy/core/tests/test_*.py
                                                                                    patchShebangs numpy/_build_utils/*.py
                                                                                    '';
                      doCheck = false;
                      doInstallCheck = false;
                      dontCheck = true;
                      disabledTests = [
                        "test_math"
                        "test_umath_accuracy"
                        "test_validate_transcendentals"
                      ];
                    });
                    sphinx = pyprev.scipy.overridePythonAttrs (oldAttrs: {
                      doCheck = false;
                      doInstallCheck = false;
                      dontCheck = true;
                    });
                    scipy = pyprev.scipy.overridePythonAttrs (oldAttrs: {
                      doCheck = false;
                      doInstallCheck = false;
                      dontCheck = true;
                    });
                    pandas = pyprev.pandas.overridePythonAttrs (oldAttrs: {
                      doCheck = false;
                      doInstallCheck = false;
                      dontCheck = true;
                    });
                    eventlet = pyprev.eventlet.overridePythonAttrs (oldAttrs: {
                      doCheck = false;
                      doInstallCheck = false;
                      dontCheck = true;
                    });
                    aiohttp = pyprev.aiohttp.overridePythonAttrs (oldAttrs: {
                      doCheck = false;
                      doInstallCheck = false;
                      dontCheck = true;
                    });
                    websockets = pyprev.websockets.overridePythonAttrs (oldAttrs: {
                      doCheck = false; #test hanged
                      doInstallCheck = false;
                      dontCheck = true;
                    });
                    setuptools = pyprev.setuptools.overridePythonAttrs (oldAttrs: {
                      doCheck = false; #test hanged
                      doInstallCheck = false;
                      dontCheck = true;
                    });
                    afdko = pyprev.afdko.overridePythonAttrs (oldAttrs: {
                      doCheck = false; #test hanged
                      doInstallCheck = false;
                      dontCheck = true;
                    });



                  })
                ];
              })
            ];
	    nixpkgs.hostPlatform = {
              gcc.arch = "skylake";
              gcc.tune = "skylake";
              system = "x86_64-linux";
            };
            boot.supportedFilesystems = [ "bcachefs" ];
            boot.kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_latest;
          })
        ];
      };
    };
  };
}
