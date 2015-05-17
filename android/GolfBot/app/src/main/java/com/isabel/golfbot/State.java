package com.isabel.golfbot;

/**
 * Created by isabel on 5/12/15.
 */
public abstract class State {

    protected long setTime;
    protected MainActivity act;

    public void onSet() {
        setTime = System.currentTimeMillis();
    }

    public void onLeave(){

    }

    public void tick(){

    }

    public abstract String getName();
}
