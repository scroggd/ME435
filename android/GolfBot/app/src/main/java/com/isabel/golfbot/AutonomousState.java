package com.isabel.golfbot;

/**
 * Created by isabel on 5/14/15.
 */
public abstract class AutonomousState extends State{

    protected State next;

    public State getNextState(){
        return next;
    }

    public abstract boolean done();

    public void tick(){
        super.tick();
        if(done()){
            act.setState(getNextState());
        }
    }

}