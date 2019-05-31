(define-module (log4cxx)
  #:use-module (guix download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (gnu packages)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages apr))

(define-public log4cxx
  (package
    (name "log4cxx")
    (version "0.10.0")
    (source (origin
            (method url-fetch)
            (uri (string-append "mirror://apache/logging/log4cxx/"
                                version "/apache-" name "-" version ".tar.gz"))
            (sha256
                (base32 "130cjafck1jlqv92mxbn47yhxd2ccwwnprk605c6lmm941i3kq0d"))
            (patches (search-patches
              "patches/log4cxx-gcc-4.3.patch"
              "patches/log4cxx-gcc-4.4.patch"
              "patches/log4cxx-bugfix-LOGCXX-298.patch"
              "patches/log4cxx-bugfix-LOGCXX-280.patch"
              "patches/log4cxx-bugfix-LOGCXX-284.patch"
              "patches/log4cxx-bugfix-LOGCXX-249.patch"
              "patches/log4cxx-bugfix-LOGCXX-322.patch"
              "patches/log4cxx-bugfix-LOGCXX-365.patch"))))
    (build-system gnu-build-system)
    (inputs
    `(("apr" ,apr)
        ("apr-util" ,apr-util)
        ("zip" ,zip)))
    (arguments `(#:tests? #f))
    (home-page "https://logging.apache.org/log4cxx/index.html")
    (synopsis "Logging library for C++")
    (description "Log4cxx is the C++ port of log4j, a logging framework for JAVA. Log4cxx attempts to mimic log4j usage as much as the language will allow and to be compatible with log4j configuration and output formats.")
    (license license:asl2.0)))