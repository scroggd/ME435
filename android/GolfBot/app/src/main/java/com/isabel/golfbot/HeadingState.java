package com.isabel.golfbot;

/**
 * Created by isabel on 5/17/15.
 */
public class HeadingState extends DelayState {
    public HeadingState(MainActivity act, State next){
        super(next, 7000, act);
    }

    @Override
    public void onSet(){
        super.onSet();
        act.robot.setSpeed(250, 250);
    }

    @Override
    public void onLeave(){
        super.onLeave();
        act.robot.setSpeed(0, 0);
    }

}
