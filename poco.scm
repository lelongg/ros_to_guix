(define-module (poco)
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

(define-public poco
  (package
    (name "poco")
    (version "1.9.0")
    (source
        (origin
          (method git-fetch)
          (uri (git-reference
                  (url "https://github.com/pocoproject/poco.git")
                  (commit "13eda19cd1c2685113b535da7bf36aa88dfdaa5d")))
          (file-name (git-file-name name version))
          (sha256
              (base32
                "1ip02sns593b0zwlfa71i7i0xrjxxmvfwb2frayf0pa2r9lxhxkc"))))
    (build-system cmake-build-system)
    (arguments
        `(#:tests? #f))
    (home-page "https://pocoproject.org/")
    (synopsis "The POCO C++ Libraries are powerful cross-platform C++ libraries for building network- and internet-based applications that run on desktop, server, mobile, IoT, and embedded systems.")
    (description "The POCO C++ Libraries are powerful cross-platform C++ libraries for building network- and internet-based applications that run on desktop, server, mobile, IoT, and embedded systems.")
    (license license:boost1.0)))