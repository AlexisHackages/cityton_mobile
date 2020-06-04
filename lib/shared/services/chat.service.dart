import 'dart:io';
import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/http/http.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mime/mime.dart';

var http = Http();

class ChatService {
  Future<ApiResponse> getThreads(int userId) async {
    final res = await http.get("chat/getThreadsByUserId/" + userId.toString());

    return res;
  }

  Future<ApiResponse> getMessages(int threadId) async {
    final res = await http.get("chat/getMessages/" + threadId.toString());

    return res;
  }

  Future<CloudinaryResponse> sendToCloudinary(File file) async {
    CloudinaryResponse response;
    final cloudinary = CloudinaryPublic(DotEnv().env['CLOUDINARY_CLOUD_NAME'],
        DotEnv().env['CLOUDINARY_UPLOAD_PRESET'],
        cache: false, dioClient: http.getDioClient());

    String mimeStr = lookupMimeType(file.path);
    String fileType = mimeStr.split('/').first;

    if (fileType == "image") {
      response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(file,
            resourceType: CloudinaryResourceType.Image),
      );
    } else if (fileType == "video") {
      response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(file,
            resourceType: CloudinaryResourceType.Video),
      );
    }

    return response;
  }
}
