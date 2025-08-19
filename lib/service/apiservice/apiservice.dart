import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  late String ip='192.168.1.16:' ;
  String url = "http://";
  dynamic networkData;
  dynamic isLive = true;
  getTimeZone() async {
    try {
      var url = Uri.parse('http://ip-api.com/json/');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var timeZone=jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        return timeZone['timezone'];
      }
    } catch (e) {
    }
  }
  get(String port, String apiString, Map<String, dynamic> params) async {
    if (isLive == true) {
      port = '8000';
      ip = "13.126.41.105:";
      apiString= "/api/tnbus_${apiString.substring(5,apiString.length).trim()}";
    }else{
      ip='192.168.1.16:';
    }
      params = params.map((key, value) => MapEntry(key, value.toString()));
    var uri = Uri.http('$ip$port', apiString, params);
    print(uri);
    var response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    } else {
      throw Exception('Server Failure');
    }
  }

  post(String port, String apiString, Map<String, dynamic> data) async {
    if (isLive == true) {
      port = '8000';
      ip = "13.126.41.105:";
      apiString= "/api/tnbus_${apiString.substring(5,apiString.length).trim()}";
    }
    print(Uri.parse('$url$ip$port$apiString'));
    var response = await http.post(Uri.parse('$url$ip$port$apiString'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      var responsebody = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      return responsebody;
    } else {
      throw Exception('Server Failure');
    }
  }

  put(String port, String apiString, Map<String, dynamic> data) async {
    if (isLive == true) {
      port = '8000';
      ip = "13.126.41.105:";
      apiString= "/api/tnbus_${apiString.substring(5,apiString.length).trim()}";
    }
    print('$url$ip$port$apiString');
    var response = await http.put(Uri.parse('$url$ip$port$apiString'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    } else {
      throw Exception('Server Failure');
    }
  }

  getIp() async {
    var url = Uri.http('ip-api.com', '/json', {});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    } else {
      throw Exception('Server Failure');
    }
  }

  delete(String port, String api, Map<String, dynamic> data) async {
    if (isLive == true) {
      port = '8000';
      ip = "13.126.41.105:";
      api= "/api/tnbus_${api.substring(5,api.length).trim()}";
    }
    if (data != null) {
      data = data.map((key, value) => MapEntry(key, value.toString()));
    }
    var uri = Uri.http('$ip$port', api, data);
    print(uri);
    var response = await http.delete(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    } else {
      throw Exception('Server Failure');
    }
  }

  urlToBase64(url) async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    } else {
      throw Exception('assets/images/Aircraft Mechanic.png');
    }
  }
}
