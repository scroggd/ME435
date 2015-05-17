package com.isabel.golfbot;

import android.widget.TextView;
import java.util.TreeMap;

import java.util.Map;

/**
 * Created by isabel on 5/11/15.
 */
public class DebugKeys {

    TextView view;
    Map<String, String> data = new TreeMap<String, String>();

    public DebugKeys(TextView v){
        view = v;
    }

    public void set(String key, String value){
        data.put(key, value);
    }

    public void clear(String key){
        if(data.containsKey(key)){
            data.remove(key);
        }
    }

    public void update(){
        String result = "";
        for(String key : data.keySet()){
            result += String.format("%s: %s\n", key, data.get(key));
        }
        view.setText(result);
    }
}
