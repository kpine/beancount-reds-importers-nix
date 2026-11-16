{
  lib,
  buildPythonPackage,
  # Source tree and version are supplied by the caller (see flake.nix)
  beancount-reds-importers-src,
  version,
  # build-system
  hatchling,
  # dependencies
  beancount,
  beangulp,
  beautifulsoup4,
  click,
  click-aliases,
  dateparser,
  loguru,
  lxml,
  ofxparse,
  openpyxl,
  packaging,
  pdfplumber,
  petl,
  python-dateutil,
  requests,
  tabulate,
  tqdm,
  xlrd,
  # tests
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "beancount-reds-importers";
  inherit version;
  src = beancount-reds-importers-src;
  pyproject = true;

  build-system = [ hatchling ];

  dependencies = [
    beancount
    beangulp
    beautifulsoup4
    click
    click-aliases
    dateparser
    loguru
    lxml
    ofxparse
    openpyxl
    packaging
    pdfplumber
    petl
    python-dateutil
    requests
    tabulate
    tqdm
    xlrd
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Requires git, which is unavailable in the build sandbox
    "test_release_ancestry_with_real_git_repository"
  ];

  pythonImportsCheck = [ "beancount_reds_importers" ];

  meta = {
    homepage = "https://github.com/redstreet/beancount_reds_importers";
    changelog = "https://github.com/redstreet/beancount_reds_importers/blob/main/CHANGELOG.md";
    description = "Simple ingesting tools for Beancount";
    license = lib.licenses.gpl3Only;
  };
}
