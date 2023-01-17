import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_selectable_text.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/policy_screen.dart';
import 'package:burgundy_budgeting_app/utils/helpers/url_launcher_helper.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyPage extends StatelessWidget {
  static const String routeName = '/privacy_policy';

  static void initRoute(FluroRouter router) {
    var handler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return PrivacyPolicyPage();
    });
    router.define(routeName, handler: handler);
  }

  @override
  Widget build(BuildContext context) {
    return PolicyScreen(
      title: AppLocalizations.of(context)!.policyHeadline,
      lastUpdate: DateTime(2021, 08, 16),
      child: CustomSelectableText(
        textData: SelectableTextData(
            text:
                'Thank you for choosing to be part of our community at Vlorish ("Company", "we", "us", "our"). We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about this privacy notice, or our practices with regards to your personal information, please contact us at '),
        childrenTextData: [
          SelectableTextData(
            text: 'legal@vlorish.com',
            type: SelectableTextType.Bold,
          ),
          SelectableTextData(
            text:
                '. When you and more generally, use any of our services (the "Services", which include the ), we appreciate that you are trusting us with your personal information. We take your privacy very seriously. In this privacy notice, we seek to explain to you in the clearest way possible what information we collect, how we use it and what rights you have in relation to it. We hope you take some time to read through it carefully, as it is important. If there are any terms in this privacy notice that you do not agree with, please discontinue use of our Services immediately. This privacy notice applies to all information collected through our Services (which, as described above, includes our ), as well as, any related services, sales, marketing or events.\n',
          ),
          SelectableTextData(
              type: SelectableTextType.Bold,
              text:
                  'Please read this privacy notice carefully as it will help you understand what we do with the information that we collect.\n'),
          SelectableTextData(
              text: '1. What information do we collect?\n',
              type: SelectableTextType.Header),
          SelectableTextData(
              text: 'Personal information you disclose to us\n',
              type: SelectableTextType.SubHeader),
          SelectableTextData(
              text:
                  'In short: We collect personal information that you provide to us.\n',
              type: SelectableTextType.Gist),
          SelectableTextData(
              text:
                  'We collect personal information that you voluntarily provide to us when you register on the express an interest in obtaining information about us or our products and Services, when you participate in activities on the (such as by posting messages in our online forums or entering competitions, contests or giveaways) or otherwise when you contact us.The personal information that we collect depends on the context of your interactions with us and the , the choices you make and the products and features you use. The personal information we collect may include the following: \nSocial Media Login Data. We may provide you with the option to register with us using your existing social media account details, like your Facebook,Twitter or other social media account. If you choose to register in this way, we will collect the information described in the section called "HOW DO WE HANDLE YOUR SOCIAL LOGINS?" below. \nAll personal information that you provide to us must be true, complete and accurate, and you must notify us of any changes to such personal information\n',
              type: SelectableTextType.General),
          SelectableTextData(
              text: 'Information automatically collected\n',
              type: SelectableTextType.SubHeader),
          SelectableTextData(
              text:
                  'In short: Some information — such as your Internet Protocol (IP) address and/or browser and device characteristics — is collected automatically when you visit our .\n',
              type: SelectableTextType.Gist),
          SelectableTextData(
              text:
                  'We automatically collect certain information when you visit, use or navigate the . This information does not reveal your specific identity (like your name or contact information) but may include device and usage information, such as your IP address, browser and device characteristics, operating system, language preferences, referring URLs, device name, country, location,information about how and when you use our and other technical information.This information is primarily needed to maintain the security and operation of our , and for our internal analytics and reporting purposes.\nLike many businesses, we also collect information through cookies and similar technologies.\n',
              type: SelectableTextType.General),
          SelectableTextData(
              text: '2. Will your information be shared with anyone?\n',
              type: SelectableTextType.Header),
          SelectableTextData(
              text:
                  'In Short: We only share information with your consent, to comply with laws, to provide you with services, to protect your rights, or to fulfill business obligations.\n',
              type: SelectableTextType.Gist),
          SelectableTextData(
              text:
                  'We may process or share your data that we hold based on the following legal basis:\nMore specifically, we may need to process your data or share your personal information in the following situations:\n',
              type: SelectableTextType.General),
          SelectableTextData(
              text: 'Business Transfers. ', type: SelectableTextType.Bold),
          SelectableTextData(
              text:
                  'We may share or transfer your information in connection with, or during negotiations of, any merger, sale of company assets, financing, or acquisition of all or a portion of our business to another company.\n',
              type: SelectableTextType.General),
          SelectableTextData(
              text: 'Affiliates. ', type: SelectableTextType.Bold),
          SelectableTextData(
              text:
                  'We may share your information with our affiliates, in which case we will require those affiliates to honor this privacy notice. Affiliates include our parent company and any subsidiaries, joint venture partners or other companies that we control or that are under common control with us.\n',
              type: SelectableTextType.General),
          SelectableTextData(
              text: 'Business Partners. ', type: SelectableTextType.Bold),
          SelectableTextData(
              text:
                  'We may share your information with our business partners to offer you certain products, services or promotions.\n',
              type: SelectableTextType.General),
          SelectableTextData(
              text: 'Other Users. ', type: SelectableTextType.Bold),
          SelectableTextData(
              text:
                  'When you share personal information or otherwise interact with public areas of the , such personal information may be viewed by all users and may be publicly made available outside the in perpetuity. If you interact with other users of our and register for our through a social network (such as Facebook), your contacts on the social network will see your name, profile photo, and descriptions of your activity. Similarly, other users will be able to view descriptions of your activity, communicate with you within our , and view your profile.\n',
              type: SelectableTextType.General),
          SelectableTextData(
              text: '3. Do we use cookies and other tracking technologies?\n',
              type: SelectableTextType.Header),
          SelectableTextData(
              text:
                  'In Short: We may use cookies and other tracking technologies to collect and store your information.\n',
              type: SelectableTextType.Gist),
          SelectableTextData(
              text:
                  'We may use cookies and similar tracking technologies (like web beacons and pixels) to access or store information. Specific information about how we use such technologies and how you can refuse certain cookies is set out in our Cookie Notice.\n'),
          SelectableTextData(
              text: '4. How do we handle your social logins?\n',
              type: SelectableTextType.Header),
          SelectableTextData(
              text:
                  'In Short: If you choose to register or log in to our services using a social media account, we may have access to certain information about you.\n',
              type: SelectableTextType.Gist),
          SelectableTextData(
              text:
                  'Our offers you the ability to register and login using your third-party social media account details (like your Facebook or Twitter logins). Where you choose to do this, we will receive certain profile information about you from your social media provider. The profile information we receive may vary depending on the social media provider concerned, but will often include your name, email address, friends list, profile picture as well as other information you choose to make public on such social media platform. \nWe will use the information we receive only for the purposes that are described in this privacy notice or that are otherwise made clear to you on  the relevant . Please note that we do not control, and are not responsible for, other uses of your personal information by your third-party social media provider. We recommend that you review their privacy notice to understand how they collect, use and share your personal information, and how you can set your privacy preferences on their sites and apps.\n'),
          SelectableTextData(
              text: '5. Is your information transferred internationally?\n',
              type: SelectableTextType.Header),
          SelectableTextData(
              text:
                  'In Short: We may transfer, store, and process your information in countries other than your own.\n',
              type: SelectableTextType.Gist),
          SelectableTextData(
            text:
                'Our servers are located in. If you are accessing our from outside, please be aware that your information may be transferred to, stored, and processed by us in our facilities and by those third parties with whom we may share your personal information (see "WILL YOUR INFORMATION BE SHARED WITH ANYONE?" above), in and other countries. \nIf you are a resident in the European Economic Area (EEA) or United Kingdom (UK), then these countries may not necessarily have data protection laws or other similar laws as comprehensive as those in your country. We will however take all necessary measures to protect your personal information in accordance with this privacy notice and applicable law.\n',
          ),
          SelectableTextData(
              text: '6. How long do we keep your information?\n',
              type: SelectableTextType.Header),
          SelectableTextData(
              text:
                  'In Short: We keep your information for as long as necessary to fulfill the purposes outlined in this privacy notice unless otherwise required by law.\n',
              type: SelectableTextType.Gist),
          SelectableTextData(
            text:
                'We will only keep your personal information for as long as it is necessary for the purposes set out in this privacy notice, unless a longer retention period is required or permitted by law (such as tax, accounting or other legal requirements). No purpose in this notice will require us keeping your personal information for longer than 6 months. \nWhen we have no ongoing legitimate business need to process your personal information, we will either delete or anonymize such information, or, if this is not possible (for example, because your personal information has been stored in backup archives), then we will securely store your personal information and isolate it from any further processing until deletion is possible.\n',
          ),
          SelectableTextData(
              text: '7. Do we collect information from minors?\n',
              type: SelectableTextType.Header),
          SelectableTextData(
              text:
                  'In Short: We do not knowingly collect data from or market to children under 18 years of age.\n',
              type: SelectableTextType.Gist),
          SelectableTextData(
            text:
                'We do not knowingly solicit data from or market to children under 18 years of age. By using the , you represent that you are at least 18 or that you are the parent or guardian of such a minor and consent to such minor dependent’s use of the . If we learn that personal information from users less than 18 years of age has been collected, we will deactivate the account and take reasonable measures to promptly delete such data from our records. If you become aware of any data we may have collected from children under age 18, please contact us at ',
          ),
          SelectableTextData(
            text: 'legal@vlorish.com\n',
            type: SelectableTextType.Bold,
          ),
          SelectableTextData(
              text: '8. What are your privacy rights?\n',
              type: SelectableTextType.Header),
          SelectableTextData(
              text:
                  'In Short: You may review, change, or terminate your account at any time. \n',
              type: SelectableTextType.Gist),
          SelectableTextData(
            text:
                'If you are a resident in the EEA or UK and you believe we are unlawfully processing your personal information, you also have the right to complain to your local data protection supervisory authority.\nYou can find their contact details here: ',
          ),
          SelectableTextData(
            text:
                'http://ec.europa.eu/justice/data-protection/bodies/authorities/index_en.htm\n',
            type: SelectableTextType.Link,
            onTap: () {
              openUrl(
                url:
                    'http://ec.europa.eu/justice/data-protection/bodies/authorities/index_en.htm',
                launchInThisTab: false,
                exceptionMessage: AppLocalizations.of(context)!.couldNotOpenUrl,
              );
            },
          ),
          SelectableTextData(
            text:
                'If you are a resident in Switzerland, the contact details for the data protection authorities are available here: ',
          ),
          SelectableTextData(
            text: 'https://www.edoeb.admin.ch/edoeb/en/home.html\n',
            type: SelectableTextType.Link,
            onTap: () {
              openUrl(
                url: 'https://www.edoeb.admin.ch/edoeb/en/home.html',
                launchInThisTab: false,
                exceptionMessage: AppLocalizations.of(context)!.couldNotOpenUrl,
              );
            },
          ),
          SelectableTextData(
              text: 'Account Information\n',
              type: SelectableTextType.SubHeader),
          SelectableTextData(
            text:
                'If you would at any time like to review or change the information in your account or terminate your account, you can: Upon your request to terminate your account, we will deactivate or delete your account and information from our active databases. However, we may retain some information in our files to prevent fraud, troubleshoot problems, assist with any investigations, enforce our Terms of Use and/or comply with applicable legal requirements.\n',
          ),
          SelectableTextData(
              text: 'Opting out of email marketing: ',
              type: SelectableTextType.Bold),
          SelectableTextData(
            text:
                'You can unsubscribe from our marketing email list at any time by clicking on the unsubscribe link in the emails that we send or by contacting us using the details provided below. You will then be removed from the marketing email list — however, we may still communicate with you, for example to send you service-related emails that are necessary for the administration and use of your account, to respond to service requests, or for other non-marketing purposes. To otherwise opt-out, you may:\n',
          ),
          SelectableTextData(
              text: '9. Controls for do-not-track features\n',
              type: SelectableTextType.Header),
          SelectableTextData(
            text:
                'Most web browsers and some mobile operating systems and mobile applications include a Do-Not-Track ("DNT") feature or setting you can activate to signal your privacy preference not to have data about your online browsing activities monitored and collected. At this stage no uniform technology standard for recognizing and implementing DNT signals has been finalized. As such, we do not currently respond to DNT browser signals or any other mechanism that automatically communicates your choice not to be tracked online. If a standard for online tracking is adopted that we must follow in the future, we will inform you about that practice in a revised version of this privacy notice.\n',
          ),
          SelectableTextData(
              text:
                  '10. Do California residents have specific privacy rights?\n',
              type: SelectableTextType.Header),
          SelectableTextData(
              text:
                  'In Short: Yes, if you are a resident of California, you are granted specific rights regarding access to your personal information.\n',
              type: SelectableTextType.Gist),
          SelectableTextData(
            text:
                'California Civil Code Section 1798.83, also known as the "Shine The Light" law, permits our users who are California residents to request and obtain from us, once a year and free of charge, information about categories of personal information (if any) we disclosed to third parties for direct marketing purposes and the names and addresses of all third parties with which we shared personal information in the immediately preceding calendar year. If you are a California resident and would like to make such a request, please submit your request in writing to us using the contact information provided below. \nIf you are under 18 years of age, reside in California, and have a registered account with , you have the right to request removal of unwanted data that you publicly post on the . To request removal of such data, please contact us using the contact information provided below, and include the email address associated with your account and a statement that you reside in California. We will make sure the data is not publicly displayed on the , but please be aware that the data may not be completely or comprehensively removed from all our systems (e.g. backups, etc.).\n',
          ),
          SelectableTextData(
              text: '11. Do we make updates to this notice?\n',
              type: SelectableTextType.Header),
          SelectableTextData(
              text:
                  'In Short: Yes, we will update this notice as necessary to stay compliant with relevant laws.\n',
              type: SelectableTextType.Gist),
          SelectableTextData(
            text:
                'We may update this privacy notice from time to time. The updated version will be indicated by an updated "Revised" date and the updated version will be effective as soon as it is accessible. If we make material changes to this privacy notice, we may notify you either by prominently posting a notice of such changes or by directly sending you a notification. We encourage you to review this privacy notice frequently to be informed of how we are protecting your information.\n',
          ),
          SelectableTextData(
              text: '12. How can you contact us about this notice?\n',
              type: SelectableTextType.Header),
          SelectableTextData(
            text:
                'If you have questions or comments about this notice, you may email us at ',
          ),
          SelectableTextData(
            text: 'legal@vlorish.com',
            type: SelectableTextType.Bold,
          ),
          SelectableTextData(
            text:
                ' or by post to:\n6385 Old Shady Oak Rd, Eden Prairie, MN 55344\n',
          ),
          //
          SelectableTextData(
              text:
                  '13. How can you review, update, or delete the data we collect from you?\n',
              type: SelectableTextType.Header),
          SelectableTextData(
              text:
                  'Based on the applicable laws of your country, you may have the right to request access to the personal information we collect from you, change that information, or delete it in some circumstances. To request to review, update, or delete your personal information, please submit a request form by clicking here.\n'),
        ],
      ),
    );
  }
}
