public class B extends A {
    public void bar(A arg) {
        System.out.println("First B, Second A");
    }
    public void bar(B arg) {
        System.out.println("First B, Second B");
    }
}
