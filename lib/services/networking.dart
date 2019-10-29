import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper{

  NetworkHelper( this.url);

  final String url;

  Future getData ()async{
    http.Response response = await http.get(url);
    if (response.statusCode == 200)
    {
      String data = response.body;

      var decodedData = jsonDecode(data);

      return decodedData;

      /* Decode data with repeating (jsonDecode(data))
        var temperature = jsonDecode(data)['main']['temp'];
        var condition = jsonDecode(data)['weather'][0]['id'];
        var cityName = jsonDecode(data)['name'];

        */
    }else{
      print(response.statusCode);
    }
  }
}