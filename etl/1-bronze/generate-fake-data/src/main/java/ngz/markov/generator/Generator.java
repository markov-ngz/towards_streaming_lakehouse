package ngz.markov.generator;

/*
*  Generate Instance of the specified class
*/
public interface Generator<T> {
    default void open() {}
    T generate();
}