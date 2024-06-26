{
  description = "ss3code";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    tpl2cpp.url = "github:alexpbell/tpl2cpp";
  };

  outputs = { self, nixpkgs, tpl2cpp }: {

    packages.x86_64-linux.default = 

      with import nixpkgs { system = "x86_64-linux"; };

      stdenv.mkDerivation {

        name = "ss3code";

        src = pkgs.fetchFromGitHub {
          owner = "nmfs-ost";
          repo = "ss3-source-code";
          rev = "v3.30.22.1";
          sha256 = "r/grfMvbna6XpfovOiT96d7Mm4o06l4WzGX3VFGojYQ=";
        };
       
        nativeBuildInputs = [ makeWrapper ];

        buildInputs = [ tpl2cpp.packages.x86_64-linux.default ];

        buildPhase = ''
          cat $src/SS_biofxn.tpl $src/SS_miscfxn.tpl $src/SS_selex.tpl $src/SS_popdyn.tpl $src/SS_recruit.tpl $src/SS_benchfore.tpl $src/SS_expval.tpl $src/SS_objfunc.tpl $src/SS_write.tpl $src/SS_write_ssnew.tpl $src/SS_write_report.tpl $src/SS_ALK.tpl $src/SS_timevaryparm.tpl $src/SS_tagrecap.tpl > SS_functions.temp
          cat $src/SS_versioninfo_330safe.tpl $src/SS_readstarter.tpl $src/SS_readdata_330.tpl $src/SS_readcontrol_330.tpl $src/SS_param.tpl $src/SS_prelim.tpl $src/SS_global.tpl $src/SS_proced.tpl SS_functions.temp > ss3.tpl
          tpl2cpp ss3
          cat ss3.htp ss3.cpp > ss3.txt
          sed "s/'//g" ss3.txt > ss3clean.txt
          echo "#!/usr/bin/bash" > ss3code
          echo "echo '" >> ss3code
          cat ss3clean.txt >> ss3code
          echo "'" >> ss3code
          chmod +x ss3code
        '';

        installPhase = ''
          mkdir -p $out/bin
          install -t $out/bin ss3code
        '';   

     };
  };
}
