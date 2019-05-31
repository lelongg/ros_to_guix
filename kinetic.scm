(define-module (kinetic)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system python)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages web)
  #:use-module (gnu packages time)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages graphviz)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages check)
  #:use-module (gnu packages apr)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages wxwidgets)
  #:use-module (gnu packages tls)
  #:use-module (ice-9 ftw)
  #:use-module (poco)
  #:use-module (urdfdom)
  #:use-module (log4cxx)
  #:use-module (ros-tools)
  #:use-module (console-bridge))

(define-public boost
  (package
    (name "boost")
    (version "1.58.0")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "mirror://sourceforge/boost/boost_"
                    (string-map (lambda (x) (if (eq? x #\.) #\_ x)) version)
                    ".tar.bz2"))
              (sha256
               (base32
                "1rfkqxns60171q62cppiyzj8pmsbwp1l8jd7p6crriryqd7j1z7x"))
              (patches (list (search-patch "patches/boost-mips-avoid-m32.patch")))))
    (build-system gnu-build-system)
    (inputs `(("zlib" ,zlib)))
    (native-inputs
     `(("perl" ,perl)
       ("python" ,python-2)
       ("tcsh" ,tcsh)))
    (arguments
     (let ((build-flags
            `("threading=multi" "link=shared"

              ;; Set the RUNPATH to $libdir so that the libs find each other.
              (string-append "linkflags=-Wl,-rpath="
                             (assoc-ref outputs "out") "/lib")

              ;; Boost's 'context' library is not yet supported on mips64, so
              ;; we disable it.  The 'coroutine' library depends on 'context',
              ;; so we disable that too.
              ,@(if (string-prefix? "mips64" (or (%current-target-system)
                                                 (%current-system)))
                    '("--without-context" "--without-coroutine")
                    '()))))
       `(#:tests? #f
         #:phases
         (modify-phases %standard-phases
           (delete 'bootstrap)
           (replace
            'configure
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((out (assoc-ref outputs "out")))
                (substitute* '("libs/config/configure"
                               "libs/spirit/classic/phoenix/test/runtest.sh"
                               "tools/build/doc/bjam.qbk"
                               "tools/build/src/engine/execunix.c"
                               "tools/build/src/engine/Jambase"
                               "tools/build/src/engine/jambase.c")
                  (("/bin/sh") (which "sh")))

                (setenv "SHELL" (which "sh"))
                (setenv "CONFIG_SHELL" (which "sh"))

                (unless (zero? (system* "./bootstrap.sh"
                                        (string-append "--prefix=" out)
                                        "--with-toolset=gcc"))
                  (throw 'configure-error)))))
           (replace
            'build
            (lambda* (#:key outputs #:allow-other-keys)
              (zero? (system* "./b2" ,@build-flags))))
           (replace
            'install
            (lambda* (#:key outputs #:allow-other-keys)
              (zero? (system* "./b2" "install" ,@build-flags))))))))

    (home-page "http://boost.org")
    (synopsis "Peer-reviewed portable C++ source libraries")
    (description
     "A collection of libraries intended to be widely useful, and usable
across a broad spectrum of applications.")
    (license (license:x11-style "http://www.boost.org/LICENSE_1_0.txt"
"Some components have other similar licences."))))

(define-public roscpp
  (package
    (name "roscpp")
    (version "1.12.14")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/ros_comm-release.git")
               (commit "release/kinetic/roscpp/1.12.14-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "0n82622sq2azn1hky3c7laxwdgfdrcbahbv5gabw4pm18x9razcr"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (inputs
      `(("cpp-common" ,cpp-common)
        ("message-generation" ,message-generation)
        ("pkg-config" ,pkg-config)
        ("rosconsole" ,rosconsole)
        ("roscpp-serialization" ,roscpp-serialization)
        ("roscpp-traits" ,roscpp-traits)
        ("rosgraph-msgs" ,rosgraph-msgs)
        ("roslang" ,roslang)
        ("rostime" ,rostime)
        ("std-msgs" ,std-msgs)
        ("xmlrpcpp" ,xmlrpcpp)))
    (propagated-inputs
      `(("cpp-common" ,cpp-common)
        ("message-runtime" ,message-runtime)
        ("rosconsole" ,rosconsole)
        ("roscpp-serialization" ,roscpp-serialization)
        ("roscpp-traits" ,roscpp-traits)
        ("rosgraph-msgs" ,rosgraph-msgs)
        ("rostime" ,rostime)
        ("std-msgs" ,std-msgs)
        ("xmlrpcpp" ,xmlrpcpp)))
    (home-page "http://ros.org/wiki/roscpp")
    (synopsis
      "roscpp is a C++ implementation of ROS. It provides\n a <a href=\"http://www.ros.org/wiki/Client%20Libraries\">client\n library</a> that enables C++ programmers to quickly interface with\n ROS <a href=\"http://ros.org/wiki/Topics\">Topics</a>,\n <a href=\"http://ros.org/wiki/Services\">Services</a>,\n and <a href=\"http://ros.org/wiki/Parameter Server\">Parameters</a>.\n\n roscpp is the most widely used ROS client library and is designed to\n be the high-performance library for ROS.")
    (description
      "roscpp is a C++ implementation of ROS. It provides\n a <a href=\"http://www.ros.org/wiki/Client%20Libraries\">client\n library</a> that enables C++ programmers to quickly interface with\n ROS <a href=\"http://ros.org/wiki/Topics\">Topics</a>,\n <a href=\"http://ros.org/wiki/Services\">Services</a>,\n and <a href=\"http://ros.org/wiki/Parameter Server\">Parameters</a>.\n\n roscpp is the most widely used ROS client library and is designed to\n be the high-performance library for ROS.")
    (license license:bsd-3)))

(define-public rosgraph-msgs
  (package
    (name "rosgraph-msgs")
    (version "1.11.2")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/ros_comm_msgs-release.git")
               (commit "release/kinetic/rosgraph_msgs/1.11.2-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "1acyvalskr9hk23g2rsavpanjvnhq1cz467lnymyh4xd5g7xkrza"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (inputs
      `(("message-generation" ,message-generation)
        ("std-msgs" ,std-msgs)))
    (propagated-inputs
      `(("message-runtime" ,message-runtime)
        ("std-msgs" ,std-msgs)))
    (home-page "http://ros.org/wiki/rosgraph_msgs")
    (synopsis
      "Messages relating to the ROS Computation Graph. These are generally considered to be low-level messages that end users do not interact with.")
    (description
      "Messages relating to the ROS Computation Graph. These are generally considered to be low-level messages that end users do not interact with.")
    (license license:bsd-3)))

(define-public rosconsole
  (package
    (name "rosconsole")
    (version "1.12.14")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/ros_comm-release.git")
               (commit "release/kinetic/rosconsole/1.12.14-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "1qyv4gncm30yakj2mybw99n9c4gn786w139d6bpsl4jscpk79mvm"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (inputs
      `(("apr" ,apr)
        ("boost" ,boost)
        ("cpp-common" ,cpp-common)
        ("log4cxx" ,log4cxx)
        ("rostime" ,rostime)
        ("rosunit" ,rosunit)))
    (propagated-inputs
      `(("apr" ,apr)
        ("cpp-common" ,cpp-common)
        ("log4cxx" ,log4cxx)
        ("rosbuild" ,rosbuild)
        ("rostime" ,rostime)))
    (home-page "http://www.ros.org/wiki/rosconsole")
    (synopsis "ROS console output library.")
    (description "ROS console output library.")
    (license license:bsd-3)))

(define-public cpp-common
  (package
    (name "cpp-common")
    (version "0.6.11")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/roscpp_core-release.git")
               (commit "release/kinetic/cpp_common/0.6.11-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "1xr926154i7kspnj4sb32vxl4q4jm178ncazq0hhvviwwh46nxpy"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (inputs
      `(("boost" ,boost)
        ("console-bridge" ,console-bridge)))
    (propagated-inputs
      `(("boost" ,boost)
        ("console-bridge" ,console-bridge)))
    (home-page "http://www.ros.org/wiki/cpp_common")
    (synopsis
      "cpp_common contains C++ code for doing things that are not necessarily ROS\n related, but are useful for multiple packages. This includes things like\n the ROS_DEPRECATED and ROS_FORCE_INLINE macros, as well as code for getting\n backtraces.\n\n This package is a component of <a href=\"http://www.ros.org/wiki/roscpp\">roscpp</a>.")
    (description
      "cpp_common contains C++ code for doing things that are not necessarily ROS\n related, but are useful for multiple packages. This includes things like\n the ROS_DEPRECATED and ROS_FORCE_INLINE macros, as well as code for getting\n backtraces.\n\n This package is a component of <a href=\"http://www.ros.org/wiki/roscpp\">roscpp</a>.")
    (license license:bsd-3)))

(define-public xmlrpcpp
  (package
    (name "xmlrpcpp")
    (version "1.12.14")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/ros_comm-release.git")
               (commit "release/kinetic/xmlrpcpp/1.12.14-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "1v7mr6pmnijp6bkaqya8z2brfk04a1rd2lyj8m5fim58k8k8g4i1"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (inputs
      `(("cpp-common" ,cpp-common) ("rostime" ,rostime)))
    (propagated-inputs
      `(("cpp-common" ,cpp-common) ("rostime" ,rostime)))
    (home-page "http://xmlrpcpp.sourceforge.net")
    (synopsis
      "XmlRpc++ is a C++ implementation of the XML-RPC protocol. This version is\n heavily modified from the package available on SourceForge in order to\n support roscpp's threading model. As such, we are maintaining our\n own fork.")
    (description
      "XmlRpc++ is a C++ implementation of the XML-RPC protocol. This version is\n heavily modified from the package available on SourceForge in order to\n support roscpp's threading model. As such, we are maintaining our\n own fork.")
    (license license:lgpl2.1)))

(define-public rostime
  (package
    (name "rostime")
    (version "0.6.11")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/roscpp_core-release.git")
               (commit "release/kinetic/rostime/0.6.11-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "0500gr9y1vrwbhx2ihnyaprys7svpg2hxkk191y3x5b969lc8ibm"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (inputs
      `(("boost" ,boost) ("cpp-common" ,cpp-common)))
    (propagated-inputs
      `(("boost" ,boost) ("cpp-common" ,cpp-common)))
    (home-page "http://ros.org/wiki/rostime")
    (synopsis
      "Time and Duration implementations for C++ libraries, including roscpp.")
    (description
      "Time and Duration implementations for C++ libraries, including roscpp.")
    (license license:bsd-3)))

(define-public message-runtime
  (package
    (name "message-runtime")
    (version "0.4.12")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/message_runtime-release.git")
               (commit
                 "release/kinetic/message_runtime/0.4.12-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "0mh60p1arv7gj0w0wgg3c4by76dg02nd5hkd4bh5g6pgchigr0qy"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (propagated-inputs
      `(("cpp-common" ,cpp-common)
        ("roscpp-serialization" ,roscpp-serialization)
        ("roscpp-traits" ,roscpp-traits)
        ("rostime" ,rostime)
        ("genpy" ,genpy)))
    (home-page "http://ros.org/wiki/message_runtime")
    (synopsis
      "Package modeling the run-time dependencies for language bindings of messages.")
    (description
      "Package modeling the run-time dependencies for language bindings of messages.")
    (license license:bsd-3)))

(define-public std-msgs
  (package
    (name "std-msgs")
    (version "0.5.11")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/std_msgs-release.git")
               (commit "release/kinetic/std_msgs/0.5.11-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "0wb2c2m0c7ysfwmyanrkx7n1iy0xr7fawjp2vf6xmk5469jz2l9b"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (inputs
      `(("message-generation" ,message-generation)))
    (propagated-inputs
      `(("message-runtime" ,message-runtime)))
    (home-page "http://www.ros.org/wiki/std_msgs")
    (synopsis
      "Standard ROS Messages including common message types representing primitive data types and other basic message constructs, such as multiarrays.\n For common, generic robot-specific message types, please see <a href=\"http://www.ros.org/wiki/common_msgs\">common_msgs</a>.")
    (description
      "Standard ROS Messages including common message types representing primitive data types and other basic message constructs, such as multiarrays.\n For common, generic robot-specific message types, please see <a href=\"http://www.ros.org/wiki/common_msgs\">common_msgs</a>.")
    (license license:bsd-3)))

(define-public roscpp-serialization
  (package
    (name "roscpp-serialization")
    (version "0.6.11")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/roscpp_core-release.git")
               (commit
                 "release/kinetic/roscpp_serialization/0.6.11-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "1rgw9xvnbc64gbxc7aw797hbq49v1ql783msyf2njda4fcmwzwpp"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (inputs
      `(("cpp-common" ,cpp-common)
        ("roscpp-traits" ,roscpp-traits)
        ("rostime" ,rostime)))
    (propagated-inputs
      `(("cpp-common" ,cpp-common)
        ("roscpp-traits" ,roscpp-traits)
        ("rostime" ,rostime)))
    (home-page
      "http://ros.org/wiki/roscpp_serialization")
    (synopsis
      "roscpp_serialization contains the code for serialization as described in\n <a href=\"http://www.ros.org/wiki/roscpp/Overview/MessagesSerializationAndAdaptingTypes\">MessagesSerializationAndAdaptingTypes</a>.\n\n This package is a component of <a href=\"http://www.ros.org/wiki/roscpp\">roscpp</a>.")
    (description
      "roscpp_serialization contains the code for serialization as described in\n <a href=\"http://www.ros.org/wiki/roscpp/Overview/MessagesSerializationAndAdaptingTypes\">MessagesSerializationAndAdaptingTypes</a>.\n\n This package is a component of <a href=\"http://www.ros.org/wiki/roscpp\">roscpp</a>.")
    (license license:bsd-3)))

(define-public roscpp-traits
  (package
    (name "roscpp-traits")
    (version "0.6.11")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/roscpp_core-release.git")
               (commit "release/kinetic/roscpp_traits/0.6.11-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "0pgwzd2yzsqfap80n6wcnj0jip1z3cghw49mihyf8w0q3lfz6yf6"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (propagated-inputs
      `(("cpp-common" ,cpp-common) ("rostime" ,rostime)))
    (home-page "http://ros.org/wiki/roscpp_traits")
    (synopsis
      "roscpp_traits contains the message traits code as described in\n <a href=\"http://www.ros.org/wiki/roscpp/Overview/MessagesTraits\">MessagesTraits</a>.\n\n This package is a component of <a href=\"http://www.ros.org/wiki/roscpp\">roscpp</a>.")
    (description
      "roscpp_traits contains the message traits code as described in\n <a href=\"http://www.ros.org/wiki/roscpp/Overview/MessagesTraits\">MessagesTraits</a>.\n\n This package is a component of <a href=\"http://www.ros.org/wiki/roscpp\">roscpp</a>.")
    (license license:bsd-3)))

(define-public message-generation
  (package
    (name "message-generation")
    (version "0.4.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/message_generation-release.git")
               (commit
                 "release/kinetic/message_generation/0.4.0-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "0vnwr3jx0dapmyqgiy7h4qxkf837cv1wacqpxm5j10c864vmcrb3"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (propagated-inputs
      `(("gencpp" ,gencpp)
        ("geneus" ,geneus)
        ("gennodejs" ,gennodejs)
        ("genlisp" ,genlisp)
        ("genmsg" ,genmsg)
        ("genpy" ,genpy)))
    (home-page
      "http://ros.org/wiki/message_generation")
    (synopsis
      "Package modeling the build-time dependencies for generating language bindings of messages.")
    (description
      "Package modeling the build-time dependencies for generating language bindings of messages.")
    (license license:bsd-3)))

(define-public roslang
  (package
    (name "roslang")
    (version "1.14.4")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/ros-release.git")
               (commit "release/kinetic/roslang/1.14.4-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "18p5ncr4qq3shhmrf3zsmx7sqpzli2n2k9lbb1s64fqljcwnzkd1"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (propagated-inputs
      `(("catkin" ,catkin) ("genmsg" ,genmsg)))
    (home-page "http://ros.org/wiki/roslang")
    (synopsis
      "roslang is a common package that all <a href=\"http://www.ros.org/wiki/Client%20Libraries\">ROS client libraries</a> depend on.\n This is mainly used to find client libraries (via 'rospack depends-on1 roslang').")
    (description
      "roslang is a common package that all <a href=\"http://www.ros.org/wiki/Client%20Libraries\">ROS client libraries</a> depend on.\n This is mainly used to find client libraries (via 'rospack depends-on1 roslang').")
    (license license:bsd-3)))

(define-public genlisp
  (package
    (name "genlisp")
    (version "0.4.16")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/genlisp-release.git")
               (commit "release/kinetic/genlisp/0.4.16-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "0qndyl118h7y6amsydfaippb5lk1s2lbk38f4b88012522bgf1mf"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (inputs `(("genmsg" ,genmsg)))
    (propagated-inputs `(("genmsg" ,genmsg)))
    (home-page "http://www.ros.org/wiki/roslisp")
    (synopsis
      "Common-Lisp ROS message and service generators.")
    (description
      "Common-Lisp ROS message and service generators.")
    (license license:bsd-3)))

(define-public genpy
  (package
    (name "genpy")
    (version "0.6.7")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/genpy-release.git")
               (commit "release/kinetic/genpy/0.6.7-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "1mvyiwn98n07nfsd2igx8g7laink4c7g5f7g1ljqqpsighrxn5jd"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (inputs `(("genmsg" ,genmsg)))
    (propagated-inputs
      `(("genmsg" ,genmsg)
        ("python2-pyyaml" ,python2-pyyaml)))
    (home-page "https://github.com/ros/genpy/issues")
    (synopsis
      "Python ROS message and service generators.")
    (description
      "Python ROS message and service generators.")
    (license license:bsd-3)))

(define-public genmsg
  (package
    (name "genmsg")
    (version "0.5.11")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/genmsg-release.git")
               (commit "release/kinetic/genmsg/0.5.11-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "04ya9x910yvbpk883y3cpw2kmbkg8l8hl808sh79cyk4ff6hd0wf"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (propagated-inputs `(("catkin" ,catkin)))
    (home-page "http://www.ros.org/wiki/genmsg")
    (synopsis
      "Standalone Python library for generating ROS message and service data structures for various languages.")
    (description
      "Standalone Python library for generating ROS message and service data structures for various languages.")
    (license license:bsd-3)))

(define-public gencpp
  (package
    (name "gencpp")
    (version "0.6.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/gencpp-release.git")
               (commit "release/kinetic/gencpp/0.6.0-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "1wjizls8h2qjjq8aliwqvxd86p2jzll4cq66grzf8j7aj3dxvyl2"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (inputs `(("genmsg" ,genmsg)))
    (propagated-inputs `(("genmsg" ,genmsg)))
    (home-page
      "https://github.com/ros/gencpp/issues")
    (synopsis
      "C++ ROS message and service generators.")
    (description
      "C++ ROS message and service generators.")
    (license license:bsd-3)))

(define-public geneus
  (package
    (name "geneus")
    (version "2.2.6")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/tork-a/geneus-release.git")
               (commit "release/kinetic/geneus/2.2.6-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "0gdw4ph0ixirkg0c1kp8lqdf9kpjfc59iakpf5i1cvy1fvff0kcd"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (inputs `(("genmsg" ,genmsg)))
    (propagated-inputs `(("genmsg" ,genmsg)))
    (home-page "http://wiki.ros.org")
    (synopsis
      "EusLisp ROS message and service generators.")
    (description
      "EusLisp ROS message and service generators.")
    (license license:bsd-3)))

(define-public gennodejs
  (package
    (name "gennodejs")
    (version "2.0.1")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/RethinkRobotics-release/gennodejs-release.git")
               (commit "release/kinetic/gennodejs/2.0.1-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "077l2crbfq12dan5zg4hxi7x85m0nangmlxckh7a7ifggavzm7jh"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (inputs `(("genmsg" ,genmsg)))
    (propagated-inputs `(("genmsg" ,genmsg)))
    (home-page "http://wiki.ros.org")
    (synopsis
      "Javascript ROS message and service generators.")
    (description
      "Javascript ROS message and service generators.")
    (license license:asl2.0)))

(define-public rosbuild
  (package
    (name "rosbuild")
    (version "1.14.4")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/ros-release.git")
               (commit "release/kinetic/rosbuild/1.14.4-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "0xarzviz72yihmngy0wjz1lkra4xgx5zr11ddqw2xvsca8xsa4kw"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (inputs `(("pkg-config" ,pkg-config)))
    (propagated-inputs
      `(("catkin" ,catkin)
        ("message-generation" ,message-generation)
        ("message-runtime" ,message-runtime)))
    (home-page "http://ros.org/wiki/rosbuild")
    (synopsis
      "rosbuild contains scripts for managing the CMake-based build system for ROS.")
    (description
      "rosbuild contains scripts for managing the CMake-based build system for ROS.")
    (license license:bsd-3)))

(define-public rosunit
  (package
    (name "rosunit")
    (version "1.14.4")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/ros-release.git")
               (commit "release/kinetic/rosunit/1.14.4-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "0czgdsy7acg32a6vhshfk61m8gqay1qv65v8i9fi4r4zc235d0sh"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (propagated-inputs
      `(("python2-rospkg" ,python2-rospkg)
        ("roslib" ,roslib)))
    (home-page "http://ros.org/wiki/rosunit")
    (synopsis
      "Unit-testing package for ROS. This is a lower-level library for rostest and handles unit tests, whereas rostest handles integration tests.")
    (description
      "Unit-testing package for ROS. This is a lower-level library for rostest and handles unit tests, whereas rostest handles integration tests.")
    (license license:bsd-3)))

(define-public roslib
  (package
    (name "roslib")
    (version "1.14.4")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/ros-release.git")
               (commit "release/kinetic/roslib/1.14.4-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "1a9xp0qfihhsls8ab89qdxvn4cr0kw4r7516ddi7h4d8j9cx9crd"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (inputs `(("boost" ,boost) ("rospack" ,rospack)))
    (propagated-inputs
      `(("catkin" ,catkin)
        ("python2-rospkg" ,python2-rospkg)
        ("python-empy" ,python-empy)
        ("python-catkin-pkg" ,python-catkin-pkg)
        ("ros-environment" ,ros-environment)
        ("rospack" ,rospack)))
    (home-page "http://ros.org/wiki/roslib")
    (synopsis
      "Base dependencies and support libraries for ROS.\n roslib contains many of the common data structures and tools that are shared across ROS client library implementations.")
    (description
      "Base dependencies and support libraries for ROS.\n roslib contains many of the common data structures and tools that are shared across ROS client library implementations.")
    (license license:bsd-3)))

(define-public ros-environment
  (package
    (name "ros-environment")
    (version "1.0.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/ros_environment-release.git")
               (commit
                 "release/kinetic/ros_environment/1.0.0-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "1q279cs8ifvfv1i5484n210zby8zbs1r8cbg21m50ld2lbnp5hrs"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (home-page
      "https://github.com/ros/ros_environment")
    (synopsis
      "The package provides the environment variables `ROS_VERSION`, `ROS_DISTRO`, `ROS_PACKAGE_PATH`, and `ROS_ETC_DIR`.")
    (description
      "The package provides the environment variables `ROS_VERSION`, `ROS_DISTRO`, `ROS_PACKAGE_PATH`, and `ROS_ETC_DIR`.")
    (license license:asl2.0)))

(define-public rospack
  (package
    (name "rospack")
    (version "2.4.4")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/rospack-release.git")
               (commit "release/kinetic/rospack/2.4.4-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "0b5gvzzxpcw3cqkg2hzrzz2zq121jlk3wsii6za69v5ip8ij1a1d"))))
    (build-system cmake-build-system)
    (arguments
      `(#:tests? #f))
    (native-inputs `(("catkin" ,catkin)))
    (inputs
      `(("boost" ,boost)
        ("cmake-modules" ,cmake-modules)
        ("googletest" ,googletest)
        ("pkg-config" ,pkg-config)
        ("python" ,python)
        ("tinyxml" ,tinyxml)))
    (propagated-inputs
      `(("boost" ,boost)
        ("pkg-config" ,pkg-config)
        ("python" ,python)
        ("python2-catkin-pkg" ,python2-catkin-pkg)
        ("python2-rosdep" ,python2-rosdep)
        ("tinyxml" ,tinyxml)))
    (home-page "http://wiki.ros.org/rospack")
    (synopsis "ROS Package Tool")
    (description "ROS Package Tool")
    (license license:bsd-3)))

(define-public cmake-modules
  (package
    (name "cmake-modules")
    (version "0.4.2")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ros-gbp/cmake_modules-release.git")
               (commit "release/kinetic/cmake_modules/0.4.2-0")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "11kh2z059ffxgjzrzh9jgdln3fhydh799bc590kfgxcqjx0kqpli"))))
    (build-system cmake-build-system)
    (native-inputs `(("catkin" ,catkin)))
    (home-page
      "https://github.com/ros/cmake_modules")
    (synopsis
      "A common repository for CMake Modules which are not distributed with CMake but are commonly used by ROS packages.")
    (description
      "A common repository for CMake Modules which are not distributed with CMake but are commonly used by ROS packages.")
    (license license:bsd-3)))
