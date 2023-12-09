import 'package:chats/utils/request.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future getContacts(BuildContext context) async {
  // GCC 수정 ios>>pod install!
  List contacts = [];
  PermissionStatus _status = await Permission.contacts.request();
  if (await _status.isGranted) {
    var _contacts = await ContactsService.getContacts(
      withThumbnails: false,
    );
    _contacts.forEach((e) {
      e.phones?.forEach((e) {
        if (e.value != null)
          contacts.add(e.value!.replaceAll(new RegExp(r'[^0-9]'), ''));
      });
    });

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text("${contacts.length}개의 전화번호를 등록하시겠습니까?"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("취소")),
                ElevatedButton(
                    onPressed: () async {
                      await DefaultRequest.post(
                              path: "/users/contact",
                              data: {"friend": contacts})
                          .then((value) => Navigator.of(context).pop());
                    },
                    child: Text("등록"))
              ],
            ));
  }
}
