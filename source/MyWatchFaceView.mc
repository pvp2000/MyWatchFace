using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Time.Gregorian;

class MyWatchFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$:$3$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (Application.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d"), clockTime.sec.format("%02d")]);

        // Update the view
        var view = View.findDrawableById("TimeLabel");
        view.setColor(Application.getApp().getProperty("ForegroundColor"));
        view.setText(timeString);
        
        //Date
        var date = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateFormat ="$1$ $2$ $3$";
        var dateString = Lang.format(dateFormat, [date.day_of_week, date.day, date.month]);
        var dateView = View.findDrawableById("DateLabel");
        dateView.setText(dateString);
        
        //Steps + Floors
        var info = ActivityMonitor.getInfo();
        var steps = info.steps; 
        var goal = info.stepGoal;
        var floors = info.floorsClimbed;
        var floorGoal = info.floorsClimbedGoal;
        var calories = info.calories;
        var stepsString = Lang.format("Stps: $1$/$2$", [steps,goal]);
        var stepsView = View.findDrawableById("StepsLabel");
        stepsView.setText(stepsString);
        var floorString = Lang.format("Flrs: $1$/$2$", [floors,floorGoal]);
        var floorView = View.findDrawableById("FloorsLabel");
        floorView.setText(floorString);
        var caloriesString = Lang.format("Cal: $1$", [calories]);
        var caloriesView = View.findDrawableById("CaloriesLabel");
        caloriesView.setText(caloriesString);
        
        //Heartrate
        var hrIterator = ActivityMonitor.getHeartRateHistory(null, false);
		var previous = hrIterator.next();
		var heartString = Lang.format("HR: $1$",[previous.heartRate]);
		var HRView = View.findDrawableById("HRLabel");
		HRView.setText(heartString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
