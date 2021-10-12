# multi-target

This project is an example project generated with [cmake-init][1] with the
purpose of showing off how to create an internal dependency as an
implementation detail in the form of a static library.

# Building and installing

See the [BUILDING](BUILDING.md) document.

## Internal dependency

Right now, CMake does not combine the `.a` or `.lib` files, which means that if
your public static library target depends on one as an internal dependency, you
must also install the internal dependency, which will show up in the install
interface as a `$<LINK_ONLY:...>` generator expression. The purpose of this
genex is that the public static library target does not contain the object code
form the internal static library dependency, so it must also be linked into a
consuming final target. If CMake didn't do this for you, then you would end up
with linker errors due to missing symbols related to an implementation detail.

This list will assume that your public target is static or shared depending on
the value of CMake provided `BUILD_SHARED_LIBS`. Changes to be made:

* Make the [config file](cmake/install-config.cmake.in) configurable.
* Setup a [new export set](cmake/install-rules.cmake#L63) for the internal
  dependency.

[1]: https://github.com/friendlyanon/cmake-init
