package com.isabel.golfbot;

import edu.rosehulman.me435.NavUtils;

/**
 * Created by isabel on 5/17/15.
 */
public class TurningState extends AutonomousState{

    public static int SEEK_THRESHOLD = 20;
    public static int SPEED = 100;

    protected int x;
    protected int y;

    protected double err = Double.NaN;

    public TurningState(int x, int y, MainActivity act, State seek){
        this.x = x;
        this.y = y;
        this.act = act;
        this.next = seek;
    }

    public String getName(){
        return String.format("Turning (%d, %d)", x, y);
    }

    public void tick(){
        super.tick();


        double targetHeading = NavUtils.getTargetHeading(act.bestX, act.bestY, x, y);
        act.keys.set("Target heading", String.format("%.1f", targetHeading));

        double headingDiff = targetHeading - act.bestHeading;
        err = Math.abs(headingDiff);
        while(headingDiff > 180) headingDiff -= 360;
        while(headingDiff < -180) headingDiff += 360;

        int turnAmnt = (int) headingDiff;
        if(turnAmnt >= 0){
            act.robot.setSpeed(SPEED, -SPEED);
        }else{
            act.robot.setSpeed(-SPEED, SPEED);
        }
    }

    public boolean done(){
        return err < SEEK_THRESHOLD;
    }

}
