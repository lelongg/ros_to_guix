(define-module (urdfdom)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system python)
  #:use-module (gnu packages)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages web)
  #:use-module (gnu packages time)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages check)
  #:use-module (gnu packages apr)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages tls))

(define-public urdfdom-headers
  (package
    (name "urdfdom-headers")
    (version "1.0.0")
    (source
        (origin
          (method git-fetch)
          (uri (git-reference
                  (url "https://github.com/ros/urdfdom_headers.git")
                  (commit "1.0.0")))
          (file-name (git-file-name name version))
          (sha256
              (base32
                "1wm5q4yx6p09q6bqcdgmmrb9ayclhk8c1qii9wbgb91sg3jpdf8s"))))
    (build-system cmake-build-system)
    (arguments
      `(#:tests? #f))
    (home-page "https://wiki.ros.org/urdf")
    (synopsis "The URDF (U-Robot Description Format) headers provides core data structure headers for URDF.")
    (description "The URDF (U-Robot Description Format) headers provides core data structure headers for URDF.")
    (license license:bsd-3)))

(define-public urdfdom
  (package
    (name "urdfdom")
    (version "1.0.0")
    (source
        (origin
          (method git-fetch)
          (uri (git-reference
                  (url "https://github.com/ros/urdfdom.git")
                  (commit "1.0.0")))
          (file-name (git-file-name name version))
          (sha256
              (base32
                "0c82wb0cpblarwpll3zgks2h6syk05kcvplwv5irpgcmjg9qj246"))))
    (build-system cmake-build-system)
    (inputs
      `(("tinyxml" ,tinyxml)
        ("console-bridge" ,console-bridge)
        ("urdfdom-headers" ,urdfdom-headers)))
    (propagated-inputs
      `(("tinyxml" ,tinyxml)
        ("urdfdom-headers" ,urdfdom-headers)))
    (home-page "https://wiki.ros.org/urdf")
    (synopsis "The URDF (U-Robot Description Format) library provides core data structures and a simple XML parsers for populating the class data structures from an URDF file.")
    (description "This package contains a C++ parser for the Unified Robot Description Format (URDF), which is an XML format for representing a robot model. The code API of the parser has been through our review process and will remain backwards compatible in future releases.")
    (license license:bsd-3)))