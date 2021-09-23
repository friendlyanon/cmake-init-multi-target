#include <string>

#include "multi-target/multi-target.hpp"

#include "private/dependency.hpp"

exported_class::exported_class()
    : m_name(::dependency())
{
}

auto exported_class::name() const -> const char*
{
  return m_name.c_str();
}
