package com.isabel.golfbot;

import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

import android.location.Location;
import android.graphics.Color;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import android.os.Handler;

import edu.rosehulman.me435.AccessoryActivity;
import edu.rosehulman.me435.FieldGps;
import edu.rosehulman.me435.FieldGpsListener;
import edu.rosehulman.me435.FieldOrientation;
import edu.rosehulman.me435.FieldOrientationListener;


public class MainActivity extends AccessoryActivity implements FieldGpsListener, FieldOrientationListener {

    int selectedBall = -1;
    BallColor[] ballColors = {BallColor.NONE, BallColor.NONE, BallColor.NONE};
    TextView[] ballTexts = {null, null, null};

    public Robot robot;
    public Log log;
    public DebugKeys keys;

    State state;

    Handler handler = new Handler();
    final int tickTime = 150;

    int ticks = 0;

    public int farBall;
    public int nearBall;
    public int midBall;

    private FieldGps fieldGps;
    private FieldOrientation fieldOrientation;

    public double sensorHeading = 0;
    public double gpsX = 0;
    public double gpsY = 0;
    public double gpsHeading = 0;

    public long lastGPSTime;
    public long gpsAge = -1;

    public double bestX = 0;
    public double bestY = 0;
    public double bestHeading = 0;

    public long lastTick;

    public char team = 'r';


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        fieldGps = new FieldGps(this);
        fieldOrientation = new FieldOrientation(this);
        fieldGps.requestLocationUpdates(this);
        fieldOrientation.registerListener(this);

        robot = new Robot(this, handler);

        ballTexts[0] = (TextView) findViewById(R.id.text_0);
        ballTexts[1] = (TextView) findViewById(R.id.text_1);
        ballTexts[2] = (TextView) findViewById(R.id.text_2);

        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

        log = new Log((TextView) findViewById(R.id.logView), 20);
        log.say("Log started");
        keys = new DebugKeys((TextView) findViewById(R.id.debugKeysView));
        setState(new IdleState(this));

        tick();
    }

    public void setState(State newState){
        if(state != null){
            state.onLeave();
        }
        if(newState != null){
            newState.onSet();
        }
        state = newState;

        log.say("Set state " + state.getName());
        keys.set("State", state.getName());
    }

    protected void tick(){
        long time = System.currentTimeMillis();
        long lengthThisTick = time - lastTick;
        lastTick = time;

        ticks++;
        keys.set("ticks", ""+ticks);

        keys.set("tps", String.format("%.1f", 1000.0 / lengthThisTick));

        keys.set("Best x", String.format("%.2f", bestX));
        keys.set("Best y", String.format("%.2f", bestY));
        keys.set("Best heading", String.format("%.2f", bestHeading));

        if(lastGPSTime > 0){
            gpsAge = System.currentTimeMillis() - lastGPSTime;
        }
        keys.set("GPS age", String.format("%.1f", gpsAge/1000.0));


        state.tick();
        log.update();
        keys.update();
        handler.postDelayed(new Runnable(){
            @Override
            public void run(){tick();}
        }, tickTime);
    }

    public void onSensorChanged(double fieldHeading, float[] orientationValues){
        sensorHeading = fieldHeading;
        keys.set("Sensor heading", String.format("%.2f", sensorHeading));
        if(gpsAge < 0 || gpsAge > 3000) {
            bestHeading = fieldHeading;
        }
    }

    public void onLocationChanged(double x, double y, double heading, Location location){
        gpsX = x;
        gpsY = y;
        gpsHeading = heading;
        keys.set("GPS x", String.format("%.2f", x));
        keys.set("GPS y", String.format("%.2f", y));
        keys.set("GPS heading", String.format("%.2f", heading));

        if(! (Double.isNaN(heading) || Double.isInfinite(heading))) {
            fieldOrientation.setCurrentFieldHeading(heading);
            bestHeading = gpsHeading;
        }

        bestX = gpsX;
        bestY = gpsY;

        lastGPSTime = System.currentTimeMillis();
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

        setState(new IdleState(this));

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

        if(team == 'r') {
            midBall = whiteBlack;
            farBall = yellowBlue;
            nearBall = redGreen;
        }else{
            midBall = whiteBlack;
            farBall = redGreen;
            nearBall = yellowBlue;

        }

        if(whiteBlack < 0 || redGreen < 0 || yellowBlue < 0){
            log.say("Invalid ball combination");
            return;
        }

        fieldOrientation.setCurrentFieldHeading(90);

        setState(buildFSM());
    }

    public State buildFSM(){
        Pair<Integer, Integer> farPosition = getLocationForBall(farBall);
        Pair<Integer, Integer> nearPosition = getLocationForBall(nearBall);

        State current = new IdleState(null);

        current = new SeekingState(0, 0, this, current);
        current = new BallDropState(nearBall, this, current);
        current = new SeekingState(nearPosition.l, nearPosition.r, this, current);
        if(ballColors[midBall] == BallColor.WHITE){
            current = new BallDropState(midBall, this, current);
        }
        current = new BallDropState(farBall, this, current);
        current = new SeekingState(farPosition.l, farPosition.r, this, current);
        current = new HeadingState(this, current);
        current = new ArmState(this, current);

        return current;
    }

    public Pair<Integer, Integer> getLocationForBall(int ball){
        BallColor c = ballColors[ball];

        switch(c){
            case RED:
                return (team == 'r') ? new Pair<Integer, Integer>(90, -50) : new Pair<Integer, Integer>(240, 50);
            case BLUE:
                return (team == 'r') ? new Pair<Integer, Integer>(240, 50) : new Pair<Integer, Integer>(90, -50);
            case GREEN:
                return (team == 'r') ? new Pair<Integer, Integer>(90, 50) : new Pair<Integer, Integer>(240, -50);
            case YELLOW:
                return (team == 'r') ? new Pair<Integer, Integer>(240, -50) : new Pair<Integer, Integer>(90, 50);
        }
        return new Pair<Integer, Integer>(0, 0);
    }

    @Override
    public void sendCommand(String message){
        super.sendCommand(message);
    }

    public void sendCommand(final String message, long delay) {
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                sendCommand(message);
            }
        }, delay);
    }

    public void onSwitchTeam(View v){
        if(team == 'r'){
            team = 'b';
            ((Button) findViewById(R.id.team_button)).setText("Blue team");
        }else{
            team = 'r';
            ((Button) findViewById(R.id.team_button)).setText("Red team");

        }
    }

    public void onSetOrigin(View v){
        fieldGps.setCurrentLocationAsOrigin();
    }

    public void onSetXAxis(View v){
        fieldGps.setCurrentLocationAsLocationOnXAxis();
    }

    public void onDrop0(View v){robot.removeBall(0);}
    public void onDrop1(View v){robot.removeBall(1);}
    public void onDrop2(View v){robot.removeBall(2);}
}
