import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.4


Item {
	visible: false
	
    property bool running: false
    property string title: ""

    property BusyIndicator busyIndicator: null

    property var context

	property var __query: null

	signal completed(var query)
	signal succeeded(var query)
	signal failed(var query)
	signal cancelled(var query)

    function onBusyIndicatorRunningChanged() {
        if (!busyIndicator.running) {
           // console.log("Received cancel from busy indicator");
            cancel();
        }
    }

    function startBusyIndicator() {
        running = true;
        if (busyIndicator !== null) {
            busyIndicator.runningChanged.connect(onBusyIndicatorRunningChanged);
            busyIndicator.running = true;
            busyIndicator.title = title;
        }
    }

    function hideBusyIndicator() {
        if (busyIndicator !== null) {
            busyIndicator.runningChanged.disconnect(onBusyIndicatorRunningChanged);
            busyIndicator.running = false;
            busyIndicator.title = "";
        }
        running = false;
    }

    function onStatusChanged() {
        var query = __query;

        __query = null;
        
        query.statusChanged.disconnect(onStatusChanged);

        if (query.isCompleted() && (query.success("200") || query.success("201"))) {
          //  console.log("AsyncQuery: status: completed");

            hideBusyIndicator();

            completed(query);
            
	        if (query.success("200") || query.success("201")) {
              //  console.log("AsyncQuery: succeeded");
	            succeeded(query);
	        }
        }
        else if (query.isCancelled()) {
          //  console.log("AsyncQuery: status: cancelled");
            hideBusyIndicator();
            cancelled(query);
        }
        else {
	        console.log("AsyncQuery: status: failed");
	        console.log("error: " + query.error);
	        console.log("cause: " + query.errorCause);
	        console.log("message: " + query.errorMessage);
            hideBusyIndicator();
            failed(query);
        }
    }
	
    function cancel() {
        var query = __query;
        if (query !== null) {
	        console.log("AsyncQuery: cancel");
            hideBusyIndicator();
            query.cancel();
        }
    }

	function execute(query) {
		__query = query;			

        __query.statusChanged.connect(onStatusChanged);
        
        console.log("AsyncQuery: execute");

        startBusyIndicator();

        query.execute();
	}

    Component.onDestruction: {
		if (__query !== null) {
			console.log("WARNING: cancelling a running async query");
        	cancel();			
		}
    }
}
