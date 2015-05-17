package com.isabel.golfbot;

/**
 * Created by isabel on 5/12/15.
 */
public class IdleState extends State{

    public IdleState(MainActivity act){
        this.act = act;
    }

    public String getName(){
        return "idle";
    }
}
