(define-module (ros-tools)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system python)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages web)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages time)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages)
  #:use-module (gnu packages tls))

(define-public python-rospkg
  (package
    (name "python-rospkg")
    (version "1.1.7")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "rospkg" version))
        (sha256
          (base32
            "1axj16vc145njnn6hq8yxrkb0k2fysca5f87zmib6lba7bhiisf6"))))
    (build-system python-build-system)
    (propagated-inputs
      `(("python-catkin-pkg" ,python-catkin-pkg)
        ("python-pyyaml" ,python-pyyaml)))
    (home-page "http://wiki.ros.org/rospkg")
    (synopsis "ROS package library")
    (description "ROS package library")
    (license license:bsd-3)))

(define-public python-rosdistro
  (package
    (name "python-rosdistro")
    (version "0.7.1")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "rosdistro" version))
        (sha256
          (base32
            "09lrdh8gj61qvfa730i7v2n908ql9sa31m14w2ayzq3k3pg8apll"))))
    (build-system python-build-system)
    (propagated-inputs
      `(("python-catkin-pkg" ,python-catkin-pkg)
        ("python-pyyaml" ,python-pyyaml)
        ("python-rospkg" ,python-rospkg)
        ("python-setuptools" ,python-setuptools)))
    (home-page "http://wiki.ros.org/rosdistro")
    (synopsis "A tool to work with rosdistro files")
    (description
      "A tool to work with rosdistro files")
    (license #f)))

(define-public python-catkin-pkg
  (package
    (name "python-catkin-pkg")
    (version "0.4.10")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "catkin-pkg" version))
        (sha256
          (base32
            "1nv4kgapn6rbdvfgz96z5h5jdga6zca3gg1a5r3n8giykzkmy992"))))
    (build-system python-build-system)
    (propagated-inputs
      `(("python-dateutil" ,python-dateutil)
        ("python-docutils" ,python-docutils)
        ("python-pyparsing" ,python-pyparsing)))
    (home-page "http://wiki.ros.org/catkin_pkg")
    (synopsis "catkin package library")
    (description "catkin package library")
    (license license:bsd-3)))

(define-public python-rosdep
  (package
    (name "python-rosdep")
    (version "0.14.0")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "rosdep" version))
        (sha256
          (base32
            "00hqkaqam25k4710g88vkidqp35jf9cib85chxamk7nhy923hm0w"))))
    (build-system python-build-system)
    (propagated-inputs
      `(("python-catkin-pkg" ,python-catkin-pkg)
        ("python-pyyaml" ,python-pyyaml)
        ("python-rosdistro" ,python-rosdistro)
        ("python-rospkg" ,python-rospkg)))
    (home-page "http://wiki.ros.org/rosdep")
    (synopsis
      "rosdep package manager abstraction tool for ROS")
    (description
      "rosdep package manager abstraction tool for ROS")
    (license license:bsd-3)))

(define-public python-rosinstall
  (package
    (name "python-rosinstall")
    (version "0.7.8")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "rosinstall" version))
        (sha256
          (base32
            "0h7d8ynv44c68sbfn28xw4k18k3ip6252x7r7bqw6b5cifzhia1b"))))
    (build-system python-build-system)
    (propagated-inputs
      `(("python-wstool" ,python-wstool)
        ("python-rosdistro" ,python-rosdistro)
        ("python-catkin-pkg" ,python-catkin-pkg)))
    (home-page "http://wiki.ros.org/rosinstall")
    (synopsis "The installer for ROS")
    (description "The installer for ROS")
    (license license:bsd-3)))

(define-public python-rosinstall-generator
  (package
    (name "python-rosinstall-generator")
    (version "0.1.14")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "rosinstall_generator" version))
        (sha256
          (base32
            "058wld3gcnziprsgm7c5pvdscm181nywshsfpxddyhcqr12dswjk"))))
    (build-system python-build-system)
    (propagated-inputs
      `(("python-rospkg" ,python-rospkg)
        ("python-rosdistro" ,python-rosdistro)
        ("python-pyyaml" ,python-pyyaml)))
    (home-page
      "http://wiki.ros.org/rosinstall_generator")
    (synopsis
      "A tool for generating rosinstall files")
    (description
      "A tool for generating rosinstall files")
    (license license:bsd-3)))

