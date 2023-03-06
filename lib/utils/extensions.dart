import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension NumericFormatString on num {
  String numericFormattedString() {
    var reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    var matchFunc = (Match match) => '${match[1]},';
    return toStringAsFixed(0).replaceAllMapped(reg, matchFunc);
  }

  String formattedWithDecorativeElementsString({bool withCents = false}) {
    var numeric = '\$${numericFormattedString()}';
    return withCents ? '$numeric.00' : numeric;
  }
}

extension NumericFormatStringOnDouble on double {
  String formattedWithDecorativeElementsString() {
    var reg = RegExp(r'/(\d)(?=(?:\d{3})+(?:\.|$))|(\.\d\d?)\d*$/g');
    var matchFunc = (Match match) => '${match[1]},';
    var numeric = toStringAsFixed(2).replaceAllMapped(reg, matchFunc);
    return isNegative ? numeric : '+$numeric';
  }
}

extension ExtendedString on String {
  /// The string without any whitespace.
  String removeAllWhitespace() {
    // Remove all white space.
    return replaceAll(RegExp(r'\s+'), '');
  }

  // Capitalize first letter of a string
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

extension LocalizationMapping on String {
  String nameLocalization(BuildContext context) {
    var name = {
      '938beaea-4e0a-458a-a6d2-27ed1e5b1de3':
          AppLocalizations.of(context)!.income,

      '144eee9e-000e-4208-916f-339b16e96005':
          AppLocalizations.of(context)!.salaryPaycheck,

      '5eb95029-61ef-4178-82ba-7269e61f4e2c':
          AppLocalizations.of(context)!.ownerDraw,

      'c33509fd-b30a-417d-b00c-dc5fd07fb031':
          AppLocalizations.of(context)!.rentalIncome,

      '5243d6cf-2ee4-4022-916f-66ffe9dace2a':
          AppLocalizations.of(context)!.dividendIncome,

      '25d44c51-8ae8-4999-ace9-7dcc228b525e':
          AppLocalizations.of(context)!.investmentIncome,

      '5acbff26-a546-4e4a-bfd9-6fbf4df3e0ed':
          AppLocalizations.of(context)!.retirementIncome,

      'baf5e5c1-54e1-474b-b554-00915f6df107':
          AppLocalizations.of(context)!.otherIncome,

      '0f4e6f8c-9ec5-4479-b8fa-9cf31c7a5498':
          AppLocalizations.of(context)!.loanReceived,

      'f6ed2cd2-cd3b-42f4-8861-fe5627026200':
          AppLocalizations.of(context)!.unbudgetedIncome,

      '1585cb86-d344-417d-b3b8-af841b5f47ef':
          AppLocalizations.of(context)!.businessIncome,

      '070b7df2-3c54-465f-b5a3-2de0a6b2649f':
          AppLocalizations.of(context)!.otherIncome,

      '8fd40d28-6830-4093-b34d-e5668916e537':
          AppLocalizations.of(context)!.loanReceived,

      '6a98dc8c-d514-4083-ac1d-0b4b5ee791cb':
          AppLocalizations.of(context)!.investmentInBusiness,

      'bd473fea-ff7a-4e0f-8d9d-2bbd9fc835f7':
          AppLocalizations.of(context)!.unbudgetedIncome,

      'e538cd67-9d54-48da-9a88-2bd111019885':
          AppLocalizations.of(context)!.housing,
      '3b2a607a-9fc1-43f4-886b-676c2ed00f25':
          AppLocalizations.of(context)!.mortgage,
      '3ba09a05-8d03-47b0-9cc3-2b9135f24ca6':
          AppLocalizations.of(context)!.rent,
      'f38e0ddb-cfb7-45af-97fc-24cd7c43799d':
          AppLocalizations.of(context)!.utilities,
      'c5142c9b-8fa1-4e5c-8e24-24f64af78c75':
          AppLocalizations.of(context)!.homeRepairs,
      '5826836c-a1fe-4015-bed9-241b683f7b10':
          AppLocalizations.of(context)!.homeServices,
      'd23427c2-79e8-4ef4-ba6c-54190e107eff':
          AppLocalizations.of(context)!.debtPayments,
      'a5c48559-93d7-4693-84bc-4a07938d8f0c':
          AppLocalizations.of(context)!.creditCards,
      '58ecc507-5b64-4619-ac99-79830742dcbb':
          AppLocalizations.of(context)!.studentLoans,
      '59909b73-f83d-4476-9814-df5d2deef7dd':
          AppLocalizations.of(context)!.autoLoans,
      '55d6d875-b6ec-4959-9c79-dc16076871d8':
          AppLocalizations.of(context)!.backTaxes,
      '38696ad1-96d4-4f3e-9521-4cbb0b1dbd45':
          AppLocalizations.of(context)!.medicalBills,
      '50017583-1ada-4cbc-9a80-433a34018dcc':
          AppLocalizations.of(context)!.personalLoan,
      '012f8645-b1ae-4600-9f5b-370bc825d108': 'Interest Expense',
      '34f613f4-900b-4b2f-969f-b2fa0eb812a5':
          AppLocalizations.of(context)!.alimony,
      '96c4d1bf-0af7-43e4-b2c0-da84ce815db4':
          AppLocalizations.of(context)!.transportation,
      '954d162e-7261-45fa-a33f-ce60c3d62611': AppLocalizations.of(context)!.gas,
      '73188218-e06e-434a-be17-507baa65b725':
          AppLocalizations.of(context)!.autoInsurance,
      '0601c9c2-9022-4499-b9e9-5b9a79cf3aa5':
          AppLocalizations.of(context)!.uber,
      '64a2079a-62f1-462d-ad3e-f0582039b78d':
          AppLocalizations.of(context)!.publicTransportation,
      '9f595d8e-9dd8-444a-8d2b-ee256f23407a':
          AppLocalizations.of(context)!.autoRepairs,
      'e851df7a-f2e3-4b63-b00a-b27f84a63eda':
          AppLocalizations.of(context)!.otherAutoExpenses,
      '35bcd407-36bb-4dc3-94b4-6ef7fcb8f23d':
          AppLocalizations.of(context)!.livingExpenses,
      'c1e1732d-1e26-46a1-ab43-59f4542c8e8e':
          AppLocalizations.of(context)!.groceries,
      '45b06cd4-706d-46b6-9ca8-abf798eb146c':
          AppLocalizations.of(context)!.clothing,
      '46ca790d-1d4d-412e-8faa-164629cc324e':
          AppLocalizations.of(context)!.phoneBill,
      '0fc0c148-2ca2-4d62-87f4-c439985e8ab9':
          AppLocalizations.of(context)!.internet,
      'ecebb3b9-81e4-4e1a-8a5f-f4c06547cab2':
          AppLocalizations.of(context)!.householdBasics,
      'ff296508-c706-499d-b3ec-610bd903a0df':
          AppLocalizations.of(context)!.healthInsurance,
      '32c852e8-decc-4665-bbdf-bae2d169dce0':
          AppLocalizations.of(context)!.medical,
      'a80c75a9-d35d-430d-a508-d227af30b434':
          AppLocalizations.of(context)!.petExpenses,
      'a2107dc3-303a-453f-ac77-3bad360e9043':
          AppLocalizations.of(context)!.lifestyleExpenses,
      '261eac57-d0e0-47b5-b244-8ca4ab4f02c8':
          AppLocalizations.of(context)!.vacation,
      'c04be0e6-d55a-41dc-8ace-29faccfb56d3':
          AppLocalizations.of(context)!.recreation,
      '8a33fabc-88a5-41ea-aebb-747b5dcdaffe':
          AppLocalizations.of(context)!.coffeeEatingout,
      'ad410412-4f2e-4112-9967-9149a5bac978':
          AppLocalizations.of(context)!.dryCleaning,
      '74421a1e-d71b-4267-8d97-9a0cdea4c9a3':
          AppLocalizations.of(context)!.homeDecor,
      '8a47686b-52e4-4994-9865-25bcc1467d0a':
          AppLocalizations.of(context)!.houseHelp,
      '040e5c08-95f6-4e61-94ef-36e353961f5b':
          AppLocalizations.of(context)!.personalCare,
      '27079efb-eb02-4b33-957f-f5e0fd31114d':
          AppLocalizations.of(context)!.personalDevelopment,
      '54c69bdf-9610-4d3a-81e7-bcd1464bed45':
          AppLocalizations.of(context)!.professionalServices,
      '8b48b1eb-9f6b-4fd6-9ba6-59d34e84d104':
          AppLocalizations.of(context)!.electiveInsurances,
      '4283fdf7-f01d-474b-8d05-4560fbcaf5f9':
          AppLocalizations.of(context)!.leisureShopping,
      'b79220bf-b32c-4525-8f25-e76a7f437b70':
          AppLocalizations.of(context)!.kids,
      '318bcbfd-c7ed-412c-8700-f15372d2c26f':
          AppLocalizations.of(context)!.childCare,
      'de8a6670-b82d-4339-bf8b-3a4898c41e11':
          AppLocalizations.of(context)!.babyNecessities,
      'b279ff3e-ed9f-4da6-8c3f-d66700d79d8f':
          AppLocalizations.of(context)!.privateSchoolTuition,
      '8da6e1a7-730a-40ad-b961-b86b181aa8a8':
          AppLocalizations.of(context)!.schoolSupplies,
      'f8a04f7c-1cca-4f38-882a-e1e33bc82ac6':
          AppLocalizations.of(context)!.schoolLunches,
      '9ad83c4b-35bc-42f0-96d2-187d1846adb6':
          AppLocalizations.of(context)!.tutoring,
      '5b273ae8-f482-4f82-b991-1eefa0b9c389':
          AppLocalizations.of(context)!.activities,
      '6eddc02e-357a-4da3-bf15-413d8a07f7b4':
          AppLocalizations.of(context)!.kidsShopping,
      '89b76056-59ff-4e8f-a9c6-c6a410317d9a':
          AppLocalizations.of(context)!.toys,
      'f4c4b576-1e13-4480-81c2-554940122ced':
          AppLocalizations.of(context)!.allowance,
      'ef076943-2907-427b-b46e-9b3cbaa697ec':
          AppLocalizations.of(context)!.childSupport,
      '9f4ff496-a4f1-4478-af6b-f7c22525c38f':
          AppLocalizations.of(context)!.giving,
      'acc36dd2-eb6d-4b9a-9d99-535b7e99754b':
          AppLocalizations.of(context)!.familySupport,
      '16c037cf-4e67-4c70-97fd-761d91aa0c08':
          AppLocalizations.of(context)!.donation,
      '2aae342b-aa7b-45cf-90ab-814e97ddba65':
          AppLocalizations.of(context)!.gifts,
      'a343ad1c-4f0f-411c-a46c-46466d214cd8':
          AppLocalizations.of(context)!.taxes,
      'b10141c2-10bd-448c-af0a-49ba4b86a6f3':
          AppLocalizations.of(context)!.federalIncomeTax,
      'f8b91929-3b59-44cf-9b29-f504206f78a8':
          AppLocalizations.of(context)!.stateIncomeTax,
      '941435d2-313b-4a99-b62c-e17fc9d52d4e':
          AppLocalizations.of(context)!.otherExpences,
      '8bd3911e-93dc-45a3-a55b-cba281ce7db9':
          AppLocalizations.of(context)!.miscExpenses,
      '2a3c8f8d-7401-466b-a8ec-e6f5bfe75870':
          AppLocalizations.of(context)!.unbudgettedExpenses,
      '5305617c-0bd4-4dd7-8a05-b4202ccf4297':
          AppLocalizations.of(context)!.otherExpences,
      '01a1ae66-671e-4263-8d95-744e36b64a06':
          AppLocalizations.of(context)!.miscExpenses,
      '824e6410-7355-4152-bacf-ddb615648758':
          AppLocalizations.of(context)!.unbudgettedExpenses,
      'e0fee339-ec7e-495d-aaa9-edbc3fa7aa09':
          AppLocalizations.of(context)!.goalsSinkingFunds,

      'ef6691dd-397f-4b73-834a-0d25d966dfdc':
          AppLocalizations.of(context)!.investments,

      '9c4bbdc3-3ce8-45d9-a687-d7d4cf3e7587':
          AppLocalizations.of(context)!.stocks,
      '6e377593-266a-48ee-be44-1d49e264ad27':
          AppLocalizations.of(context)!.realEstate,
      '1a16bd8f-f4c2-41be-af95-7dace32a075f':
          AppLocalizations.of(context)!.cryptocurrency,
      '2be2d7ff-aaac-4e70-8741-a432e27f108b':
          AppLocalizations.of(context)!.startupInvestments,
      '91cc20b1-705f-4332-97f9-c58cf28570f2':
          AppLocalizations.of(context)!.angelInvestments,
      '29727dcd-c859-41a5-99e1-0317c4f39bd9':
          AppLocalizations.of(context)!.ventureCapital,
      '3f428bad-3429-4bd3-8cb0-00926c503e91':
          AppLocalizations.of(context)!.businessInterest,
      '16b7de8e-b843-42a7-8e05-3b6a9685b68d':
          AppLocalizations.of(context)!.retirementAssets,
      '9dc0c957-82d4-4932-a0e3-8ce9f302cea1':
          AppLocalizations.of(context)!.goldAndOtherMetals,
      '8f0eae98-a329-4216-bade-9b7eb855004c':
          AppLocalizations.of(context)!.digitalAssets,
      '6eff723e-8b94-44f9-824e-1eea5ae6a550':
          AppLocalizations.of(context)!.otherInvestments,

      '0d4cf5cc-4d0f-4bde-9e71-7fedd9fae0c2':
          AppLocalizations.of(context)!.income,
      '40693474-d071-4341-9b50-a9cd4f312756':
          AppLocalizations.of(context)!.professionalServices,
      'd0c81068-5dc8-4eaf-a2bd-9d93650b5867':
          AppLocalizations.of(context)!.productCosts,
      '9549bdb2-44d8-4bb6-b919-73aac505d6ee':
          AppLocalizations.of(context)!.personnelCosts,
      'c5308fd7-bbe4-4bb6-8eca-56d58385dd96':
          AppLocalizations.of(context)!.brandDevelopment,
      '610289d1-6eb0-4474-8257-1bf552f97d09':
          AppLocalizations.of(context)!.officeExpenses,
      '8389d836-1fa4-49b5-b959-cbd3013a6b71':
          AppLocalizations.of(context)!.generalExpenses,
      'a6050bc7-7fd5-4186-bbb2-66ba5f25888d':
          AppLocalizations.of(context)!.debts,
      '2aa66aa9-b709-4787-987f-c870ee79dd4e':
          AppLocalizations.of(context)!.ownerDraw,
      'b41f6835-ebc0-4109-800f-0566e7d10a20':
          AppLocalizations.of(context)!.ownerDraw,
      '8299485d-8756-4254-84ad-db01995dcbf7':
          AppLocalizations.of(context)!.ownerPay, //Owner pay
      'e58b0a66-7a48-48be-8125-0722b8359cdc':
          AppLocalizations.of(context)!.staffSalaries, //Staff salaries
      'b0a3bee7-dc09-4871-82a8-2607b55ba6fc':
          AppLocalizations.of(context)!.employeeBenefits, //Employee benefits
      'eba85dad-5eb3-4cbd-bd3d-57cda7cc7e29':
          AppLocalizations.of(context)!.payrollTaxes, //Payroll taxes

      'ceb3f98d-0027-4f11-8059-1489ce655e65':
          AppLocalizations.of(context)!.accounting, //Accounting
      'e76c2829-4541-4f66-95d1-8a3dd17e78f9':
          AppLocalizations.of(context)!.financialPlanning, //Financial planning
      '2278679d-fe50-49a0-88d2-f060ca38f992':
          AppLocalizations.of(context)!.contentWriting, //Content writing
      '8ed12a47-cea7-4dd4-8404-cc4a13bb8fe0': AppLocalizations.of(context)!
          .socialMediaManagement, // Social media management
      '74d3fdb2-2258-4571-9d69-d8a390f83dac': AppLocalizations.of(context)!
          .videoProductionEditing, //Video production & editing
      '5449843f-1fbd-435f-9149-9f307b384d78': AppLocalizations.of(context)!
          .softwareDevelopment, //Software development
      '54d31a78-d7ce-44f1-80a7-936e601c7ae7': AppLocalizations.of(context)!
          .eCommerceAssistant, //E-commerce assistant
      '9415beec-8e31-4a8a-9a69-d767294a4e64':
          AppLocalizations.of(context)!.adminAssistant, //Admin assistant
      '0dacbe02-9bf1-49e4-9308-e7ff38b396fd': AppLocalizations.of(context)!
          .otherProfessionalServices, //Other professional services

      '3656d62a-fd2a-4c16-912e-5f26f988f4eb':
          AppLocalizations.of(context)!.productCost, //Product cost
      'bb33b298-bed0-4708-b871-9211e05971ac':
          AppLocalizations.of(context)!.fulfillmentFees, //Fulfillment fees
      '41fb3ac5-2959-4335-adef-42b93907173d':
          AppLocalizations.of(context)!.storageFees, //Storage fees
      'f8eb8079-50b0-445f-9fd3-bff6e5657ebe':
          AppLocalizations.of(context)!.shippingHandling, //Shipping & handling
      '038f36e2-4b94-4bcf-aa61-38e2c918811a': AppLocalizations.of(context)!
          .onlineSellingPlans, //Online selling plans
      'a3f4d43d-0438-4240-8fa6-6ca1655a26e1':
          AppLocalizations.of(context)!.referralFees, //Referral fees
      '9d00c38f-0c18-42bd-9919-6b926f0f402a':
          AppLocalizations.of(context)!.merchantFees, //Merchant fees
      '26426d06-e228-4048-b192-f5150fc2b712':
          AppLocalizations.of(context)!.returns, //Returns
      '86907f3e-013f-4145-8168-86f0ecc72246':
          AppLocalizations.of(context)!.productLoss, //Product loss

      'cb0a510f-a82e-4b65-bcc5-eb747ff0f5d7': AppLocalizations.of(context)!
          .advertisingMarketing, // Advertising & marketing
      '2437f89e-411f-4e86-b14e-d6298d615704': AppLocalizations.of(context)!
          .brandDealsCoMarketing, // Brand deals & co-marketing
      '8dfa43d0-fea5-4609-8e33-6e868367d6d6':
          AppLocalizations.of(context)!.referralFee, // Referral fee
      '29376d17-9d35-4499-b6f4-affdfc73c36c': AppLocalizations.of(context)!
          .socialMediaTechnologyFees, // Social media technology fees
      'c6e3e9ef-cb24-469f-ac8d-4d92ed449d39': AppLocalizations.of(context)!
          .softwareSubscriptions, // Software subscriptions
      '3effa3f3-2455-4717-aba9-4f4b7d2def9d': AppLocalizations.of(context)!
          .otherBizDevelopment, // Other biz development

      '7cf8959d-2479-4ea4-86ee-deef96dbb783': AppLocalizations.of(context)!
          .officeRentUtilities, // Office rent & utilities
      'bd7eefd5-aad6-4199-b3b5-a48bbc7f0329':
          AppLocalizations.of(context)!.officeSupplies, // Office supplies
      '246bd63f-537e-48d9-afb1-91efdca10ac2':
          AppLocalizations.of(context)!.officeEquipment, // Office equipment
      'd1e1a57e-c43b-4206-aab3-833f060d95f4': AppLocalizations.of(context)!
          .officeFurnishingDecor, // Office furnishing & decor
      '071de63f-4717-4435-bb7a-3c12e4b2728e': AppLocalizations.of(context)!
          .generalOfficeExpenses, // General office expenses

      '97fcef9e-c6a2-4d9a-9476-348a87bf00d3':
          AppLocalizations.of(context)!.autoExpenses, //Auto expenses
      '69ebb942-ac57-4dba-a358-e1b8c20cc082':
          AppLocalizations.of(context)!.phoneInternet, //Phone & Internet
      '87419d15-7519-461f-87b7-53afadc815ed': AppLocalizations.of(context)!
          .mealsEntertainment, //Meals & entertainment
      'dccd6906-9dd0-475d-bc89-ea6370421f62':
          AppLocalizations.of(context)!.travelExpenses, //Travel expenses
      'ba64c988-16b1-4eb6-8778-26e09ab49a5d':
          AppLocalizations.of(context)!.eventsVenueFees, //Events & venue fees
      '9ff2a21c-7a58-45e3-88a1-aea51c03aa98': AppLocalizations.of(context)!
          .websiteEmailServices, //Website & email services
      '032feb5e-1301-42f0-8270-af0411bff172': AppLocalizations.of(context)!
          .professionalDevelopment, //Professional development

      'df220c4b-06bc-49c3-a23b-52b7082adb13':
          AppLocalizations.of(context)!.transfer, // Transfer
      '735532d6-0130-4dd9-b753-2e5b4b95e109':
          AppLocalizations.of(context)!.transfer, // Transfer
      'e221c4a2-4f2b-47d4-8925-a9e41352bec0':
          AppLocalizations.of(context)!.ignore, //ignore
      'aead5351-3fd8-4a0a-8feb-2f9d4798728e':
          AppLocalizations.of(context)!.ignore, //ignore
    };
    return name[this] ?? '';
  }

