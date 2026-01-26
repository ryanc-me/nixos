{
  lib,
  stdenv,
  python312,
  rtlcss,
  wkhtmltopdf,
}:
let
  odoo_version = "19.0";
  odoo_hash = "fb4e08fe46c0e1865e30b0ce1eb5f4436438ea03";
  odoo_enterprise_hash = "399bf6f0e3123701c2b1cefc14d14eff99a0a518";
  odoo_design_themes_hash = "c8a9bb44191bab7360c968e81447448028b0fd78";

  fetchGitHubSSH =
    {
      owner,
      repo,
      rev,
    }:
    fetchGit {
      url = "ssh://git@github.com/${owner}/${repo}.git";
      name = repo;
      inherit rev;
      submodules = false;
      shallow = true;
    };

  addonRepos = [
    {
      name = "odoo-enterprise";
      src = fetchGitHubSSH {
        owner = "odoo";
        repo = "enterprise";
        rev = odoo_enterprise_hash;
      };
      # pythonDeps = ps: with ps; [ geoip2 ];
      # binDeps = [ ];
    }
    {
      name = "odoo-design-themes";
      src = fetchGitHubSSH {
        owner = "odoo";
        repo = "design-themes";
        rev = odoo_design_themes_hash;
      };
    }
    {
      name = "oca-web";
      src = fetchGitHubSSH {
        owner = "OCA";
        repo = "web";
        rev = "512b9f9e3aa1295c8de55d967f27e27401549144";
      };
    }
  ];

  odooSrc = fetchGitHubSSH {
    owner = "odoo";
    repo = "odoo";
    rev = odoo_hash;
  };

  baseBinDeps = [
    wkhtmltopdf
    rtlcss
  ];
  basePythonDeps =
    ps: with ps; [
      asn1crypto
      babel
      cbor2
      chardet
      cryptography
      decorator
      docutils
      ebaysdk
      freezegun
      geoip2
      gevent
      greenlet
      idna
      jinja2
      libsass
      lxml
      lxml-html-clean
      markupsafe
      num2words
      ofxparse
      openpyxl
      passlib
      pillow
      polib
      psutil
      psycopg2
      pydot
      pyopenssl
      pypdf2
      pyserial
      python-dateutil
      python-ldap
      python-stdnum
      pytz
      pyusb
      qrcode
      reportlab
      requests
      rjsmin
      urllib3
      vobject
      werkzeug
      xlrd
      xlsxwriter
      xlwt
      zeep
    ];

  extraPythonDeps = ps: lib.flatten (map (r: (r.pythonDeps or (_ps: [ ])) ps) addonRepos);

  extraBinDeps = lib.flatten (map (r: r.binDeps or [ ]) addonRepos);

  pythonEnv = python312.withPackages (ps: (basePythonDeps ps) ++ (extraPythonDeps ps));

  outPath = placeholder "out";
  coreDir = "${outPath}/share/odoo";
  addonsDir = "${outPath}/share/odoo-addons-repos";

  defaultAddonsPath = lib.concatStringsSep "," (
    [
      "${coreDir}/addons"
      "${coreDir}/odoo/addons"
    ]
    ++ (map (r: "${addonsDir}/${r.name}") addonRepos)
  );

in
stdenv.mkDerivation {
  pname = "odoo";
  version = "${odoo_version}-${odoo_hash}";

  src = odooSrc;

  buildInputs = baseBinDeps ++ extraBinDeps;

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${coreDir}
    mkdir -p ${addonsDir}
    mkdir -p $out/bin

    # odoo source
    cp -a . ${coreDir}

    # addons repos
    ${lib.concatStringsSep "\n" (
      map (r: ''
        echo "Installing addon repo: ${r.name}"
        cp -a ${r.src} ${addonsDir}/${r.name}
        # Ensure writable bits aren't required; keep perms sane
        chmod -R u+w ${addonsDir}/${r.name} || true
      '') addonRepos
    )}

    # python wrapper (so that workers > 0 will work)
    cat > $out/bin/odoo <<'PY'
    #!${pythonEnv}/bin/python
    import os
    import sys
    import subprocess

    DEFAULT_ADDONS_PATH = "${defaultAddonsPath}"

    def has_addons_path(argv):
      for a in argv:
        if a.startswith("--addons-path") or a.startswith("--addons_path"):
          return True
      return False

    def main():
      argv = sys.argv[1:]

      # just in case we need to override
      if not has_addons_path(argv):
        argv = [f"--addons-path={DEFAULT_ADDONS_PATH}"] + argv

      python = "${pythonEnv}/bin/python"
      odoo_bin = "${coreDir}/odoo-bin"
      os.execv(python, [python, odoo_bin] + argv)

    if __name__ == "__main__":
      main()
    PY
    chmod +x $out/bin/odoo

    runHook postInstall
  '';

  passthru = {
    inherit pythonEnv odooSrc addonRepos;
  };

  meta = with lib; {
    description = "Open Source ERP and CRM";
    homepage = "https://www.odoo.com/";
    maintainers = with maintainers; [ ryanc-me ];
    mainProgram = "odoo";
  };
}
