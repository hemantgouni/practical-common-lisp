public class Main {
    public static void main(String[] args) {
        A obj = args[0].equals("A") ? new A() : new B();
        obj.bar(obj);
    }
}
