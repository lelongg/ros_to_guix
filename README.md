# ROS to Guix

This repository is an effort to build [ROS](http://www.ros.org/) with the [GNU Guix](https://www.gnu.org/software/guix/) package manager.

It contains Guix package definitions needed to build ROS as well as a script to automatically produce Guix package definition for any ROS package.

## Package generation

### Quickstart

The following command will download `roscpp` sources, recursively look for its dependencies and produce a Guix package definition for each of them.

```none
./scripts/ros2guix -r -o kinetic.scm -d kinetic roscpp
```

This script will output the dependencies that cannot be generated (most system dependencies) at the end of the process.

### Synopsis

```none
usage: ros2guix [-h] [-p PATH] [-r] -d DISTRO -o OUTPUT
                [packages [packages ...]]

create Guix package definition from ROS packages

positional arguments:
  packages              packages to convert, all if none provided

optional arguments:
  -h, --help            show this help message and exit
  -p PATH, --path PATH  where to look for ROS packages
  -r, --recursive       convert dependencies too
  -d DISTRO, --distro DISTRO
                        ROS distribution
  -o OUTPUT, --output OUTPUT
                        ouput file
```

## Formatting

You can format the output with the `pretty-print` script provided.

```bash
cat ./kinetic.scm | ./scripts/pretty-print > kinetic-pretty.scm
```

## Example

The `kinetic.scm` file is an example generated from the [quickstart](#quickstart) command line.
Manual editing was required to import modules, add boost 1.58 definition, disable some failing tests and add missing python dependencies.

Once you have Guix installed, you can build `roscpp` by following the following steps.

Add this repository to your Guix package path.

```none
export GUIX_PACKAGE_PATH=/absolute/path/to/this/repository/ros_to_guix
```

Launch the build process.

```none
guix build roscpp
```

As `rospack` is a dependency of `roscpp` it should now be available.
You can run it in isolation with the following commands.

```none
guix environment --pure --ad-hoc --container rospack
rospack help
```

