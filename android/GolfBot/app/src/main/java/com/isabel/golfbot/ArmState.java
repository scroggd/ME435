package com.isabel.golfbot;

/**
 * Created by isabel on 5/17/15.
 */
public class ArmState extends DelayState {
    public ArmState(MainActivity act, State next){
        super(next, 1000, act);
    }

    @Override
    public void onSet(){
        super.onSet();
        act.sendCommand("ATTACH 111111");
        act.sendCommand("POSITION 0 90 0 -90 90");
    }

    @Override
    public void onLeave(){
        super.onLeave();
        act.robot.setSpeed(0, 0);
    }

}
