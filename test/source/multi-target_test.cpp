#include <string>

#include "multi-target/multi-target.hpp"

auto main() -> int
{
  exported_class e;

  return std::string("dependency") == e.name() ? 0 : 1;
}
