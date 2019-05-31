(define-module (console-bridge)
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

(define-public console-bridge
  (let ((commit "f0b423c0c2d02651db1776c96887c0a314908063")
        (revision "1"))
    (package
      (name "console-bridge")
      (version (git-version "0.7.14" revision commit))
      (source
        (origin
          (method git-fetch)
          (uri (git-reference
                  (url "https://github.com/ros/console_bridge.git")
                  (commit commit)))
          (file-name (git-file-name name version))
          (sha256
              (base32
                "0vk2ji4q93w3fw4s6p0i9d3x2ppsmhxm3x7qrcl4jfr0pyj96n5x"))))
      (build-system cmake-build-system)
      (home-page "http://wiki.ros.org/console_bridge")
      (synopsis
        "A ROS-independent package for logging that seamlessly pipes into rosconsole/rosout for ROS-dependent packages.")
      (description
        "A ROS-independent package for logging that seamlessly pipes into rosconsole/rosout for ROS-dependent packages.")
      (license license:bsd-3))))