  String iconUrl() {
    var iconMapper = {
      '938beaea-4e0a-458a-a6d2-27ed1e5b1de3':
          'assets/images/icons/categories_income.png',
      'e538cd67-9d54-48da-9a88-2bd111019885':
          'assets/images/icons/categories_housing.png',
      'd23427c2-79e8-4ef4-ba6c-54190e107eff':
          'assets/images/icons/categories_debt_payments.png',
      '96c4d1bf-0af7-43e4-b2c0-da84ce815db4':
          'assets/images/icons/categories_transportation.png',
      '35bcd407-36bb-4dc3-94b4-6ef7fcb8f23d':
          'assets/images/icons/categories_living_expenses.png',
      'a2107dc3-303a-453f-ac77-3bad360e9043':
          'assets/images/icons/categories_lifestyle_expenses.png',
      'b79220bf-b32c-4525-8f25-e76a7f437b70':
          'assets/images/icons/categories_kids.png',
      '9f4ff496-a4f1-4478-af6b-f7c22525c38f':
          'assets/images/icons/categories_giving.png',
      'a343ad1c-4f0f-411c-a46c-46466d214cd8':
          'assets/images/icons/categories_taxes.png',
      '941435d2-313b-4a99-b62c-e17fc9d52d4e':
          'assets/images/icons/categories_other_expenses.png',
      'e0fee339-ec7e-495d-aaa9-edbc3fa7aa09':
          'assets/images/icons/categories_goals.png',
      '0d4cf5cc-4d0f-4bde-9e71-7fedd9fae0c2':
          'assets/images/icons/categories_income.png',
      '40693474-d071-4341-9b50-a9cd4f312756':
          'assets/images/icons/professional_services.png',
      'd0c81068-5dc8-4eaf-a2bd-9d93650b5867':
          'assets/images/icons/product_costs.png',
      '9549bdb2-44d8-4bb6-b919-73aac505d6ee':
          'assets/images/icons/personnel_costs.png',
      'c5308fd7-bbe4-4bb6-8eca-56d58385dd96':
          'assets/images/icons/brand_development.png',
      '610289d1-6eb0-4474-8257-1bf552f97d09':
          'assets/images/icons/office_expenses.png',
      '8389d836-1fa4-49b5-b959-cbd3013a6b71':
          'assets/images/icons/general_expenses.png',
      'a6050bc7-7fd5-4186-bbb2-66ba5f25888d':
          'assets/images/icons/categories_debt_payments.png',
      '5305617c-0bd4-4dd7-8a05-b4202ccf4297':
          'assets/images/icons/categories_other_expenses.png',
      '2aa66aa9-b709-4787-987f-c870ee79dd4e':
          'assets/images/icons/owner_draw.png',
      'b41f6835-ebc0-4109-800f-0566e7d10a20':
          'assets/images/icons/owner_draw.png',
      'ef6691dd-397f-4b73-834a-0d25d966dfdc':
          'assets/images/icons/investments_active.png',
    };
    return iconMapper[this] ?? '';
  }
}

class CategoriesMapping {
  static Map<int, Map<String, List<String>>> categoriesMap(bool isIncome) =>
      isIncome
          ? transactionIncomeCategoriesMap
          : transactionExpensesCategoriesMap;

