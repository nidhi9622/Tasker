import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/homePage.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late TextEditingController phoneController;
  late TextEditingController nameController;
  late TextEditingController designationController;
  dynamic profileImage;  dynamic path;
  String? name;String? designation;
  String? phone;
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  setData()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setString('name',nameController.text );
    preferences.setString('number', phoneController.text);
    preferences.setString('designation', designationController.text);
    if(profileImage!=null){
      preferences.setString('imageUrl', profileImage);}
  }
  getData()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
     setState((){
       name=preferences.getString('name');
       phone=preferences.getString('number');
       designation=preferences.getString('designation');
     });
     nameController=TextEditingController(text: name??'');
     phoneController=TextEditingController(text: phone??'');
     designationController=TextEditingController(text: designation??'');
  }
  @override
  void initState(){
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final deviceSize=MediaQuery.of(context).size;
    return Scaffold(
     // bottomNavigationBar: bottomNavigation(context, (int i){setState((){bottomIndex = i;});}, 4),
      appBar: AppBar(elevation:0,leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).primaryColorDark,),
        onPressed: (){Navigator.of(context).pop();},),
        actions: [TextButton(onPressed: ()async{
          if(_formKey.currentState!.validate()){
          await _showDialogBox(context);
          await setData();
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const HomePage()));}
        }, child: Text('done'.tr,style: TextStyle(color: Theme.of(context).primaryColorDark),))],
        title: Text('profile'.tr,style: TextStyle(color: Theme.of(context).primaryColorDark),),automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Column(
              children: [
                SizedBox(height: deviceSize.height*0.09,),
                SizedBox(width: deviceSize.width*0.40,height: deviceSize.height*0.20,
                  child: Stack(alignment: Alignment.bottomRight,
                    children: [
                      SizedBox(width: deviceSize.width*0.40,height: deviceSize.height*0.18,
                          child:Container(
                              height: deviceSize.height/7,
                              width: deviceSize.height/7,
                              decoration: profileImage==null? BoxDecoration(border: Border.all(width:2,color: Colors.black ),
                                  shape: BoxShape.circle,
                                  image: const DecorationImage(
                                      image: AssetImage("assets/personImage.jpg") ,
                                      fit: BoxFit.fill
                                  )
                              ):BoxDecoration(border: Border.all(width:2,color: Colors.black ),
                                  shape: BoxShape.circle,
                                  image:  DecorationImage(
                                      image: FileImage(File(profileImage),scale: 10.0) ,
                                      fit: BoxFit.fill
                                  ))
                          )),
                      Padding(
                          padding:  EdgeInsets.all(deviceSize.width*0.01),
                          child: CircleAvatar(backgroundColor:Colors.grey,child:
                          IconButton(onPressed: (){bottomSheet();},icon:const Icon(Icons.add,color: Colors.black,),))
                      )
                    ],
                  ),),
                SizedBox(height: deviceSize.height*0.09,),
                profileOptions(context ,name??'','name'.tr,false, TextInputType.name,TextInputAction.next,
                    nameController,
                        (String? value) {
                      if (value!.isEmpty) {return 'nameError'.tr;}
                      else{
                        String pattern=r'(?=.*?[A-Z])(?=.*?[a-z])';
                        String newPattern=pattern.toLowerCase();
                        if(!RegExp(newPattern).hasMatch(value)){
                          return "nameError1".tr;
                        }
                      }
                      return null;
                    },(String text){
                      setState((){
                        textColor=Colors.transparent;
                        borderColor=Colors.black;
                      });
                    },Icons.person,false),
               // SizedBox(height: deviceSize.height*0.02,),
                profileOptions(context ,designation??'','designation'.tr,false, TextInputType.name,TextInputAction.next,
                    designationController,
                        (String? value) {
                      if (value!.isEmpty) {return 'designationError'.tr;}
                      return null;
                    },(String text){
                      setState((){
                        textColor=Colors.transparent;
                        borderColor=Colors.black;
                      });
                    },Icons.work,false),
                //SizedBox(height: deviceSize.height*0.02,),
                profileOptions(context,phone??'','number'.tr,true, TextInputType.number,TextInputAction.done,
                    phoneController,
                        (String? value){
                      if (value!.isEmpty) {return 'numberError'.tr;}
                      else{
                        if(value.length!=10 )
                        {return 'numberError1'.tr;}
                      }return null;
                    }, (String text){ setState((){
                      textColor=Colors.transparent;
                      borderColor=Colors.black;
                    });},Icons.phone_android_outlined,false),
                SizedBox(height: deviceSize.height*0.02,),
              ],
            ),),),));
  }

  void bottomSheet(){
    showModalBottomSheet(elevation:5,
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,backgroundColor: Colors.grey, builder: (BuildContext context){
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(height: 150,
              child: Column(
                children: [InkWell(onTap: (){Navigator.of(context).pop();getImage(source: ImageSource.camera);}, child: Text("camera".tr,
                  style:const TextStyle(color: Colors.white,fontSize: 20),),),
                  const SizedBox(height: 25,),
                  InkWell(onTap: (){Navigator.of(context).pop();permission();}, child: Text('gallery'.tr,style:
                  const TextStyle(color: Colors.white,fontSize: 20)))],
              ),
            ),
          );
        });
  }
dynamic file;
  void getImage({required ImageSource source})async{
    file=await ImagePicker().pickImage(source:source);
    if(file?.path != null){
      File? crop= ImageCropper().cropImage(
          sourcePath: file!.path,
          androidUiSettings: const AndroidUiSettings(
              toolbarTitle: "Crop",
              toolbarColor: Colors.white10,
              statusBarColor: Colors.blueGrey
          )) as File?;
      setState(() {
        profileImage=crop!.path.toString();
      });
    }
  }
void permission()async{
  final status = await Permission.storage.request();
  if (status == PermissionStatus.granted) {
    getImage(source: ImageSource.gallery);
  }
}


}
_showDialogBox(BuildContext context){
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Update'.tr),
        content: Text("profileUpdated".tr),
        actions: [
          TextButton(
            child: Center(child: Text('ok'.tr)),
            onPressed: () {Navigator.of(context).pop();},
          ),
        ],
      );
    },
  );
}
profileOptions(BuildContext context,String hintText,String labelText,bool isNumber,dynamic inputType,dynamic inputAction,TextEditingController controller,dynamic validator,dynamic onChange,IconData icon,
    bool isPassword){
  return TextFormField(
    //autovalidateMode: AutovalidateMode.onUserInteraction,
    cursorColor:Theme.of(context).primaryColorDark,
    textInputAction: inputAction,
    keyboardType: inputType,
    obscureText: isPassword,
    controller: controller,
    validator: validator,
    onChanged: onChange,
    maxLength: isNumber ? 10 :25,
    decoration: InputDecoration(prefixIcon: Icon(icon,color: Colors.grey,),
        counterStyle: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        labelText:hintText==''? labelText:'',labelStyle:  TextStyle(color: Theme.of(context).primaryColorLight),
        focusedBorder:OutlineInputBorder(borderSide: BorderSide(color: Colors.red[200]!)),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor)) ,
        //enabledBorder:OutlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
        errorMaxLines: 2,
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
        errorStyle: TextStyle(color: Theme.of(context).primaryColorLight,fontStyle: FontStyle.italic,),
        border: const OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid)),
        hintText: labelText,hintStyle:const TextStyle(color: Colors.grey)
    ),
  );
}Color textColor=Colors.grey;
Color borderColor=Colors.brown;