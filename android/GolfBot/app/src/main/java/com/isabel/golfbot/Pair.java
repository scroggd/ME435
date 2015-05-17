package com.isabel.golfbot;

/**
 * Created by isabel on 5/14/15.
 */
public class Pair<T1, T2> {
    protected T1 l;
    protected T2 r;

    public Pair(T1 l, T2 r){
        this.l = l;
        this.r = r;
    }

    public T1 l(){ return l; }
    public T2 r(){ return r; }
}
