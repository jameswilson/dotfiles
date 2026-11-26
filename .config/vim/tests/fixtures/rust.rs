// Rust attributes, types, macros, and borrowing.
#[derive(Debug)]
struct EntityReference { label: String }
fn main() {
    let entity = EntityReference { label: String::from("Drupal") };
    println!("Hello {}: {:?}", &entity.label, entity);
}
