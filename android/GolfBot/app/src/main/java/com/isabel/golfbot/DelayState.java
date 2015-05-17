package com.isabel.golfbot;

/**
 * Created by isabel on 5/12/15.
 */
public class DelayState extends AutonomousState{
    protected long delay;


    public DelayState(State next, long delay, MainActivity act){
        this.next = next;
        this.delay = delay;
        this.act = act;
    }

    public boolean done(){
        return System.currentTimeMillis() > setTime + delay;
    }

    public String getName(){
        return "Delay: " + next.getName();
    }
}
