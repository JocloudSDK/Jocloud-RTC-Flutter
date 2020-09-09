package com.yy.awen.flutterthunder.srceenrecord;

import java.util.ArrayList;
import java.util.List;

public class ObserverManager {

    private List<Observer> events = new ArrayList<>();

    private static class Holder {
        private final static ObserverManager instance = new ObserverManager();
    }

    private ObserverManager() {

    }

    public static ObserverManager getInstance() {
        return Holder.instance;
    }

    public void addObserver(Observer event) {
        if (event != null) {
            events.add(event);
        }
    }

    public void removeObserver(Observer event) {
        if (event != null) {
            events.remove(event);
        }
    }

    public void sendMessage(String msg) {
        for (Observer event : events) {
            event.event(msg);
        }
    }

}
