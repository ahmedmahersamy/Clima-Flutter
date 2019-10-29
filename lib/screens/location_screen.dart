import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/screens/city_screen.dart';

class LocationScreen extends StatefulWidget {

  LocationScreen({this.locationWeather});
  final locationWeather;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();

  int temperature;
  var weatherIcon;
  var weatherMessage;
  String cityName;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    updateUI(widget.locationWeather);
  }

  void updateUI( weatherData ){
    setState(() {
      if(weatherData == null)
        {
          temperature = 0;
          weatherIcon = 'Error';
          weatherMessage = 'Unable to get weather data';
          cityName = '';
          return; // the return here make function exit with out execution the rest code

        }
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      weatherMessage = weather.getMessage(temperature);

      var condition = weatherData['weather'][0]['id'];

      weatherIcon = weather.getWeatherIcon(condition);
      cityName = weatherData['name'];

      //hard coded because api return city name "testing"
      if (cityName == 'testing'){
        cityName = 'Cairo';
      }
      //print(weatherData);
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async{
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                    var typedName = await  Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) {
                        return CityScreen();
                      },
                      ),
                      );
                    if(typedName != null)
                      {
                        var weatherData = await weather.getCityWeather(typedName); //because it's return a Future
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0 , bottom: 150.0),
                child: Text(
                  "$weatherMessage in $cityName!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}


