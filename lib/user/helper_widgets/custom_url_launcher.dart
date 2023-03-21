import 'package:url_launcher/url_launcher.dart';

customLaunchUrl() async {
  dynamic uri = Uri.parse("https://www.wedigtech.com/privacy-policy");
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
// print("can't launch");
  }
}
