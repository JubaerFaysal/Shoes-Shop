import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePick extends GetxController {
  RxString image =''.obs;

  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image.value=pickedFile.path.toString();
    }
  }
}

