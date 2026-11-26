#include <iostream>
#include <string>
// C++ templates, namespaces, and references.
template <typename T> T identity(const T& value) { return value; }
int main() {
    std::string name = "Drupal";
    std::cout << identity(name) << '\n';
}
