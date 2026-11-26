import java.util.List;
/** Java generics, annotations, and lambdas. */
public final class Example {
    public static void main(String[] args) {
        List<String> names = List.of("Drupal", "Twig");
        names.forEach(name -> System.out.println("Hello " + name));
    }
}