  static Map<int, Map<String, List<String>>> transactionExpensesCategoriesMap =
      {
    1: transactionPersonalCategoriesMap,
    2: transactionBusinessCategoriesMap,
  };

  static Map<int, Map<String, List<String>>> transactionIncomeCategoriesMap = {
    1: {
      //income
      '938beaea-4e0a-458a-a6d2-27ed1e5b1de3': [
        '144eee9e-000e-4208-916f-339b16e96005', // Salary/paycheck
        '5eb95029-61ef-4178-82ba-7269e61f4e2c', // Owner draw
        'c33509fd-b30a-417d-b00c-dc5fd07fb031', // Rental income
        '5243d6cf-2ee4-4022-916f-66ffe9dace2a', // Dividend income
        '25d44c51-8ae8-4999-ace9-7dcc228b525e', // Investment income
        '5acbff26-a546-4e4a-bfd9-6fbf4df3e0ed', //   Retirement income
        'baf5e5c1-54e1-474b-b554-00915f6df107', //   Other income
        '0f4e6f8c-9ec5-4479-b8fa-9cf31c7a5498', //  Loan received
        'f6ed2cd2-cd3b-42f4-8861-fe5627026200', //  Unbudgeted Income
      ],
      //ignore
      'e221c4a2-4f2b-47d4-8925-a9e41352bec0': [
        'aead5351-3fd8-4a0a-8feb-2f9d4798728e'
      ]
    },
    2: {
      // income
      '0d4cf5cc-4d0f-4bde-9e71-7fedd9fae0c2': [
        '1585cb86-d344-417d-b3b8-af841b5f47ef', //businessIncome
        '070b7df2-3c54-465f-b5a3-2de0a6b2649f', //otherIncome
        '8fd40d28-6830-4093-b34d-e5668916e537', // loanReceived
        '6a98dc8c-d514-4083-ac1d-0b4b5ee791cb', // investmentInBusiness
        'bd473fea-ff7a-4e0f-8d9d-2bbd9fc835f7', // unbudgetedIncome
      ],
      //ignore
      'e221c4a2-4f2b-47d4-8925-a9e41352bec0': [
        'aead5351-3fd8-4a0a-8feb-2f9d4798728e'
      ]
    },
  };

