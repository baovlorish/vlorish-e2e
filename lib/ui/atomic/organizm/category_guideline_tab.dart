import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_vertical_devider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalCategoryGuidelineWidget extends StatefulWidget {
  PersonalCategoryGuidelineWidget({Key? key}) : super(key: key);

  @override
  State<PersonalCategoryGuidelineWidget> createState() =>
      _PersonalCategoryGuidelineWidgetState();
}

class _PersonalCategoryGuidelineWidgetState
    extends State<PersonalCategoryGuidelineWidget> {
  late final generalTextMap = <String, String>{
    '${AppLocalizations.of(context)!.salary}/${AppLocalizations.of(context)!.paycheck}':
        AppLocalizations.of(context)!.categoryDescriptionSalaryPaycheck,
    AppLocalizations.of(context)!.ownerDraw:
        AppLocalizations.of(context)!.categoryDescriptionOwnerGrow,
    AppLocalizations.of(context)!.rentalIncome:
        AppLocalizations.of(context)!.categoryDescriptionRentalIncome,
    AppLocalizations.of(context)!.dividendIncome:
        AppLocalizations.of(context)!.categoryDescriptionOwnerGrow,
    AppLocalizations.of(context)!.investmentIncome:
        AppLocalizations.of(context)!.categoryDescriptionOwnerGrow,
    AppLocalizations.of(context)!.retirementIncome:
        AppLocalizations.of(context)!.categoryDescrptionRetirementIncome,
    AppLocalizations.of(context)!.otherIncome:
        AppLocalizations.of(context)!.categoryDescriptionOtherIncome,
    AppLocalizations.of(context)!.loanReceived:
        AppLocalizations.of(context)!.categoryDescriptionLoanReceived,
    AppLocalizations.of(context)!.uncategorizedIncome:
        AppLocalizations.of(context)!.categoryDescriptionUncatagorizedIncome,
  };

  late final housingTextMap = <String, String>{
    AppLocalizations.of(context)!.mortgage:
        AppLocalizations.of(context)!.categoryDescriptionMortgage,
    AppLocalizations.of(context)!.rent:
        AppLocalizations.of(context)!.categoryDescriptionRent,
    AppLocalizations.of(context)!.utilities:
        AppLocalizations.of(context)!.categoryDescriptionUtilities,
    AppLocalizations.of(context)!.homeRepairs:
        AppLocalizations.of(context)!.categoryDescriptionHomeRepairs,
    AppLocalizations.of(context)!.homeServices:
        AppLocalizations.of(context)!.categoryDescriptionHomeServices
  };

  late final debtTextMap = <String, String>{
    AppLocalizations.of(context)!.creditCards:
        AppLocalizations.of(context)!.categoryDescriptionCreditCards,
    AppLocalizations.of(context)!.studentLoans:
        AppLocalizations.of(context)!.categoryDescriptionStudentLoans,
    AppLocalizations.of(context)!.autoLoans:
        AppLocalizations.of(context)!.categoryDescriptionAutoLoans,
    AppLocalizations.of(context)!.personalLoan:
        AppLocalizations.of(context)!.categoryDescriptionPersonalLoan,
    AppLocalizations.of(context)!.medicalBills:
        AppLocalizations.of(context)!.categoryDescriptionMedicanBills,
    AppLocalizations.of(context)!.alimony:
        AppLocalizations.of(context)!.categoryDescriptionAlimony,
    AppLocalizations.of(context)!.otherDebt:
        AppLocalizations.of(context)!.categoryDescriptionOtherDebt,
  };

  late final transportationTextMap = <String, String>{
    AppLocalizations.of(context)!.gas:
        AppLocalizations.of(context)!.categoryDescriptionGas,
    AppLocalizations.of(context)!.autoInsurance:
        AppLocalizations.of(context)!.categoryDescriptionAutoInsurance,
    AppLocalizations.of(context)!.publicTransportation:
        AppLocalizations.of(context)!.categoryDescriptionPublicTransportation,
    AppLocalizations.of(context)!.autoRepairs:
        AppLocalizations.of(context)!.categoryDescriptionAutoRepairs,
    AppLocalizations.of(context)!.autoExpenses:
        AppLocalizations.of(context)!.categoryDescriptionAutoExpenses,
  };

  late final livingExpensesTextMap = <String, String>{
    AppLocalizations.of(context)!.groceries:
        AppLocalizations.of(context)!.categoryDescriptionGroceries,
    AppLocalizations.of(context)!.clothing:
        AppLocalizations.of(context)!.categoryDescriptionClothing,
    AppLocalizations.of(context)!.phoneBill:
        AppLocalizations.of(context)!.categoryDescriptionPhoneBill,
    AppLocalizations.of(context)!.internetAndTv:
        AppLocalizations.of(context)!.categoryDescriptionInternetAndTv,
    AppLocalizations.of(context)!.householdBasics:
        AppLocalizations.of(context)!.categoryDescriptionHouseholdBasics,
    AppLocalizations.of(context)!.healthInsurance:
        AppLocalizations.of(context)!.categoryDescriptionHealthInsurance,
    AppLocalizations.of(context)!.healthcareExpenses:
        AppLocalizations.of(context)!.categoryDescriptionHealthcareExpenses,
    AppLocalizations.of(context)!.petExpenses:
        AppLocalizations.of(context)!.categoryDescriptionPetExpenses,
  };

  late final discretionarySpendingTextMap = <String, String>{
    AppLocalizations.of(context)!.vacation:
        AppLocalizations.of(context)!.categoryDescriptionVacation,
    AppLocalizations.of(context)!.entertainment:
        AppLocalizations.of(context)!.categoryDescriptionEntertainment,
    AppLocalizations.of(context)!.coffeeEatingout:
        AppLocalizations.of(context)!.categoryDescriptionHouseCoffeeEatingout,
    AppLocalizations.of(context)!.dryCleaning:
        AppLocalizations.of(context)!.categoryDescriptionHouseDryCleaning,
    AppLocalizations.of(context)!.furnitureDecor:
        AppLocalizations.of(context)!.categoryDescriptionHouseFurnitureDecor,
    AppLocalizations.of(context)!.householdBasics:
        AppLocalizations.of(context)!.categoryDescriptionHouseholdBasics,
    AppLocalizations.of(context)!.personalCare:
        AppLocalizations.of(context)!.categoryDescriptionPersonalCare,
    AppLocalizations.of(context)!.personalDevelopment:
        AppLocalizations.of(context)!.categoryDescriptionPersonalDevelopment,
    AppLocalizations.of(context)!.professionalServices:
        AppLocalizations.of(context)!.categoryDescriptionProfessionalServices,
    AppLocalizations.of(context)!.electiveInsurances:
        AppLocalizations.of(context)!.categoryDescriptionElectiveInsurances,
    AppLocalizations.of(context)!.subscriptions:
        AppLocalizations.of(context)!.categoryDescriptionSubscriptions,
    AppLocalizations.of(context)!.funShopping:
        AppLocalizations.of(context)!.categoryDescriptionFunShopping,
  };

  late final kidsTextMap = <String, String>{
    AppLocalizations.of(context)!.childCare:
        AppLocalizations.of(context)!.categoryDescriptionChildCare,
    AppLocalizations.of(context)!.collegeFund:
        AppLocalizations.of(context)!.categoryDescriptionCollegeFund,
    AppLocalizations.of(context)!.tuitionAndFees:
        AppLocalizations.of(context)!.categoryDescriptionTuitionAndFees,
    AppLocalizations.of(context)!.schoolLunches:
        AppLocalizations.of(context)!.categoryDescriptionSchoolLunches,
    AppLocalizations.of(context)!.tutoring:
        AppLocalizations.of(context)!.categoryDescriptionTutoring,
    AppLocalizations.of(context)!.activities:
        AppLocalizations.of(context)!.categoryDescriptionActivities,
    AppLocalizations.of(context)!.allowance:
        AppLocalizations.of(context)!.categoryDescriptionAllowance,
    AppLocalizations.of(context)!.childSupport:
        AppLocalizations.of(context)!.categoryDescriptionChildSupport
  };

  late final givingTextMap = <String, String>{
    AppLocalizations.of(context)!.familySupport:
        AppLocalizations.of(context)!.categoryDescriptionFamilySupport,
    AppLocalizations.of(context)!.donation:
        AppLocalizations.of(context)!.categoryDescriptionDonation,
    AppLocalizations.of(context)!.gifts:
        AppLocalizations.of(context)!.categoryDescriptionGifts
  };

  late final taxesTextMap = <String, String>{
    AppLocalizations.of(context)!.estimatedFederalIncomeTax:
        AppLocalizations.of(context)!
            .categoryDescriptionEstimatedFederalIncomeTax,
    AppLocalizations.of(context)!.estimatedStateIncomeTax:
        AppLocalizations.of(context)!.categoryDescriptionstimatedStateIncomeTax,
    AppLocalizations.of(context)!.backTaxes:
        AppLocalizations.of(context)!.categoryDescriptionBackTaxes
  };

  late final otherExpensesTextMap = <String, String>{
    AppLocalizations.of(context)!.miscExpenses:
        AppLocalizations.of(context)!.categoryDescriptionMiscExpenses,
    AppLocalizations.of(context)!.unbudgettedExpenses:
        AppLocalizations.of(context)!.categoryDescriptionUnbudgettedExpenses,
  };

  late final totalExpensesTextMap = <String, String>{
    AppLocalizations.of(context)!.netIncome:
        AppLocalizations.of(context)!.categoryDescriptionNetIncome,
    AppLocalizations.of(context)!.goals:
        AppLocalizations.of(context)!.categoryDescriptionGoals,
    AppLocalizations.of(context)!.totalCashReserve:
        AppLocalizations.of(context)!.categoryDescriptionTotalCashReserve,
    AppLocalizations.of(context)!.investments:
        AppLocalizations.of(context)!.categoryDescriptionInvestments,
    AppLocalizations.of(context)!.freeCash:
        AppLocalizations.of(context)!.categoryDescriptionFreeCash,
  };
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Label(
          text: AppLocalizations.of(context)!.categoriesGuidelineTitle,
          type: LabelType.General,
          fontWeight: FontWeight.w500,
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(width: 1.0, color: CustomColorScheme.tableBorder),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Label(
                      text:
                          AppLocalizations.of(context)!.categories.capitalize(),
                      type: LabelType.GreyLabel,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 7,
                    child: Label(
                      text: AppLocalizations.of(context)!
                          .description
                          .capitalize(),
                      type: LabelType.GreyLabel,
                    ),
                  )
                ],
              ),
            ),
            CategoryExpansionTile(
              textMapEntries: generalTextMap.entries,
              categoryId: '938beaea-4e0a-458a-a6d2-27ed1e5b1de3',
            ),
            CategoryExpansionTile(
              textMapEntries: housingTextMap.entries,
              categoryId: 'e538cd67-9d54-48da-9a88-2bd111019885',
            ),
            CategoryExpansionTile(
              textMapEntries: debtTextMap.entries,
              categoryId: 'd23427c2-79e8-4ef4-ba6c-54190e107eff',
            ),
            CategoryExpansionTile(
              textMapEntries: transportationTextMap.entries,
              categoryId: '96c4d1bf-0af7-43e4-b2c0-da84ce815db4',
            ),
            CategoryExpansionTile(
              textMapEntries: livingExpensesTextMap.entries,
              categoryId: '35bcd407-36bb-4dc3-94b4-6ef7fcb8f23d',
            ),
            CategoryExpansionTile(
              textMapEntries: discretionarySpendingTextMap.entries,
              categoryId:
                  'a2107dc3-303a-453f-ac77-3bad360e9043', //but its Discretionary Spending in documentation
            ),
            CategoryExpansionTile(
              textMapEntries: kidsTextMap.entries,
              categoryId: 'b79220bf-b32c-4525-8f25-e76a7f437b70',
            ),
            CategoryExpansionTile(
              textMapEntries: givingTextMap.entries,
              categoryId: '9f4ff496-a4f1-4478-af6b-f7c22525c38f',
            ),
            CategoryExpansionTile(
              textMapEntries: taxesTextMap.entries,
              categoryId: 'a343ad1c-4f0f-411c-a46c-46466d214cd8',
            ),
            CategoryExpansionTile(
              textMapEntries: otherExpensesTextMap.entries,
              categoryId: '941435d2-313b-4a99-b62c-e17fc9d52d4e',
            ),
            CategoryExpansionTile(
              textMapEntries: totalExpensesTextMap.entries,
              categoryId: 'Total Expenses',
              iconUrl: 'assets/images/icons/categories_total_expenses.png',
            ),
          ],
        ),
      ),
    ]);
  }
}