(define-public python-rospkg
  (package
    (name "python-rospkg")
    (version "1.1.7")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "rospkg" version))
        (sha256
          (base32
            "1axj16vc145njnn6hq8yxrkb0k2fysca5f87zmib6lba7bhiisf6"))))
    (build-system python-build-system)
    (propagated-inputs
      `(("python-catkin-pkg" ,python-catkin-pkg)
        ("python-pyyaml" ,python-pyyaml)))
    (home-page "http://wiki.ros.org/rospkg")
    (synopsis "ROS package library")
    (description "ROS package library")
    (license license:bsd-3)))

(define-public python2-rospkg
  (package-with-python2 python-rospkg))

(define-public python-rosdistro
  (package
    (name "python-rosdistro")
    (version "0.7.1")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "rosdistro" version))
        (sha256
          (base32
            "09lrdh8gj61qvfa730i7v2n908ql9sa31m14w2ayzq3k3pg8apll"))))
    (build-system python-build-system)
    (propagated-inputs
      `(("python-catkin-pkg" ,python-catkin-pkg)
        ("python-pyyaml" ,python-pyyaml)
        ("python-rospkg" ,python-rospkg)
        ("python-setuptools" ,python-setuptools)))
    (home-page "http://wiki.ros.org/rosdistro")
    (synopsis "A tool to work with rosdistro files")
    (description
      "A tool to work with rosdistro files")
    (license #f)))

(define-public python-rosdep
  (package
    (name "python-rosdep")
    (version "0.14.0")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "rosdep" version))
        (sha256
          (base32
            "00hqkaqam25k4710g88vkidqp35jf9cib85chxamk7nhy923hm0w"))))
    (build-system python-build-system)
    (arguments
      `(#:tests? #f))
    (propagated-inputs
      `(("python-catkin-pkg" ,python-catkin-pkg)
        ("python-pyyaml" ,python-pyyaml)
        ("python-rosdistro" ,python-rosdistro)
        ("python-rospkg" ,python-rospkg)))
    (home-page "http://wiki.ros.org/rosdep")
    (synopsis
      "rosdep package manager abstraction tool for ROS")
    (description
      "rosdep package manager abstraction tool for ROS")
    (license license:bsd-3)))

(define-public python2-rosdep
  (package-with-python2 python-rosdep))

(define-public python-catkin-pkg
  (package
    (name "python-catkin-pkg")
    (version "0.4.10")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "catkin_pkg" version))
        (sha256
          (base32
            "1nv4kgapn6rbdvfgz96z5h5jdga6zca3gg1a5r3n8giykzkmy992"))
        (patches (search-patches "patches/catkin_pkg.patch"))))
    (build-system python-build-system)
    (arguments
      `(#:tests? #f))
    (propagated-inputs
      `(("python-dateutil" ,python-dateutil)
        ("python-docutils" ,python-docutils)
        ("python-pyparsing" ,python-pyparsing)))
    (home-page "http://wiki.ros.org/catkin_pkg")
    (synopsis "catkin package library")
    (description "catkin package library")
    (license license:bsd-3)))

(define-public python2-catkin-pkg
  (package-with-python2 python-catkin-pkg))

(define-public catkin
  (let ((commit "a6c03d38237506d47db6426b126361d57b95d1b7")
        (revision "1"))
    (package
      (name "catkin")
      (version (git-version "0.7.17" revision commit))
      (source
        (origin
          (method git-fetch)
          (uri (git-reference
                  (url "https://github.com/ros/catkin.git")
                  (commit commit)))
          (file-name (git-file-name name version))
          (sha256
              (base32
                "1zmhmygd2xgbvr934xd0zrhmcqpxmm2diwn5nqs8rj9z45y84asm"))))
      (build-system cmake-build-system)
      (arguments
        `(#:tests? #f
          #:phases
          (modify-phases %standard-phases
            (add-before 'configure 'prepare-configure
              (lambda _
                (substitute* "./cmake/templates/python_distutils_install.sh.in"
                  (("/usr/bin/env") (which "env"))))))))
      (propagated-inputs
        `(("python" ,python-2)
          ("python2-empy" ,python2-empy)
          ("python2-catkin-pkg" ,python2-catkin-pkg)))
      (home-page "http://wiki.ros.org/catkin")
      (synopsis
        "Low-level build system macros and infrastructure for ROS.")
      (description
        "Low-level build system macros and infrastructure for ROS.")
      (license license:bsd-3))))

(define-public python-vcstools
  (package
    (name "python-vcstools")
    (version "0.1.40")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "vcstools" version))
        (sha256
          (base32
            "1mfasip71ky1g968n1zlramgn3fjxk4c922d0x9cs0nwm2snln4m"))))
    (build-system python-build-system)
    (arguments
       `(#:tests? #f))
    (propagated-inputs
      `(("python-pyyaml" ,python-pyyaml)
        ("python-dateutil" ,python-dateutil)
        ("python-six" ,python-six)))
    (home-page "http://wiki.ros.org/vcstools")
    (synopsis
      "VCS/SCM source control library for svn, git, hg, and bzr")
    (description
      "VCS/SCM source control library for svn, git, hg, and bzr")
    (license license:bsd-3)))

(define-public python-wstool
  (package
    (name "python-wstool")
    (version "0.1.17")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "wstool" version))
        (sha256
          (base32
            "0dz2gn2qx919s1z5wa94nkvb01pnqp945mvj97108w7i1q8lz6y7"))))
    (build-system python-build-system)
    (propagated-inputs
      `(("python-pyyaml" ,python-pyyaml)
        ("python-vcstools" ,python-vcstools)))
    (home-page "http://wiki.ros.org/wstool")
    (synopsis "workspace multi-SCM commands")
    (description "workspace multi-SCM commands")
    (license license:bsd-3)))