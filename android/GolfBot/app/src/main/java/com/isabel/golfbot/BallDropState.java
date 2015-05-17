package com.isabel.golfbot;

import android.widget.Toast;

/**
 * Created by isabel on 5/14/15.
 */
public class BallDropState extends DelayState{

    protected int ball;

    public BallDropState(int ball, MainActivity act, State next){
        super(next, 5000, act);
        this.ball = ball;
        this.act = act;
        this.next = next;
    }

    @Override
    public void onSet(){
        super.onSet();

        Toast.makeText(act, "Dropping ball " + ball, Toast.LENGTH_SHORT).show();
        // Issue arm position commands here
    }

    public String getName(){
        return "Drop ball " + ball;
    }
}