class BusinessCategoryGuidelineWidget extends StatefulWidget {
  BusinessCategoryGuidelineWidget({Key? key}) : super(key: key);

  @override
  State<BusinessCategoryGuidelineWidget> createState() =>
      _BusinessCategoryGuidelineWidgetState();
}

class _BusinessCategoryGuidelineWidgetState
    extends State<BusinessCategoryGuidelineWidget> {
  late final generalBusinessTextMap = <String, String>{
    AppLocalizations.of(context)!.businessIncome:
        AppLocalizations.of(context)!.categoryDescriptionBusinessIncome,
    AppLocalizations.of(context)!.otherIncome:
        AppLocalizations.of(context)!.categoryDescriptionBusinessOtherIncome,
    AppLocalizations.of(context)!.loanReceived:
        AppLocalizations.of(context)!.categoryDescriptionBusinessLoanReceived,
    AppLocalizations.of(context)!.investmentInBusiness:
        AppLocalizations.of(context)!.categoryDescriptionInvestmentInBusiness,
    AppLocalizations.of(context)!.uncategorizedIncome:
        AppLocalizations.of(context)!.categoryDescriptionUncategorizedIncome,
  };

  // Personnel Costs
  late final personnelCostsBusinessTextMap = <String, String>{
    AppLocalizations.of(context)!.ownerPay:
        AppLocalizations.of(context)!.categoryDescriptionOwnerPay,
    AppLocalizations.of(context)!.staffSalaries:
        AppLocalizations.of(context)!.categoryDescriptionStaffSalaries,
    AppLocalizations.of(context)!.employeeBenefits:
        AppLocalizations.of(context)!.categoryDescriptionEmployeeBenefits,
    AppLocalizations.of(context)!.payrollTaxes:
        AppLocalizations.of(context)!.categoryDescriptionPayrollTaxes,
  };

  // Professional Services
  late final professionalServicesBusinessTextMap = <String, String>{
    AppLocalizations.of(context)!.accounting:
        AppLocalizations.of(context)!.categoryDescriptionAccounting,
    AppLocalizations.of(context)!.financialPlanning:
        AppLocalizations.of(context)!.categoryDescriptionFinancialPlanning,
    AppLocalizations.of(context)!.contentWriting:
        AppLocalizations.of(context)!.categoryDescriptionContentWriting,
    AppLocalizations.of(context)!.socialMediaManagement:
        AppLocalizations.of(context)!.categoryDescriptionSocialMediaManagement,
    AppLocalizations.of(context)!.videoProductionEditing:
        AppLocalizations.of(context)!.categoryDescriptionVideoProductionEditing,
    AppLocalizations.of(context)!.softwareDevelopment:
        AppLocalizations.of(context)!.categoryDescriptionSoftwareDevelopment,
    AppLocalizations.of(context)!.eCommerceAssistant:
        AppLocalizations.of(context)!.categoryDescriptionEcommerceAssistant,
    AppLocalizations.of(context)!.adminAssistant:
        AppLocalizations.of(context)!.categoryDescriptionAdminAssistant,
    AppLocalizations.of(context)!.legalAndProfessionalServices:
        AppLocalizations.of(context)!
            .categoryDescriptionLegalAndProfessionalServices,
  };

  // Property Management,
  late final propertyManagementBusinessTextMap = <String, String>{
    AppLocalizations.of(context)!.mortgagePayments:
        AppLocalizations.of(context)!.categoryDescriptionMortgagePayments,
    AppLocalizations.of(context)!.leasingAndPropertyManagement:
        AppLocalizations.of(context)!
            .categoryDescriptionLeasingAndPropertyManagement,
    AppLocalizations.of(context)!.repairsAndMaintainance:
        AppLocalizations.of(context)!.categoryDescriptionRepairsAndMaintainance,
    AppLocalizations.of(context)!.capitalExpenditures:
        AppLocalizations.of(context)!.categoryDescriptionCapitalExpenditures,
    AppLocalizations.of(context)!.depreicationExpenses:
        AppLocalizations.of(context)!.categoryDescriptionDepreicationExpenses,
  };

  // Product Costs,
  late final productCostsBusinessTextMap = <String, String>{
    AppLocalizations.of(context)!.productCost:
        AppLocalizations.of(context)!.categoryDescriptionProductCost,
    AppLocalizations.of(context)!.fulfillmentFees:
        AppLocalizations.of(context)!.categoryDescriptionFulfillmentFees,
    AppLocalizations.of(context)!.storageFees:
        AppLocalizations.of(context)!.categoryDescriptionStorageFees,
    AppLocalizations.of(context)!.shippingHandling:
        AppLocalizations.of(context)!.categoryDescriptionShippingHandling,
    AppLocalizations.of(context)!.onlineSellingPlans:
        AppLocalizations.of(context)!.categoryDescriptionOnlineSellingPlans,
    AppLocalizations.of(context)!.merchantFees:
        AppLocalizations.of(context)!.categoryDescriptionMerchantFees,
    AppLocalizations.of(context)!.salesTax:
        AppLocalizations.of(context)!.categoryDescriptionSalesTax,
    AppLocalizations.of(context)!.customsAndBrokers:
        AppLocalizations.of(context)!.categoryDescriptionCustomsAndBrokers,
    AppLocalizations.of(context)!.returns:
        AppLocalizations.of(context)!.categoryDescriptionReturns,
    AppLocalizations.of(context)!.productLoss:
        AppLocalizations.of(context)!.categoryDescriptionProductLoss,
  };

  // Business Development,
  late final businessDevelopmentBusinessTextMap = <String, String>{
    AppLocalizations.of(context)!.advertisingMarketing:
        AppLocalizations.of(context)!.categoryDescriptionAdvertisingMarketing,
    AppLocalizations.of(context)!.referralFees:
        AppLocalizations.of(context)!.categoryDescriptionReferralFees,
    AppLocalizations.of(context)!.otherBusinessDevelopment:
        AppLocalizations.of(context)!
            .categoryDescriptionOtherBusinessDevelopment,
  };

  // Office Expenses,
  late final officeExpensesBusinessTextMap = <String, String>{
    AppLocalizations.of(context)!.officeRentUtilities:
        AppLocalizations.of(context)!.categoryDescriptionOfficeRentUtilities,
    AppLocalizations.of(context)!.officeSupplies:
        AppLocalizations.of(context)!.categoryDescriptionOfficeSupplies,
    AppLocalizations.of(context)!.officeEquipment:
        AppLocalizations.of(context)!.categoryDescriptionOfficeEquipment,
    AppLocalizations.of(context)!.officeFurnishingDecor:
        AppLocalizations.of(context)!.categoryDescriptionOfficeFurnishingDecor,
    AppLocalizations.of(context)!.officeExpenses:
        AppLocalizations.of(context)!.categoryDescriptionOfficeExpenses,
  };

  // General Business Expenses,
  late final generalBusinessExpensesBusinessTextMap = <String, String>{
    AppLocalizations.of(context)!.techFeesAndSubscriptions:
        AppLocalizations.of(context)!
            .categoryDescriptionBusinessTechFeesAndSubscriptions,
    AppLocalizations.of(context)!.autoExpenses:
        AppLocalizations.of(context)!.categoryDescriptionBusinessAutoExpenses,
    AppLocalizations.of(context)!.phoneAndInternet:
        AppLocalizations.of(context)!.categoryDescriptionPhoneAndInternet,
    AppLocalizations.of(context)!.businessMealsOne:
        AppLocalizations.of(context)!.categoryDescriptionBusinessMealsOne,
    AppLocalizations.of(context)!.businessMealsTwo:
        AppLocalizations.of(context)!.categoryDescriptionBusinessMealsTwo,
    AppLocalizations.of(context)!.businessEntertainment:
        AppLocalizations.of(context)!.categoryDescriptionBusinessEntertainment,
    AppLocalizations.of(context)!.travelExpenses:
        AppLocalizations.of(context)!.categoryDescriptionBusinessTravelExpenses,
    AppLocalizations.of(context)!.eventsVenueFees:
        AppLocalizations.of(context)!.categoryDescriptionEventsVenueFees,
    AppLocalizations.of(context)!.businessLicensesAndFees:
        AppLocalizations.of(context)!
            .categoryDescriptionBusinessLicensesAndFees,
    AppLocalizations.of(context)!.professionalDevelopment:
        AppLocalizations.of(context)!
            .categoryDescriptionProfessionalDevelopment,
  };

  // Debts Payments,
  late final debtsPaymentsBusinessTextMap = <String, String>{
    AppLocalizations.of(context)!.creditCard:
        AppLocalizations.of(context)!.categoryDescriptionBusinessCreditCards,
    AppLocalizations.of(context)!.autoLoan:
        AppLocalizations.of(context)!.categoryDescriptionBusinessAutoLoans,
    AppLocalizations.of(context)!.businessLoan:
        AppLocalizations.of(context)!.categoryDescriptionBusinessLoan,
  };

  // Other Expenses,
  late final otherExpensesBusinessTextMap = <String, String>{
    AppLocalizations.of(context)!.miscExpenses:
        AppLocalizations.of(context)!.categoryDescriptionMiscExpenses,
    AppLocalizations.of(context)!.unbudgettedExpenses:
        AppLocalizations.of(context)!.categoryDescriptionUnbudgettedExpenses,
  };

  // Total Expenses,
  late final totalExpensesBusinessTextMap = <String, String>{
    AppLocalizations.of(context)!.netIncome:
        AppLocalizations.of(context)!.categoryDescriptionBusinessNetIncome,
    AppLocalizations.of(context)!.ownerDraw:
        AppLocalizations.of(context)!.categoryDescriptionBusinessOwnerDraw,
    AppLocalizations.of(context)!.retainedInTheBusiness:
        AppLocalizations.of(context)!.categoryDescriptionRetainedInTheBusiness,
    AppLocalizations.of(context)!.endingCashReserve:
        AppLocalizations.of(context)!.categoryDescriptionEndingCashReserve,
  };

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Label(
          text: AppLocalizations.of(context)!.categoriesGuidelineTitle,
          type: LabelType.General,
          fontWeight: FontWeight.w500,
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(width: 1.0, color: CustomColorScheme.tableBorder),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Label(
                    text: 'CATEGORIES',
                    type: LabelType.GreyLabel,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 7,
                  child: Label(
                    text: 'DESCRIPTION',
                    type: LabelType.GreyLabel,
                  ),
                )
              ],
            ),
          ),
          CategoryExpansionTile(
            textMapEntries: generalBusinessTextMap.entries,
            categoryId: '938beaea-4e0a-458a-a6d2-27ed1e5b1de3',
          ),
          CategoryExpansionTile(
            textMapEntries: personnelCostsBusinessTextMap.entries,
            categoryId: '9549bdb2-44d8-4bb6-b919-73aac505d6ee',
          ),
          CategoryExpansionTile(
            textMapEntries: professionalServicesBusinessTextMap.entries,
            categoryId: '40693474-d071-4341-9b50-a9cd4f312756',
          ),
          CategoryExpansionTile(
            textMapEntries: productCostsBusinessTextMap.entries,
            categoryId: 'd0c81068-5dc8-4eaf-a2bd-9d93650b5867',
          ),
          CategoryExpansionTile(
            textMapEntries: businessDevelopmentBusinessTextMap.entries,
            categoryId: 'c5308fd7-bbe4-4bb6-8eca-56d58385dd96',
          ),
          CategoryExpansionTile(
            textMapEntries: officeExpensesBusinessTextMap.entries,
            categoryId: '610289d1-6eb0-4474-8257-1bf552f97d09',
          ),
          CategoryExpansionTile(
            textMapEntries: generalBusinessExpensesBusinessTextMap.entries,
            categoryId: '8389d836-1fa4-49b5-b959-cbd3013a6b71',
          ),
          CategoryExpansionTile(
            textMapEntries: debtsPaymentsBusinessTextMap.entries,
            categoryId: 'd23427c2-79e8-4ef4-ba6c-54190e107eff',
          ),
          CategoryExpansionTile(
            textMapEntries: otherExpensesBusinessTextMap.entries,
            categoryId: '5305617c-0bd4-4dd7-8a05-b4202ccf4297',
          ),
          CategoryExpansionTile(
            textMapEntries: totalExpensesBusinessTextMap.entries,
            categoryId: 'Total Expenses',
            iconUrl: 'assets/images/icons/categories_total_expenses.png',
          ),
        ]),
      )
    ]);
  }
}