  static Map<String, List<String>> transactionPersonalCategoriesMap = {
//housing
    'e538cd67-9d54-48da-9a88-2bd111019885': [
      '3b2a607a-9fc1-43f4-886b-676c2ed00f25', //mortgage
      '3ba09a05-8d03-47b0-9cc3-2b9135f24ca6', // rent
      'f38e0ddb-cfb7-45af-97fc-24cd7c43799d', //utilities
      'c5142c9b-8fa1-4e5c-8e24-24f64af78c75', //homeRepairs
      '5826836c-a1fe-4015-bed9-241b683f7b10', //homeServices
    ],
    // transportation
    '96c4d1bf-0af7-43e4-b2c0-da84ce815db4': [
      '954d162e-7261-45fa-a33f-ce60c3d62611', //gas
      '73188218-e06e-434a-be17-507baa65b725', //autoInsurance
      '0601c9c2-9022-4499-b9e9-5b9a79cf3aa5', //uber
      '64a2079a-62f1-462d-ad3e-f0582039b78d', //publicTransportation
      '9f595d8e-9dd8-444a-8d2b-ee256f23407a', //autoRepairs
      'e851df7a-f2e3-4b63-b00a-b27f84a63eda', //otherAutoExpenses
    ],
    // livingExpenses
    '35bcd407-36bb-4dc3-94b4-6ef7fcb8f23d': [
      'c1e1732d-1e26-46a1-ab43-59f4542c8e8e', // groceries
      '45b06cd4-706d-46b6-9ca8-abf798eb146c', // clothing
      '46ca790d-1d4d-412e-8faa-164629cc324e', // phoneBill
      '0fc0c148-2ca2-4d62-87f4-c439985e8ab9', // internet
      'ecebb3b9-81e4-4e1a-8a5f-f4c06547cab2', // householdBasics
      'ff296508-c706-499d-b3ec-610bd903a0df', // healthInsurance
      '32c852e8-decc-4665-bbdf-bae2d169dce0', // medical
      'a80c75a9-d35d-430d-a508-d227af30b434', // petExpenses
    ],
    // lifestyleExpenses
    'a2107dc3-303a-453f-ac77-3bad360e9043': [
      '261eac57-d0e0-47b5-b244-8ca4ab4f02c8', // vacation
      'c04be0e6-d55a-41dc-8ace-29faccfb56d3', // recreation
      '8a33fabc-88a5-41ea-aebb-747b5dcdaffe', // coffeeEatingout
      'ad410412-4f2e-4112-9967-9149a5bac978', // dryCleaning
      '74421a1e-d71b-4267-8d97-9a0cdea4c9a3', // homeDecor
      '8a47686b-52e4-4994-9865-25bcc1467d0a', // houseHelp
      '040e5c08-95f6-4e61-94ef-36e353961f5b', // personalCare
      '27079efb-eb02-4b33-957f-f5e0fd31114d', // personalDevelopment
      '54c69bdf-9610-4d3a-81e7-bcd1464bed45', // professionalServices
      '8b48b1eb-9f6b-4fd6-9ba6-59d34e84d104', // electiveInsurances
      '4283fdf7-f01d-474b-8d05-4560fbcaf5f9', // leisureShopping
    ],
    // kids
    'b79220bf-b32c-4525-8f25-e76a7f437b70': [
      '318bcbfd-c7ed-412c-8700-f15372d2c26f', // childCare
      'de8a6670-b82d-4339-bf8b-3a4898c41e11', // babyNecessities
      'b279ff3e-ed9f-4da6-8c3f-d66700d79d8f', // privateSchoolTuition
      '8da6e1a7-730a-40ad-b961-b86b181aa8a8', // schoolSupplies
      'f8a04f7c-1cca-4f38-882a-e1e33bc82ac6', // schoolLunches
      '9ad83c4b-35bc-42f0-96d2-187d1846adb6', // tutoring
      '5b273ae8-f482-4f82-b991-1eefa0b9c389', // activities
      '6eddc02e-357a-4da3-bf15-413d8a07f7b4', // kidsShopping
      '89b76056-59ff-4e8f-a9c6-c6a410317d9a', // toys
      'f4c4b576-1e13-4480-81c2-554940122ced', // allowance
      'ef076943-2907-427b-b46e-9b3cbaa697ec', // childSupport
    ],
    // giving
    '9f4ff496-a4f1-4478-af6b-f7c22525c38f': [
      'acc36dd2-eb6d-4b9a-9d99-535b7e99754b', // familySupport
      '16c037cf-4e67-4c70-97fd-761d91aa0c08', // donation
      '2aae342b-aa7b-45cf-90ab-814e97ddba65', // gifts
    ],
    // taxes
    'a343ad1c-4f0f-411c-a46c-46466d214cd8': [
      'b10141c2-10bd-448c-af0a-49ba4b86a6f3', // federalIncomeTax,
      'f8b91929-3b59-44cf-9b29-f504206f78a8', // stateIncomeTax,
    ],
    // otherExpenses
    '941435d2-313b-4a99-b62c-e17fc9d52d4e': [
      '8bd3911e-93dc-45a3-a55b-cba281ce7db9', // miscExpenses,
      '2a3c8f8d-7401-466b-a8ec-e6f5bfe75870', // unbudgetted Expenses,
    ],
    // investments
    'ef6691dd-397f-4b73-834a-0d25d966dfdc': [
      '9c4bbdc3-3ce8-45d9-a687-d7d4cf3e7587', //  Stocks
      '6e377593-266a-48ee-be44-1d49e264ad27', //  Real Estate
      '1a16bd8f-f4c2-41be-af95-7dace32a075f', //  Cryptocurrency
      '2be2d7ff-aaac-4e70-8741-a432e27f108b', //  Startup Investments
      '91cc20b1-705f-4332-97f9-c58cf28570f2', //  Angel Investments
      '29727dcd-c859-41a5-99e1-0317c4f39bd9', //  Venture Capital
      '3f428bad-3429-4bd3-8cb0-00926c503e91', //  Business Interest
      '16b7de8e-b843-42a7-8e05-3b6a9685b68d', //  Retirement Assets
      '9dc0c957-82d4-4932-a0e3-8ce9f302cea1', //  Gold and Other Metals
      '8f0eae98-a329-4216-bade-9b7eb855004c', //  Digital Assets
      '6eff723e-8b94-44f9-824e-1eea5ae6a550', //  Other Investments
    ],
    // Transfer
    '735532d6-0130-4dd9-b753-2e5b4b95e109': [
      'df220c4b-06bc-49c3-a23b-52b7082adb13'
    ],
    //ignore
    'e221c4a2-4f2b-47d4-8925-a9e41352bec0': [
      'aead5351-3fd8-4a0a-8feb-2f9d4798728e'
    ]
  };

