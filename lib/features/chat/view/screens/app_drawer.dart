import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatt/features/auth/view/screens/sign_in.dart';
import 'package:chatt/services/local_db.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = LocalStorage.getUserInfo();
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 50,),
          ListTile(
            leading:  CircleAvatar(
              backgroundImage: user!.profile != null ? 
              user.profile == ""
              ? const AssetImage("assets/icons/female.png") :
              CachedNetworkImageProvider(user.profile!) :
              const AssetImage("assets/icons/female.png"),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user!.name!),
                Text(user.email!),
              ],
            ),

          ),
          const Divider(thickness: 1,height: 10,),
          ListTile(
            leading: const Icon(Icons.logout,color: Colors.red,),
            onTap: () async {
              await LocalStorage.clearAll();
              if(context.mounted){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SignIn()),
                    (route) => false);
              }
            },
            title: Text("Logout",style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.red),),
          )
        ],
      ),
    );
  }
}