class CategoryRowItem extends StatelessWidget {
  const CategoryRowItem(
      {Key? key, required this.categoryName, required this.categoryDescription})
      : super(key: key);

  final String categoryName;
  final String categoryDescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(width: 1.0, color: CustomColorScheme.tableBorder)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Label(
                  text: categoryName,
                  type: LabelType.GeneralWorkSansBold,
                ),
              ),
            ),
            CustomVerticalDivider(
              color: CustomColorScheme.tableBorder,
            ),
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Label(
                  text: categoryDescription,
                  type: LabelType.General,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryExpansionTile extends StatefulWidget {
  const CategoryExpansionTile({
    Key? key,
    required this.categoryId,
    required this.textMapEntries,
    this.iconUrl,
  }) : super(key: key);

  final Iterable<MapEntry<String, String>> textMapEntries;
  final String categoryId;
  final String? iconUrl;

  @override
  State<CategoryExpansionTile> createState() => _CategoryExpansionTileState();
}

class _CategoryExpansionTileState extends State<CategoryExpansionTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColorScheme.categoryGuidelineTiles,
        border: Border(
          top: BorderSide(width: 1, color: CustomColorScheme.tableBorder),
        ),
      ),
      child: ExpansionTile(
        expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) {
          setState(
            () {
              isExpanded = expanded;
            },
          );
        },
        title: Label(
          text: widget.categoryId.nameLocalization(context).isNotEmpty
              ? widget.categoryId.nameLocalization(context)
              : widget.categoryId,
          type: LabelType.General,
          fontWeight: FontWeight.w600,
        ),
        leading: widget.categoryId.iconUrl().isNotEmpty
            ? ImageIcon(
                AssetImage(widget.categoryId.iconUrl()),
                color: CustomColorScheme.text,
                size: 24,
              )
            : widget.iconUrl != null
                ? ImageIcon(
                    AssetImage(widget.iconUrl!),
                    color: CustomColorScheme.text,
                    size: 24,
                  )
                : null,
        trailing: ImageIcon(
          isExpanded
              ? AssetImage('assets/images/icons/arrow_up.png')
              : AssetImage('assets/images/icons/arrow.png'),
          color: CustomColorScheme.errorPopupButton,
          size: 24,
        ),
        children: <CategoryRowItem>[
          for (final item in widget.textMapEntries)
            CategoryRowItem(
              categoryName: item.key,
              categoryDescription: item.value,
            )
        ],
      ),
    );
  }
}
