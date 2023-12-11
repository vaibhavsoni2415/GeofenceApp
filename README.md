# Geofence App

## Simulate Geofencing

1. Checkout the code and run pod install to install the dependencies.
2. Open xcworkspace* file.
3. Select the simulator in target area and run the app.
4. App will open with map screen and it will ask for the location permission.
5. Allow the location permission, right now denying the location permission is not handled due to time limitation.
6. Click on add button on top right corner to add geofence area on map.
7. Adjust the map below marker to select the center location of genfence area.
8. Radius of geofence area is 200 meters in the code.
9. Once you set the geofence center in console it will show the center location of geofence center coordinate in map.
10. Copy the latest latitude and longitude from the console.
11. Click on simulator, in top menu go to Features -> Location -> Enter Current Location.
12. Paste the current location in latitude and longitude fields hit enter.
13. So now app current location will be set inside of center geofence area.
14. Geofence area will be saved to core data & app will show the prompt on entering the geofence area.
15. Click in Features -> Location -> Set Apple as current location or any other location to exit the geofence area 
16. App will save the data upon exiting the geofence area from map and will show prompt.
