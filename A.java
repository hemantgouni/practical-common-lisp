public class A {
    public void bar(A arg) {
        System.out.println("First A, Second A");
    }

    public void bar(B arg) {
        System.out.println("First A, Second B");
    }
}
