from dataclasses import dataclass

@dataclass
class EntityReference:
    """Python annotations, strings, and interpolation."""
    label: str = "Drupal"

    def render(self, count: int = 42) -> str:
        return f"{self.label}: {count}"
