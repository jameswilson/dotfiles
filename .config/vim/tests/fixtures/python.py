"""Module documentation should be gray."""
from dataclasses import dataclass

# Hash comments should be gray too.

@dataclass
class EntityReference:
    """Python annotations, strings, and interpolation."""
    label: str = "Drupal"
    enabled: bool = True

    def render(self, count: int = 42) -> str:
        r'''Method documentation should be gray.'''
        return f"{self.label}: {count}"

    def describe(self, value) -> str:
        return f"{value.type}: {len(self.label)}"


multiline_value = """An assigned multiline value stays mint.
Its continuation also stays mint.
"""
