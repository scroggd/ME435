package com.isabel.golfbot;

import android.app.Activity;
import android.widget.Toast;
import android.os.Handler;

import java.util.Map;
import java.util.TreeMap;

/**
 * Created by isabel on 5/3/15.
 */
public class Robot {

    private MainActivity a;
    protected Handler h;
    protected Map<String, String> positions;

    public Robot(MainActivity a, Handler h){
        this.a = a; this.h = h;

        positions = new TreeMap<String, String>();
        positions.put("pre1", "POSITION -30 65 -47 -120 90");
        positions.put("post1", "POSITION 30 65 -47 -120 90");
        positions.put("pre2", "POSITION -30 103 -75 -136 90");
        positions.put("post2", "POSITION 30 103 -75 -136 90");
        positions.put("pre3", "POSITION -30 157 -90 -167 90");
        positions.put("post3", "POSITION 30 157 -90 -167 90");
        positions.put("home", "POSITION 0 90 0 -90 90");
    }

    public void position(String s){
        a.sendCommand(positions.get(s));
    }

    public void removeBall(final int i){
        Toast.makeText(a, "Remove ball " + (1+i), Toast.LENGTH_SHORT).show();

        a.sendCommand("ATTACH 111111");
        a.sendCommand(positions.get("home"));
        a.sendCommand(positions.get("pre" + (1+i)), 1000);
        a.sendCommand(positions.get("post" + (1+i)), 3000);
        a.sendCommand(positions.get("home"), 4000);
    }

    public void setSpeed(int left, int right){
        a.sendCommand("WHEEL SPEED " + formatSpeed(left) + " " + formatSpeed(right));
        a.keys.set("Left", String.format("%d", left));
        a.keys.set("Right", String.format("%d", right));
    }

    public void prepWrist(){
        a.sendCommand("JOINT 5 ANGLE 20");
    }

    public String formatSpeed(int speed){
        if(speed > 200)
            speed = 200;
        if(speed < -200)
            speed = -200;

        if(speed >=0){
            return "FORWARD " + speed;
        }else{
            return "REVERSE " + (-speed);
        }
    }

    public void detectBalls(){
        a.sendCommand("CUSTOM BALL COLORS");
    }

    public void handleCommand(String command){
        if(command.startsWith("COLOR")){
            BallColor c1 = charToColor(command.charAt(6));
            BallColor c2 = charToColor(command.charAt(7));
            BallColor c3 = charToColor(command.charAt(8));
            a.log.say(command);

            a.updateBallColors(new BallColor[] {c1, c2, c3});
        }
    }

    private BallColor charToColor(char c){
        switch(c){
            case 'W': return BallColor.WHITE;
            case 'U': return BallColor.BLUE;
            case 'B': return BallColor.BLACK;
            case 'R': return BallColor.RED;
            case 'G': return BallColor.GREEN;
            case 'Y': return BallColor.YELLOW;
            default: return BallColor.NONE;
        }
    }
}
