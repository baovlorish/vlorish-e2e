import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_selectable_text.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/policy_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

class TermsReferralPage extends StatelessWidget {
  static const String routeName = '/terms_referral';

  static void initRoute(FluroRouter router) {
    var handler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return TermsReferralPage();
    });
    router.define(routeName, handler: handler);
  }

  @override
  Widget build(BuildContext context) {
    return PolicyScreen(
      title: 'Vlorish Referral Program Terms and Conditions',
      lastUpdate: DateTime(2021, 10, 11),
      child: CustomSelectableText(
        textData: SelectableTextData(
          text: 'Vlorish ',
          type: SelectableTextType.Bold,
        ),
        childrenTextData: [
          SelectableTextData(
            text:
                '("we," "us" the "Company") offers you the opportunity to earn rewards by referring your peers to our company, where they can subsequently sign up for one of our existing plans, including but not limited to: Personal budget plan, Freelance/Self-employed Plan, Advisor plan. Your participation in the Vlorish Referral Program will earn you cash rewards. We reserve the right to terminate the Program at any time for any reason without notice.\n'          ),
          SelectableTextData(
            text: 'These terms ("Terms") apply to your participation in the Program. By participating in the Program, you agree to use the Program as outlined herein, and consistent with any other terms we may apply to the Program. If you do not agree to these Terms in their entirety, then you cannot register and participate in the Program. Users also cannot where in so doing, they would violate any applicable law or regulations.\n',

          ),
          SelectableTextData(
            text: 'Eligibility\n',
            type: SelectableTextType.Header,
          ),
          SelectableTextData(
            text: 'This Program is void where such referral programs are prohibited. Users who refer others to the program are "Referrers"; those who are referred are "Referred Customers." Referrers are eligible to receive "cash rewards" for every qualified referral. Referrers must be 1) at least18 years of age, 2) have a valid Vlorish account, 3) are otherwise in good standing. Vlorish reserves the right to determine if a Referrer\'s user account is valid based on criteria that includes, but is not limited to, account activity and ownership, subscription payment status. Participation in the Program represents an ongoing relationship with you, for privacy purposes. So long as you remain in the Program, and you have an unpaid referral bonus, you will be considered an active member of the Program and of the Vlorish Community.\n',
          ),
          SelectableTextData(
            text: 'How It Works\n',
            type: SelectableTextType.Header,
          ),
          SelectableTextData(
            text: 'To participate, once you have created your Vlorish account, click on the referral button at the top of the page (upbar). Your referral page data includes a unique “link” that you can copy to share with your friends, family, audiences, peers, community or affiliates. You cans hare your link as much as you want. If a user uses your personal link and signs up for any Vlorish plan, you will receive a cash reward worth ',
          ),
          SelectableTextData(
            text: '10% of the referred customers’ first payment. ',
            type: SelectableTextType.Bold,
          ),
          SelectableTextData(
            text: 'For example, if you refer user “A”, and he/she signs up for a subscription plan at \$20/month, you will receive a cash reward bonus of \$2 (10% x \$20). Alternatively, if a referred customer opts for the “annual” plan at the standard 20% annual discount, their first payment will be \$192 (\$20 x 12 x .8) and your cash bonus will be \$19.20 (10% x \$192). Referral bonus is paid ONLY EARNED AND PAID on the initial/first customer payment regardless of whether the referred customer chooses a monthly or an annual plan. There is no limit on the number of referrals you can earn each year.\n',
          ),
          SelectableTextData(
            text: 'Your referral page inside Vlorish shows you your referral history - Total referral bonus earned, total paid, and amount still unpaid. You can click “Check Portal” to access your portal where you need to add your Paypal account for receiving the referral cash rewards. Our Company currently only accepts Paypal accounts for receiving cash.\n',
           ),
          SelectableTextData(
            text: 'Vlorish automatically pays referral bonuses 30-days after the referred customer signs up for a plan. On the 31st day, the cash is automatically paid to your designated Paypal Account. Before receiving any cash payments, however, you must add a Paypal account to your Rewardful portal (Click Check Portal to create password for your portal and add your Paypal account).\n',
          ),
          SelectableTextData(
            text: 'Partnerships and Affiliates \n',
            type: SelectableTextType.Header,
          ),
          SelectableTextData(
            text: 'Vlorish may offer Referrers a special promotion ("Partnership or Affiliate Program), and special link - a separate Partnership/Affiliate Referral Link to use. These Special Promotions are invite-only. Such Special Promotions are for a limited time and will give Referrers in the special affiliate/partnership program additional cash rewards. Additional terms, including expiration dates for any Special Promotion will be provided with the Special Promotion Agreement. During Special Promotions, Referrers may use either their Personal Referral Link where they earn a standard 10% bonus referral cash reward or their Special Affiliate/Partnership Link to receive a higher referral bonus rate. The cash reward will be based upon the specific link used by the referred customer. Special Partnership/Affiliate bonus rates are based on negotiated and agreed upon special rates between Vlorish and referring partner/affiliate. Special promotion participants must have a reputable platform with a significant user/client base and the potential to refer a high number of users each year. If you would like to be considered for special partnership, please send us your proposal at ',
          ),
          SelectableTextData(
            text: 'Affiliates@vlorish.com',
            type: SelectableTextType.Link,
          ),
          SelectableTextData(
            text: '. Vlorish reserves the right to accept or reject any such proposal with or without notice. \n',
          ),
          SelectableTextData(
            text: 'Qualified Referrals \n',
            type: SelectableTextType.Header,
          ),
          SelectableTextData(
            text: 'Referrers must respect the spirit of the Program by not engaging in spamming or other unfair or otherwise problematic practices, including creating fake accounts or harassing potential referral sources. Self-dealing is also prohibited and can be grounds for termination from the program. \n',
          ),
          SelectableTextData(
            text: 'Referral Bonus Payments \n',
            type: SelectableTextType.Header,
          ),
          SelectableTextData(
            text: 'Referral bonuses in the form of cash payments are subject to verification and will generally be awarded within 30 days of verification but might take up to 60 days where additional verification becomes necessary. Vlorish Entities may withhold a cash referral payout if it reasonably believes additional verification is required. Vlorish may also withhold or invalidate any potential it deems fraudulent, suspect, or in violation of these Terms. If Vlorish in its sole discretion believes awarding a Cash reward or verifying and approving a transaction will impose liability on Vlorish, its subsidiaries, affiliates or any of their respective officers, directors, employees, representatives and agents.\nAll Vlorish Entities\' decisions are final and binding, except where prohibited, including decisions as to whether a Qualified Referral, or cash reward is valid, when and if to terminate the Program, and whether, if at all, to change the program. Any changes to the program will be sent via email to registered Referrer\'s and, except where prohibited, will become effective as of the date the email is sent. If a Referrer has referrals pending qualification at the time that updates are sent, those pending referrals shall be validated and cash reward given under the terms that were valid at the time the Referred Customer signed up for a subscription plan.\n',
          ),
          SelectableTextData(
            text: 'Termination of Program or Referrer’s Account \n',
            type: SelectableTextType.Header,
          ),
          SelectableTextData(
            text: 'If a Referrer\’s account is canceled for any reason by Vlorish including fraud and any other reason, unpaid cash reward bonuses are forfeited immediately. If Referrer\’s account is suspended for any reason, such as spamming or violation of Vlorish policy, any unpaid cash is forfeited immediately. If the Program is terminated by Vlorish, any outstanding or unpaid cash will be paid within 30-60 days from the date of program termination.\n',
          ),
          SelectableTextData(
            text: '10% of the referred customers’ first payment. \n',
            type: SelectableTextType.Header,
          ),
          SelectableTextData(
            text: 'Liability Release \n',
            type: SelectableTextType.Header,
          ),
          SelectableTextData(
            text: 'Except where prohibited, Users agree that by participating in the Program, they agree: (1) to be bound by these Terms the decisions of Vlorish and its Entities (if any) and/or their designees, and privacy policies; (2) to release and hold harmless Vlorish Entities and their respective parent companies, affiliates and subsidiaries, together with their respective employees, directors, officers, licensees, licensors, shareholders, attorneys and agents including, without limitation, their respective advertising and promotion entities and any person or entity associated with the production, operation or administration of the Program (collectively, the "Released Parties"), from any and all claims, demands, damages, losses, liabilities, costs or expenses caused by, arising out of, in connection with, or related to their participation in the Program (including, without limitation, any property loss, damage, personal injury or death caused to any person(s) and/or the awarding, receipt and/or use or misuse of the Program or any Cash Credit); and (3) to be contacted by Vlorish Entities via email.\n',
                      ),
          SelectableTextData(
            text: 'Except where prohibited by law, the Released Parties shall not be liable for: (i) late, lost, delayed, stolen, misdirected, incomplete unreadable, inaccurate, garbled or unintelligible entries, communications or affidavits, regardless of the method of transmission; (ii) telephone system, telephone or computer hardware, software or other technical or computer malfunctions, lost connections, disconnections, delays or transmission errors; (iii) data corruption, theft, destruction, unauthorized access to or alteration of entry or other materials; (iv) any injuries, losses or damages of any kind resulting from acceptance, possession or use of a Cash Credit, or from participation in the Program; or (v) any printing, typographical, administrative or technological errors in any websites or materials associated with the Program. Vlorish Entities disclaim any liability for damage to any computer system resulting from participating in, or accessing or downloading information in connection with this Program, and reserve the right, in their sole discretion, to cancel, modify or suspend the Program should a virus, bug, computer problem, unauthorized intervention or other causes beyond Vlorish Entities control, corrupt the administration, security or proper play of the Program. \n',
          ),
          SelectableTextData(
            text: 'Except where prohibited, the Released Parties shall not be liable to any Users for failure to supply any Cash Credit or any part thereof, by reason of any acts of God, any action(s), regulation(s), order(s) or request(s) by any governmental or quasi-governmental entity (whether or not the action(s), regulations(s), order(s) or request(s) prove(s) to be invalid), equipment failure, threatened terrorist acts, terrorist acts, air raid, blackout, act of public enemy, earthquake, tornado, tsunami, war (declared or undeclared), fire, flood, epidemic, explosion, unusually severe weather, hurricane, embargo, labor dispute or strike (whether legal or illegal), labor or material shortage, transportation interruption of any kind, work slow-down, civil disturbance, insurrection, riot, or any other similar or dissimilar cause beyond any of the Released Parties\’ control.\n',
          ),
          SelectableTextData(
            text: 'As a condition of entering the Program, and unless prohibited by law, Users agree that under no circumstances will Users be entitled to any awards for any losses or damages, and Users hereby waive all rights to claim punitive, incidental, consequential and any other damages, and waives any and all rights to have damages multiplied or otherwise increased. A waiver of rights may not apply to you in your jurisdiction of residence. Additional rights may be available to you.\nVlorish Entities reserves the right to cancel or suspend this Program should it determine, in its sole discretion, that the administration, security or fairness of this Program has been compromised in any way. \n',
          ),
          SelectableTextData(
            text: 'Applicable Law \n',
            type: SelectableTextType.Header,
          ),
          SelectableTextData(
            text: 'Except where prohibited, disputes, claims and causes of action arising out of or related to this Program or any prize awarded shall be resolved under the laws of the United States, and except where prohibited, Minnesota law (without reference to its conflicts of laws principles), and participant agrees to submit any dispute to the exclusive jurisdiction of the state and federal courts located in Minneapolis, Minnesota. \n',
          ),
          SelectableTextData(
            text: 'Referrer\’s Code of Conduct \n',
            type: SelectableTextType.Header,
          ),
          SelectableTextData(
            text: 'Referrer\’s agree that they will not violate any of these Terms, or otherwise engage in activity that could be considered harassment toward other users. Users agree not to use the Program to: \n',
            ),
          SelectableTextData(
            text: '   ●   Violate the intellectual property rights of Vlorish\n   ●   Spam or otherwise create bulk email/text distributions of the Personal Link or the Personal Bonus Link that is inappropriate\n   ●   Collect or attempting to collect personal data about users or potential Referred Customers\n   ●   Engage in any actions that are designed to disrupt or undermine the Program\n   ●   Make attempts to gain unauthorized access to the software or the Program for any reason\n   ●   Transmit files that contain bots, viruses, works, Trojan horses, or any other file that could contaminate or otherwise destroy Vlorish intellectual property or stop the function of the Vlorish services\n   ●   Engage in illegal or unsportsmanlike activities\n   ●   Engage in behavior designed to annoy or harass others\n   ●   Engage in actions that disparage or malign or call into question the reputation of Vlorish, in Vlorish\’s sole discretion\n',
          ),
          SelectableTextData(
            text: 'Inappropriate Behavior \n',
            type: SelectableTextType.Header,
          ),
          SelectableTextData(
            text: 'The Vlorish Entities may prohibit anyone from participating in the Program or receiving a if they determine such User is attempting to undermine the fairness, integrity or legitimate operation of the Program in any way by cheating, hacking, deception, or any other unfair playing practices of intending to annoy, abuse, threaten or harass any other Vlorish users (whether or not enrolled in the Program), or representatives of Vlorish Entities. Use of any automated system to participate is strictly prohibited, and if discovered, and will result in disqualification. Vlorish reserves the right to disqualify anyone, cancel cash credits, disable or suspect an account, and contact legal authorities (including law enforcement), if it should discover a user is tampering with the entry or referral process or the operation of the Program or violating these Terms. Referrals generated by a script, macro or other automated means will be disqualified. If a solution cannot be found to restore the integrity of the Program, we reserve the right to cancel, change, or suspend the Program. \n',
          ),
          SelectableTextData(
            text: 'Privacy \n',
            type: SelectableTextType.Header,
          ),
          SelectableTextData(
            text: 'Participation in the Program may require a Referred Customer and/or a Referrer to submit personal information about themselves. The personal information is strictly safeguarded in accordance with Vlorish\’s Privacy Policy. Each referrer agrees to keep confidential 1) Any information pertaining to referred customers including names, if known to the referrer, of the referred customer/client 2) Information or agreements between Vlorish and referrer. \n',
          ),
          SelectableTextData(
            text: 'Reservations of Rights \n',
            type: SelectableTextType.Header,
          ),
          SelectableTextData(
            text: 'We reserve the right to modify or amend at any time these Terms and the methods through which Cash Credits are earned. We reserve the right to disqualify any User at any time from participation in the Program if he/she does not comply with any of these Terms. Vlorish Entities\’ failure to enforce any term of these Terms shall not constitute a waiver of that provision.\nCaution: any attempt to deliberately damage or undermine the legitimate operation of the program may be in violation of criminal and civil laws and will result in disqualification from participation in the program. should such an attempt be made, program entities reserve the right to seek remedies and damages (including attorney fees) to the fullest extent of the law, including criminal prosecution\n',
          ),
        ],
      ),
    );
  }
}
