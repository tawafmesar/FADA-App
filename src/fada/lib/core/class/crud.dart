import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fada/core/class/statusrequest.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:io';


import '../functions/checkinternet.dart';


String _basicAuth = 'Basic ${base64Encode(utf8.encode('dddd:sdfsdfsdfsdfdsf'))}';
Map<String,String> _myheaders ={

  'authorization' : _basicAuth
};

class Crud {

  Future<Either<StatusRequest, Map>> postData(String linkurl, Map data) async {
    try {
      if (await checkInternet()) {
        var response = await http.post(Uri.parse(linkurl), body: data);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map responsebody = jsonDecode(response.body);
          print(responsebody);
          return Right(responsebody);
        } else {
          return const Left(StatusRequest.serverfailure);
        }
      } else {
        return const Left(StatusRequest.networkFailure);
      }
    } on SocketException {
      // Handle network issues
      return const Left(StatusRequest.networkFailure);
    } on FormatException catch (e) {
      print("JSON Decoding Error: $e");
      return const Left(StatusRequest.decodingFailure);
    } catch (_) {
      // Handle other unexpected exceptions
      return const Left(StatusRequest.serverException);
    }
  }
  Future<Either<StatusRequest, Map>> addRequestWithImageOne(
      String url, Map<String, dynamic> data, File? image, [String? namerequest]) async {
    if (namerequest == null) {
      namerequest = "file";
    }

    print("Request URL: $url");
    print("Request Data: $data");
    print("Request Name Field for File: $namerequest");
    if (image != null) {
      print("Image Path: ${image.path}");
    } else {
      print("No image provided.");
    }

    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(_myheaders);

    if (image != null) {
      var length = await image.length();
      var stream = http.ByteStream(image.openRead());
      stream.cast();
      var multipartFile = http.MultipartFile(
        namerequest,
        stream,
        length,
        filename: basename(image.path),
      );
      print("Image file size: $length bytes");
      request.files.add(multipartFile);
    }

    // Debug print for data fields added to the request
    data.forEach((key, value) {
      print("Adding field to request: $key = $value");
      request.fields[key] = value;
    });

    try {
      // Send Request
      var myrequest = await request.send();

      // For get Response Body
      var response = await http.Response.fromStream(myrequest);

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = jsonDecode(response.body);

        // Check if "status" key is present in the response
        if (responsebody.containsKey("status")) {
          print("Decoded Response: $responsebody");
          return Right(responsebody);
        } else {
          print("Missing 'status' key in response");
          return const Left(StatusRequest.decodingFailure);
        }
      } else {
        print("Request failed with response body: ${response.body}");
        return const Left(StatusRequest.serverfailure);
      }
    } catch (e) {
      // Handle exceptions during the request or response processing
      print("Exception: $e");
      return const Left(StatusRequest.serverException);
    }
  }


}