  static Map<String, List<String>> transactionBusinessCategoriesMap = {
    // 'Personnel Costs'
    '9549bdb2-44d8-4bb6-b919-73aac505d6ee': [
      '8299485d-8756-4254-84ad-db01995dcbf7', //Owner pay
      'e58b0a66-7a48-48be-8125-0722b8359cdc', //Staff salaries
      'b0a3bee7-dc09-4871-82a8-2607b55ba6fc', //Employee benefits
      'eba85dad-5eb3-4cbd-bd3d-57cda7cc7e29', //Payroll taxes
    ],
    // 'Professional Services'
    '40693474-d071-4341-9b50-a9cd4f312756': [
      'ceb3f98d-0027-4f11-8059-1489ce655e65', //Accounting
      'e76c2829-4541-4f66-95d1-8a3dd17e78f9', //Financial planning
      '2278679d-fe50-49a0-88d2-f060ca38f992', //Content writing
      '8ed12a47-cea7-4dd4-8404-cc4a13bb8fe0', // Social media management
      '74d3fdb2-2258-4571-9d69-d8a390f83dac', //Video production & editing
      '5449843f-1fbd-435f-9149-9f307b384d78', //Software development
      '54d31a78-d7ce-44f1-80a7-936e601c7ae7', //E-commerce assistant
      '9415beec-8e31-4a8a-9a69-d767294a4e64', //Admin assistant
      '0dacbe02-9bf1-49e4-9308-e7ff38b396fd', //Other professional services
    ],
    // 'Product Costs'
    'd0c81068-5dc8-4eaf-a2bd-9d93650b5867': [
      '3656d62a-fd2a-4c16-912e-5f26f988f4eb', //Product cost
      'bb33b298-bed0-4708-b871-9211e05971ac', //Fulfillment fees
      '41fb3ac5-2959-4335-adef-42b93907173d', //Storage fees
      'f8eb8079-50b0-445f-9fd3-bff6e5657ebe', //Shipping & handling
      '038f36e2-4b94-4bcf-aa61-38e2c918811a', //Online selling plans
      'a3f4d43d-0438-4240-8fa6-6ca1655a26e1', //Referral fees
      '9d00c38f-0c18-42bd-9919-6b926f0f402a', //Merchant fees
      '26426d06-e228-4048-b192-f5150fc2b712', //Returns
      '86907f3e-013f-4145-8168-86f0ecc72246', //Product loss
    ],
    // 'Brand Development'
    'c5308fd7-bbe4-4bb6-8eca-56d58385dd96': [
      'cb0a510f-a82e-4b65-bcc5-eb747ff0f5d7', // Advertising & marketing
      '2437f89e-411f-4e86-b14e-d6298d615704', // Brand deals & co-marketing
      '8dfa43d0-fea5-4609-8e33-6e868367d6d6', // Referral fee
      '29376d17-9d35-4499-b6f4-affdfc73c36c', // Social media technology fees
      'c6e3e9ef-cb24-469f-ac8d-4d92ed449d39', // Software subscriptions
      '3effa3f3-2455-4717-aba9-4f4b7d2def9d', // Other biz development
    ],
    // 'Office Expenses'
    '610289d1-6eb0-4474-8257-1bf552f97d09': [
      '7cf8959d-2479-4ea4-86ee-deef96dbb783', // Office rent & utilities
      'bd7eefd5-aad6-4199-b3b5-a48bbc7f0329', // Office supplies
      '246bd63f-537e-48d9-afb1-91efdca10ac2', // Office equipment
      'd1e1a57e-c43b-4206-aab3-833f060d95f4', // Office furnishing & decor
      '071de63f-4717-4435-bb7a-3c12e4b2728e', // General office expenses
    ],
    // 'General Expenses'
    '8389d836-1fa4-49b5-b959-cbd3013a6b71': [
      '97fcef9e-c6a2-4d9a-9476-348a87bf00d3', //Auto expenses
      '69ebb942-ac57-4dba-a358-e1b8c20cc082', //Phone & Internet
      '87419d15-7519-461f-87b7-53afadc815ed', //Meals & entertainment
      'dccd6906-9dd0-475d-bc89-ea6370421f62', //Travel expenses
      'ba64c988-16b1-4eb6-8778-26e09ab49a5d', //Events & venue fees
      '9ff2a21c-7a58-45e3-88a1-aea51c03aa98', //Website & email services
      '032feb5e-1301-42f0-8270-af0411bff172', //Professional development
    ],
    // otherExpences
    '5305617c-0bd4-4dd7-8a05-b4202ccf4297': [
      '01a1ae66-671e-4263-8d95-744e36b64a06', // Misc Expenses
      '824e6410-7355-4152-bacf-ddb615648758', // Unbudgetted Expenses
    ],
    // Owner Draw
    'b41f6835-ebc0-4109-800f-0566e7d10a20': [
      '2aa66aa9-b709-4787-987f-c870ee79dd4e' // owner draw
    ],
    // Transfer
    '735532d6-0130-4dd9-b753-2e5b4b95e109': [
      'df220c4b-06bc-49c3-a23b-52b7082adb13'
    ],
    //ignore
    'e221c4a2-4f2b-47d4-8925-a9e41352bec0': [
      'aead5351-3fd8-4a0a-8feb-2f9d4798728e'
    ]
  };
}

extension Calculation on DateTime {
  DateTime endMonth() {
    var days = 30;
    if (month == 2) {
      days = 28;
    } else if (month == 1 ||
        month == 1 ||
        month == 3 ||
        month == 5 ||
        month == 7 ||
        month == 8 ||
        month == 10 ||
        month == 12) {
      days = 31;
    }
    return DateTime(year, month, days);
  }
}
