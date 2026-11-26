# Ruby symbols, interpolation, classes, and blocks.
class EntityReference
  def render(name = 'Drupal')
    { label: "Hello #{name}", enabled: true }.each do |key, value|
      puts "#{key}: #{value}"
    end
  end
end
