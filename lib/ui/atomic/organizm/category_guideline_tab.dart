import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_vertical_devider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalCategoryGuidelineWidget extends StatelessWidget {
  PersonalCategoryGuidelineWidget({Key? key}) : super(key: key);
  final generalTextMap = <String, String>{
    'Paycheck/Salary':
        'Regular w-2 employee income such as from a fixed salary or regular hourly pay',
    'Owner draw':
        'Owner draw from a business including all transfers/draws from a business account to a personal account',
    'Rental income':
        'Income received from rental property that isn\'t tracked separately in the business budget',
    'Dividend income':
        'Income received from dividend sources such as stock dividend or corporate dividend, etc.',
    'Investment income': 'Income received from the sale of an investment',
    'Retirement income':
        'Distributions from a retirement plan such 401k or 403b etc',
    'Other income':
        'Other forms of income that isn\'t included in above categories. Include sale of real estate or personal property, reimbursements, etc',
    'Loan received':
        'Loans received that need to be paid back at some point in the future',
    'Uncategorized income':
        'Temporary account used to hold income that is uncear or unknown which need your input for proper category selection',
  };

  final housingTextMap = <String, String>{
    'Mortgage': 'Includes property taxes, home owner\'s insurance, PMI, HOA',
    'Rent': 'Monthly rent payments',
    'Utilities': 'Includes electric, gas, water, trash, sewer',
    'Home Repairs':
        'Home repairs paid by owner whether covered by insurance or not',
    'Home Services': 'Lawn care, snow removal, pest control, security system'
  };

  final debtTextMap = <String, String>{
    'Credit Cards': 'Credit card payments',
    'Student Loans': 'Student loan payments',
    'Auto Loans': 'Auto loan payments',
    'Personal Loan': 'Payments towards a personal loan',
    'Medical Bills': 'Payments towards a medical debt',
    'Alimony': 'Alimony payments',
    'Other Debt': 'All forms of other debt not covered above',
  };

  final transportationTextMap = <String, String>{
    'Gas': 'Fuel for personal car',
    'Auto Insurance': 'Insurance for personal car',
    'Public Transportation':
        'Uber, lyft, other public transport such as trains, taxi etc',
    'Auto Repairs':
        'Auto repairs, tires & parts purchased, insurance deductibles paid',
    'Auto Expenses': 'Parking & tolls, registration/tabs, car wash, oil change',
  };

  final livingExpensesTextMap = <String, String>{
    'Groceries': 'Regular grocery shopping',
    'Clothing':
        'Essential clothing & basic family needs such as bedding. Exclude Fun Shopping described below',
    'Phone Bill': 'Personal phone bill(s)',
    'Internet and TV': 'Internet and TV subscription plans and fees',
    'Household Basics':
        'Basic household supplies inc. toileteries, laundry items, kitchen supplies',
    'Health Insurance': 'Medical, dental, & vision premiums',
    'Healthcare Expenses':
        'Out of pocket medical costs such as perscription, doctor visits, copays, glasses/contacts, supplements',
    'Pet Expenses':
        'Expenses related to pets including food, care & other services',
  };

  final discretionarySpendingTextMap = <String, String>{
    'Vacation': 'Expenses',
    'Entertainment':
        'Includes recreation, entertainment, hobbies and personal interests',
    'Coffee & Eating out': 'All restaurant and coffee shop purchases',
    'Dry Cleaning': 'Cost of dry cleaning and laundry services',
    'Furniture & Decor': 'Home furniture and decor expenses',
    'House Help': 'Home cleaning services such maid service',
    'Personal Care': 'Gym, grooming, stylist visits, wellness, etc',
    'Personal Development':
        'Training, coursework, books, equipment to increase your skills and potential. Include association fees',
    'Professional Services':
        'Payments for a financial advisor, CPA, tax planning, consulting, coaching',
    'Elective Insurances': 'Inc life insurance, disability insurance, etc',
    'Subscriptions':
        'All types of digital subscriptions including your Vlorish subscription cost, Netflix, Prime, etc',
    'Fun Shopping':
        'Shopping other than for basic clothing. Includes gadgets, gaming, phones, & fashion shopping',
  };

  final kidsTextMap = <String, String>{
    'Child Care': 'Child care, daycare, babysitting or nanny service',
    'College Fund':
        'Monies set aside or contributed to establish a college fund for a minor',
    'Tuition & Fees':
        'Tuition and fees for a private k-12, higher education, or other special school',
    'School Lunches': 'In school meals',
    'Tutoring': 'Private tutoring fees',
    'Activities': 'Extracurricular activities',
    'Allowance': 'Kids\' allowances',
    'Child Support': 'Child support obligation payments'
  };

  final givingTextMap = <String, String>{
    'Family support': 'Financial support to family members and relatives',
    'Donations':
        'Charitable donations to nonfamily such as religious organization',
    'Gifts': 'Both cash and noncash gifts'
  };

  final taxesTextMap = <String, String>{
    'Estimated Federal Income Taxes':
        'Estimated state income tax payments for current year taxes or remaining balance due from last year taxes',
    'Estimated State Income Taxes':
        'Estimated state income tax payments for current year taxes or remaining balance due from last year taxes',
    'Back Taxes':
        'Past due federal and state income tax payments, including amounts in collections and on payment plans'
  };

  final otherExpensesTextMap = <String, String>{
    'Misc Expenses':
        'Use to aggregate small miscellaneous expenses including minor one-off unplanned expenses',
    'Uncategorized Expenses':
        'Temporary account used to hold expenses that are unclear which need your input for proper category selection',
  };

  final totalExpensesTextMap = <String, String>{
    'Net income': 'Total Income minus Total expenses',
    'Goals': 'Funding or money set aside for personal goals',
    'Total Cash Reserve':
        'Cash available for spending after expenses have been paid and goals have been funded',
    'Investments':
        'Investments made from the cash reserve, often in larger amounts that require substantial cash reserves',
    'Free cash':
        'Cash available for spending on whatever or kept as a small cushion after all expenses, goals, & investments'
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

class BusinessCategoryGuidelineWidget extends StatelessWidget {
  BusinessCategoryGuidelineWidget({Key? key}) : super(key: key);

  final generalBusinessTextMap = <String, String>{
    'Business Income': 'Income generated by the business from core services',
    'Other Income': 'Auxiliary income received by the business',
    'Loan Received': 'Loans received by the business',
    'Investment in Business':
        'Investments in the business made by the owner or 3rd parties',
    'Uncategorized Income':
        'Temporary account used to hold income that is uncear or unknown which need your input for proper category selection',
  };
  // Personnel Costs
  final personnelCostsBusinessTextMap = <String, String>{
    'Owner Pay':
        'Do not include owner draw or transfers, only w-2 salary form the company',
    'Staff Salaries': 'Non-owner salaries and pay',
    'Employee Benefits': '401k, health insurance, etc. gifts, Including owner',
    'Payroll Taxes': 'Employer portion of FICA taxes',
  };
  // Professional Services
  final professionalServicesBusinessTextMap = <String, String>{
    'Accounting': 'Bookkeeping, payroll, & tax services',
    'Pinancial Planning': 'Financial planning for business or side hussle',
    'Content Writing': 'Content/copy writing',
    'Social Media Management':
        'Payments to professional for social media management/services',
    'Video Production & Editing':
        'Payments for nonemployee professional related to video production/editing',
    'Software Development':
        'Software development costs withtin the whole scope of web/mobile development',
    'E-commerce Assistant': 'E-commerce assistant pay (non w-2)',
    'Admin Assistant': 'Admin assistant pay (non w-2)',
    'Legal and Professional Services':
        'Legal fees and consulting services fees not covered above',
  };
  // Property Management,
  final propertyManagementBusinessTextMap = <String, String>{
    'Mortgage Payments':
        'Includes mortgage payment, property taxes, insurance, & HOA',
    'Leasing and Property Management':
        'Costs associated with leasing and professional property management',
    'Repairs and Maintenance':
        'Repairs and maintenance including minor eplacment costs, routine fixing, and cleaning',
    'Capital expenditures':
        'Major property improvements expenditures including additions and overhauls',
    'Depreication Expenses': 'Noncash expenses booked by your accountant',
  };
  // Product Costs,
  final productCostsBusinessTextMap = <String, String>{
    'Product Cost': 'Cost to acquire products, inventory cost',
    'Fullfillment Fees':
        'Fullfilling costs associated with product delivery such as packaging',
    'Storage Fees': 'Storage and warehousing costs',
    'Shipping & Handling':
        'Shipping and handling including postage, delivery, freight, and other transportation costs',
    'Online Selling Plans':
        'Revenue sharing arrangements with online sales platforms that keep a percentage of your sales like Amazon',
    'Merchant Fees': 'Transaction costs',
    'Sales Tax': 'Sales tax',
    'Customs and Brokers':
        'Customs tax and clearing costs for cross-border transactions',
    'Returns': 'Product returns',
    'Product loss': 'Shrinkage, theft, and loss',
  };
  // Business Development,
  final businessDevelopmentBusinessTextMap = <String, String>{
    'Advertising & Marketing':
        'Advertisement, marketing, and brand development costs',
    'Referral Fees':
        'Commissions paid by the business to others for referrals.',
    'Other Business Development':
        'Other business development costs not captured above',
  };
  // Office Expenses,
  final officeExpensesBusinessTextMap = <String, String>{
    'Office rent & utilities': 'Rent and utilities',
    'Office Supplies': 'Office supplies and printing',
    'Office Equipment': 'Computers, phones, cameras, etc',
    'Office Furnishing & Decor': 'Furniture and decor for the office',
    'Other Office Expenses': 'Water, repairs, etc',
  };
  // General Business Expenses,
  final generalBusinessExpensesBusinessTextMap = <String, String>{
    'Technology Fees & Subscriptions':
        'Include technology fees such as software subscriptions, email service, web hosting, that are used to power business',
    'Auto Expenses':
        'Expenses related to operating and maintaining a business car including fuel, mileage, registration, repair and insurance',
    'Phone & Internet': 'Business phone and internet cost',
    'Business Meals 1': 'Business meals furnished outside business premises',
    'Business Meals 2': 'Business meals furnished on business premises',
    'Business Entertainment': 'Costs associated with business entertainment',
    'Travel Expenses':
        'Travel related to business function or business development',
    'Events & Venue Fees': 'Events and venue booking and related expenses',
    'Business Licenses & Fees': 'Business licenses, registrations, & fees',
    'Professional Development':
        'Continuing education for employees including owner paid by business',
  };
  // Debts Payments,
  final debtsPaymentsBusinessTextMap = <String, String>{
    'Credit Card': 'Business credit card payment',
    'Auto Loan': 'Business car payment',
    'Business Loan': 'Repayments of business loans',
  };
  // Other Expenses,
  final otherExpensesBusinessTextMap = <String, String>{
    'Misc Expenses':
        'Use to aggregate small miscellaneous expenses including minor one-off unplanned expenses',
    'Uncategorized Expenses':
        'Temporary account used to hold expenses that are uncear or unknown which need your input for proper category selection',
  };
  // Total Expenses,
  final totalExpensesBusinessTextMap = <String, String>{
    'Net Income': 'Income after expenses have been paid',
    'Owner draw': 'Owner draw or amounts transfered to owner as a draw',
    'Retained in the Business': 'Income remaining after owner draw',
    'Ending Cash Reserve':
        'Ending cash reserve, which is previous cash reserve plus amount retained in the business this month',
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
