package com.isabel.golfbot;

import android.widget.TextView;

/**
 * Created by isabel on 5/11/15.
 */
public class Log {

    TextView view;
    String[] lines;
    int position = 0;

    public Log(TextView v, int lines){
        this.lines = new String[lines];
        view = v;
    }

    public void say(String line){
        lines[position] = line;
        position = (position + 1) % lines.length;
    }

    public void update(){
        String result = "";
        int i = position;
        do{
            if(lines[i] != null){
                result += String.format("%s\n", lines[i]);
            }
            i = (i+1) % lines.length;
        }while(i != position);

        view.setText(result);
    }
}
