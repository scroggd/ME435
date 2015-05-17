package com.isabel.golfbot;

import edu.rosehulman.me435.NavUtils;

/**
 * Created by isabel on 5/12/15.
 */
public class SeekingState extends AutonomousState {

    int x;
    int y;
    boolean done = false;
    private double currentDistance = -1;
    private double bestDistance = -1;

    protected static double IDEAL_THRESHOLD = 3;
    protected static double ACCEPT_THRESHOLD = 10;
    protected static double GIVE_UP_THRESHOLD = 30;
    protected static double GIVE_UP_RATIO = 0.3;
    protected static int TURN_THRESHOLD = 40;
    protected static int TURN_WAIT_TIME = 500;

    protected State turn;

    public SeekingState(int x, int y, MainActivity act, State next){
        this.x = x;
        this.y = y;
        this.act = act;
        this.next = next;
        turn = new TurningState(x, y, act, this);
    }

    @Override
    public void tick(){
        super.tick();

        currentDistance = NavUtils.getDistance(x, y, act.bestX, act.bestY);
        bestDistance = bestDistance < 0 ? currentDistance : bestDistance;
        bestDistance = currentDistance<bestDistance? currentDistance : bestDistance;

        double targetHeading = NavUtils.getTargetHeading(act.bestX, act.bestY, x, y);
        act.keys.set("Distance", String.format("%.1f", currentDistance));
        act.keys.set("Best distance", String.format("%.1f", bestDistance));
        act.keys.set("Target heading", String.format("%.1f", targetHeading));

        double headingDiff = targetHeading - act.bestHeading;
        double err = Math.abs(headingDiff);
        while(headingDiff > 180) headingDiff -= 360;
        while(headingDiff < -180) headingDiff += 360;

        int turnAmnt = (int) headingDiff;
        if(turnAmnt >= 0){
            act.robot.setSpeed(250, 250-turnAmnt);
        }else{
            act.robot.setSpeed(250+turnAmnt, 250);
        }

        //if(err > TURN_THRESHOLD && System.currentTimeMillis() - setTime > TURN_WAIT_TIME){
        //    act.setState(turn);
        //}

        // Adjust wheel speeds here
    }

    @Override
    public void onLeave(){
        super.onLeave();
        act.robot.setSpeed(0, 0);
        act.keys.clear("Distance");
        act.keys.clear("Best distance");
        act.keys.clear("Target heading");
    }

    public String getName(){
        return String.format("Seeking (%d,%d)", x, y);
    }

    public boolean done() {
        if(currentDistance < 0 || bestDistance < 0) return false;
        if(currentDistance < ACCEPT_THRESHOLD) return true;
        if(currentDistance < ACCEPT_THRESHOLD && currentDistance > bestDistance) return true;
        if(currentDistance < GIVE_UP_THRESHOLD && (currentDistance - bestDistance) / bestDistance > GIVE_UP_RATIO) return true;
        return false;
    }


}
