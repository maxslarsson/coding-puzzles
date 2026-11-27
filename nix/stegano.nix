{
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  crayons,
  opencv-python,
  piexif,
  pillow,
}:

buildPythonPackage rec {
  pname = "stegano";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Agirgaui58i4Utp9mzRxE2YFA3Iypa+CJ59v3LTLwok=";
  };

  build-system = [ poetry-core ];
  dependencies = [
    crayons
    opencv-python
    piexif
    pillow
  ];
  # stegano pins pillow <13 and opencv-python >=4.13.0.86 (a PyPI wheel build number nixpkgs'
  # 4.13.0 lacks); the LSB code only needs their long-stable APIs
  pythonRelaxDeps = [
    "opencv-python"
    "pillow"
  ];

  pythonImportsCheck = [ "stegano" ];
}
