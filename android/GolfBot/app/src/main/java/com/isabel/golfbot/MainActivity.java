package com.isabel.golfbot;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

import android.graphics.Color;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import android.os.Handler;

import edu.rosehulman.me435.AccessoryActivity;


public class MainActivity extends AccessoryActivity {

    int selectedBall = -1;
    BallColor[] ballColors = {BallColor.NONE, BallColor.NONE, BallColor.NONE};
    TextView[] ballTexts = {null, null, null};

    Robot robot;

    Handler handler = new Handler();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        robot = new Robot(this, handler);

        ballTexts[0] = (TextView) findViewById(R.id.text_0);
        ballTexts[1] = (TextView) findViewById(R.id.text_1);
        ballTexts[2] = (TextView) findViewById(R.id.text_2);
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;


    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onCommandReceived(final String command){
        Toast.makeText(this, "Message from robot: " + command, Toast.LENGTH_SHORT).show();
        robot.handleCommand(command);
    }


    public void onSelect0(View view) {
        selectedBall = 0;
    }

    public void onSelect1(View view) {
        selectedBall = 1;
    }

    public void onSelect2(View view) {
        selectedBall = 2;
    }

    public void onSetWhite(View view) {
        if(selectedBall >= 0) {
            ballColors[selectedBall] = BallColor.WHITE;
            ballTexts[selectedBall].setTextColor(Color.WHITE);
        }
    }


    public void onSetBlack(View view) {
        if(selectedBall >= 0) {
            ballColors[selectedBall] = BallColor.BLACK;
            ballTexts[selectedBall].setTextColor(Color.BLACK);
        }
    }


    public void onSetGreen(View view) {
        if(selectedBall >= 0) {
            ballColors[selectedBall] = BallColor.GREEN;
            ballTexts[selectedBall].setTextColor(Color.GREEN);
        }
    }


    public void onSetYellow(View view) {
        if(selectedBall >= 0) {
            ballColors[selectedBall] = BallColor.YELLOW;
            ballTexts[selectedBall].setTextColor(Color.YELLOW);
        }
    }


    public void onSetRed(View view) {
        if(selectedBall >= 0) {
            ballColors[selectedBall] = BallColor.RED;
            ballTexts[selectedBall].setTextColor(Color.RED);
        }
    }


    public void onSetBlue(View view) {
        if(selectedBall >= 0) {
            ballColors[selectedBall] = BallColor.BLUE;
            ballTexts[selectedBall].setTextColor(Color.BLUE);
        }
    }

    public void onReset(View view) {
        for(int i=0; i<ballColors.length; i++){
            ballColors[i] = BallColor.NONE;
            ballTexts[i].setTextColor(Color.GRAY);
        }

    }

    public void onDetect(View view) {
        onReset(view);
        robot.detectBalls();
    }

    public void updateBallColors(BallColor[] colors){
        for(int i=0; i<3; i++){
            selectedBall = i;
            switch(colors[i]){
                case BLACK:
                    onSetBlack(null); break;
                case WHITE:
                    onSetWhite(null); break;
                case BLUE:
                    onSetBlue(null); break;
                case RED:
                    onSetRed(null); break;
                case GREEN:
                    onSetGreen(null); break;
                case YELLOW:
                    onSetYellow(null); break;
            }
        }
    }

    public void onRun(View view) {

        //Identify the ball colors
        int whiteBlack = -1;
        int redGreen = -1;
        int yellowBlue = -1;

        for(int i=0; i<3; i++){
            switch(ballColors[i]) {
                case BLACK:
                case WHITE:
                    whiteBlack = i; break;
                case RED:
                case GREEN:
                    redGreen = i; break;
                case YELLOW:
                case BLUE:
                    yellowBlue = i; break;
            }
        }

        final int whiteBlackf = whiteBlack;
        final int redGreenf = redGreen;
        final int yellowBluef = yellowBlue;

        if(whiteBlack < 0 || redGreen < 0 || yellowBlue < 0){
            Toast.makeText(this, "Invalid ball colors", Toast.LENGTH_SHORT).show();
            return;
        }

        sendCommand("ATTACH 111111");

        robot.removeBall(yellowBlue);

        handler.postDelayed( new Runnable(){
            @Override
            public void run(){
                robot.setSpeed(100, 100);
            }
        }, 5000);
        handler.postDelayed( new Runnable(){
            @Override
            public void run(){
                robot.setSpeed(-100, -100);
            }
        }, 15000);
        handler.postDelayed( new Runnable(){
            @Override
            public void run(){
                robot.setSpeed(0, 0);
            }
        }, 25000);


        handler.postDelayed( new Runnable() {
            @Override
            public void run() {
                if(ballColors[whiteBlackf] == BallColor.WHITE){
                    robot.removeBall(whiteBlackf);
                }
            }
        }, 7500);
        handler.postDelayed( new Runnable() {
            @Override
            public void run() {
                robot.removeBall(redGreenf);
            }
        }, 25000);


    }

    @Override
    public void sendCommand(String message){
        super.sendCommand(message);
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
    }
}
