import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navBranches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get navBranches;

  /// No description provided for @navApproaches.
  ///
  /// In en, this message translates to:
  /// **'Concept'**
  String get navApproaches;

  /// No description provided for @navCoaches.
  ///
  /// In en, this message translates to:
  /// **'Coaches'**
  String get navCoaches;

  /// No description provided for @navPricing.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get navPricing;

  /// No description provided for @navBlog.
  ///
  /// In en, this message translates to:
  /// **'Magazine'**
  String get navBlog;

  /// No description provided for @navContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get navContact;

  /// No description provided for @navJoin.
  ///
  /// In en, this message translates to:
  /// **'Join Now'**
  String get navJoin;

  /// No description provided for @navMemberSpace.
  ///
  /// In en, this message translates to:
  /// **'Member Area'**
  String get navMemberSpace;

  /// No description provided for @navLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get navLogin;

  /// No description provided for @navWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get navWorkouts;

  /// No description provided for @navChallenge.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get navChallenge;

  /// No description provided for @navPartners.
  ///
  /// In en, this message translates to:
  /// **'Partners'**
  String get navPartners;

  /// No description provided for @heroPivotTitle.
  ///
  /// In en, this message translates to:
  /// **'FORGE YOUR LEGACY'**
  String get heroPivotTitle;

  /// No description provided for @heroPivotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join the elite movement. No excuses. Just results.'**
  String get heroPivotSubtitle;

  /// No description provided for @navCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get navCardio;

  /// No description provided for @navStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get navStrength;

  /// No description provided for @navHybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get navHybrid;

  /// No description provided for @navRecover.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get navRecover;

  /// No description provided for @navAlgiers.
  ///
  /// In en, this message translates to:
  /// **'Algiers'**
  String get navAlgiers;

  /// No description provided for @navOran.
  ///
  /// In en, this message translates to:
  /// **'Oran'**
  String get navOran;

  /// No description provided for @navConstantine.
  ///
  /// In en, this message translates to:
  /// **'Constantine'**
  String get navConstantine;

  /// No description provided for @navAnnaba.
  ///
  /// In en, this message translates to:
  /// **'Annaba'**
  String get navAnnaba;

  /// No description provided for @navNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get navNutrition;

  /// No description provided for @navGear.
  ///
  /// In en, this message translates to:
  /// **'Gear'**
  String get navGear;

  /// No description provided for @navSponsors.
  ///
  /// In en, this message translates to:
  /// **'Sponsors'**
  String get navSponsors;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'UNLEASH YOUR\nPOTENTIAL'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Experience the ultimate fitness journey at Algeria\'s premier gym network.'**
  String get heroSubtitle;

  /// No description provided for @heroCta.
  ///
  /// In en, this message translates to:
  /// **'Start Free Trial'**
  String get heroCta;

  /// No description provided for @heroFindClub.
  ///
  /// In en, this message translates to:
  /// **'Find Your Club'**
  String get heroFindClub;

  /// No description provided for @sectionWhyUs.
  ///
  /// In en, this message translates to:
  /// **'Why Choose Gym Élysée?'**
  String get sectionWhyUs;

  /// No description provided for @sectionClasses.
  ///
  /// In en, this message translates to:
  /// **'Signature Classes'**
  String get sectionClasses;

  /// No description provided for @sectionTransformation.
  ///
  /// In en, this message translates to:
  /// **'Real Transformations'**
  String get sectionTransformation;

  /// No description provided for @footerRights.
  ///
  /// In en, this message translates to:
  /// **'All rights reserved.'**
  String get footerRights;

  /// No description provided for @footerPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get footerPrivacy;

  /// No description provided for @footerTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get footerTerms;

  /// No description provided for @contactTitleFirst.
  ///
  /// In en, this message translates to:
  /// **'LET\'S TALK ABOUT'**
  String get contactTitleFirst;

  /// No description provided for @contactTitleSecond.
  ///
  /// In en, this message translates to:
  /// **'YOUR GOALS'**
  String get contactTitleSecond;

  /// No description provided for @contactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Our team is available to answer all your questions and support you on your fitness journey'**
  String get contactSubtitle;

  /// No description provided for @contactFormTitle.
  ///
  /// In en, this message translates to:
  /// **'SEND US A MESSAGE'**
  String get contactFormTitle;

  /// No description provided for @contactNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get contactNameLabel;

  /// No description provided for @contactNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get contactNameHint;

  /// No description provided for @contactEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email *'**
  String get contactEmailLabel;

  /// No description provided for @contactPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone *'**
  String get contactPhoneLabel;

  /// No description provided for @contactBranchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch of interest'**
  String get contactBranchLabel;

  /// No description provided for @contactMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message *'**
  String get contactMessageLabel;

  /// No description provided for @contactMessageHint.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get contactMessageHint;

  /// No description provided for @contactSendButton.
  ///
  /// In en, this message translates to:
  /// **'SEND MESSAGE'**
  String get contactSendButton;

  /// No description provided for @contactWhatsappTitle.
  ///
  /// In en, this message translates to:
  /// **'WHATSAPP BUSINESS'**
  String get contactWhatsappTitle;

  /// No description provided for @contactWhatsappSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fast response guaranteed'**
  String get contactWhatsappSubtitle;

  /// No description provided for @contactInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'CONTACT INFORMATION'**
  String get contactInfoTitle;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'PHONE'**
  String get contactPhone;

  /// No description provided for @contactHours.
  ///
  /// In en, this message translates to:
  /// **'OPENING HOURS'**
  String get contactHours;

  /// No description provided for @contactHoursValue.
  ///
  /// In en, this message translates to:
  /// **'Mon-Fri: 6am-10pm\nSat-Sun: 8am-8pm'**
  String get contactHoursValue;

  /// No description provided for @contactAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'OUR LOCATIONS'**
  String get contactAddressTitle;

  /// No description provided for @contactFindUsTitle.
  ///
  /// In en, this message translates to:
  /// **'FIND US'**
  String get contactFindUsTitle;

  /// No description provided for @contactFindUsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'6 BRANCHES IN ALGERIA'**
  String get contactFindUsSubtitle;

  /// No description provided for @pricingTitleFirst.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE'**
  String get pricingTitleFirst;

  /// No description provided for @pricingTitleSecond.
  ///
  /// In en, this message translates to:
  /// **'YOUR PLAN'**
  String get pricingTitleSecond;

  /// No description provided for @pricingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Flexible membership options designed for your fitness journey'**
  String get pricingSubtitle;

  /// No description provided for @pricingAnnualSavingsPrefix.
  ///
  /// In en, this message translates to:
  /// **'SAVE UP TO'**
  String get pricingAnnualSavingsPrefix;

  /// No description provided for @pricingPerYear.
  ///
  /// In en, this message translates to:
  /// **'/ YEAR'**
  String get pricingPerYear;

  /// No description provided for @pricingPerMonth.
  ///
  /// In en, this message translates to:
  /// **'/ MONTH'**
  String get pricingPerMonth;

  /// No description provided for @pricingPerQuarter.
  ///
  /// In en, this message translates to:
  /// **'/ QUARTER'**
  String get pricingPerQuarter;

  /// No description provided for @pricingPlanMonthly.
  ///
  /// In en, this message translates to:
  /// **'MONTHLY'**
  String get pricingPlanMonthly;

  /// No description provided for @pricingSubMonthly.
  ///
  /// In en, this message translates to:
  /// **'No commitment'**
  String get pricingSubMonthly;

  /// No description provided for @pricingBtnMonthly.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE MONTHLY'**
  String get pricingBtnMonthly;

  /// No description provided for @pricingPlanQuarterly.
  ///
  /// In en, this message translates to:
  /// **'QUARTERLY'**
  String get pricingPlanQuarterly;

  /// No description provided for @pricingSubQuarterly.
  ///
  /// In en, this message translates to:
  /// **'3 Months Commitment'**
  String get pricingSubQuarterly;

  /// No description provided for @pricingBtnQuarterly.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE QUARTERLY'**
  String get pricingBtnQuarterly;

  /// No description provided for @pricingSave3k.
  ///
  /// In en, this message translates to:
  /// **'SAVE 3,000 DZD'**
  String get pricingSave3k;

  /// No description provided for @pricingPlanAnnual.
  ///
  /// In en, this message translates to:
  /// **'ANNUAL'**
  String get pricingPlanAnnual;

  /// No description provided for @pricingSubAnnual.
  ///
  /// In en, this message translates to:
  /// **'12 Months Commitment'**
  String get pricingSubAnnual;

  /// No description provided for @pricingBtnAnnual.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE ANNUAL'**
  String get pricingBtnAnnual;

  /// No description provided for @pricingSave21k.
  ///
  /// In en, this message translates to:
  /// **'SAVE 21,000 DZD'**
  String get pricingSave21k;

  /// No description provided for @pricingBestValue.
  ///
  /// In en, this message translates to:
  /// **'BEST VALUE'**
  String get pricingBestValue;

  /// No description provided for @pricingCompTitleFirst.
  ///
  /// In en, this message translates to:
  /// **'DETAILED'**
  String get pricingCompTitleFirst;

  /// No description provided for @pricingCompTitleSecond.
  ///
  /// In en, this message translates to:
  /// **'COMPARISON'**
  String get pricingCompTitleSecond;

  /// No description provided for @pricingPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'PAY IN 3X'**
  String get pricingPaymentTitle;

  /// No description provided for @pricingPaymentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Free of charge installments for annual plans'**
  String get pricingPaymentSubtitle;

  /// No description provided for @pricingCtaTitleFirst.
  ///
  /// In en, this message translates to:
  /// **'READY TO'**
  String get pricingCtaTitleFirst;

  /// No description provided for @pricingCtaTitleSecond.
  ///
  /// In en, this message translates to:
  /// **'START?'**
  String get pricingCtaTitleSecond;

  /// No description provided for @pricingCtaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join the elite today and start your transformation.'**
  String get pricingCtaSubtitle;

  /// No description provided for @pricingCtaButton.
  ///
  /// In en, this message translates to:
  /// **'START TODAY'**
  String get pricingCtaButton;

  /// No description provided for @branchesTitleTag.
  ///
  /// In en, this message translates to:
  /// **'OUR BRANCHES'**
  String get branchesTitleTag;

  /// No description provided for @branchesTitleFirst.
  ///
  /// In en, this message translates to:
  /// **'6 GYMS'**
  String get branchesTitleFirst;

  /// No description provided for @branchesTitleSecond.
  ///
  /// In en, this message translates to:
  /// **'OF EXCELLENCE'**
  String get branchesTitleSecond;

  /// No description provided for @branchesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'6 premium locations across Algeria, each with its specialty and expert team'**
  String get branchesSubtitle;

  /// No description provided for @branchesCtaTitle1.
  ///
  /// In en, this message translates to:
  /// **'FIND YOUR '**
  String get branchesCtaTitle1;

  /// No description provided for @branchesCtaTitle2.
  ///
  /// In en, this message translates to:
  /// **'PERFECT GYM'**
  String get branchesCtaTitle2;

  /// No description provided for @branchesCtaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visit one of our 6 branches and discover fitness excellence in Algeria'**
  String get branchesCtaSubtitle;

  /// No description provided for @branchesCtaButton.
  ///
  /// In en, this message translates to:
  /// **'1 WEEK FREE TRIAL'**
  String get branchesCtaButton;

  /// No description provided for @branchesHoursWeek.
  ///
  /// In en, this message translates to:
  /// **'Mon-Fri: 6am - 10pm'**
  String get branchesHoursWeek;

  /// No description provided for @branchesHoursRamadan.
  ///
  /// In en, this message translates to:
  /// **'Ramadan: 10pm - 2am & 4am - 7am'**
  String get branchesHoursRamadan;

  /// No description provided for @branchesViewDetails.
  ///
  /// In en, this message translates to:
  /// **'VIEW DETAILS'**
  String get branchesViewDetails;

  /// No description provided for @branchesTagPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get branchesTagPremium;

  /// No description provided for @blogTitle.
  ///
  /// In en, this message translates to:
  /// **'THE MAGAZINE'**
  String get blogTitle;

  /// No description provided for @blogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Insights on training, nutrition, and lifestyle.'**
  String get blogSubtitle;

  /// No description provided for @blogReadArticle.
  ///
  /// In en, this message translates to:
  /// **'Read Article'**
  String get blogReadArticle;

  /// No description provided for @blogTagTraining.
  ///
  /// In en, this message translates to:
  /// **'TRAINING'**
  String get blogTagTraining;

  /// No description provided for @dummyArticleTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Master the Deadlift in 3 Steps'**
  String get dummyArticleTitle;

  /// No description provided for @dummyArticleCategory.
  ///
  /// In en, this message translates to:
  /// **'TRAINING'**
  String get dummyArticleCategory;

  /// No description provided for @dummyArticleContent.
  ///
  /// In en, this message translates to:
  /// **'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'**
  String get dummyArticleContent;

  /// No description provided for @workoutsTitleFirst.
  ///
  /// In en, this message translates to:
  /// **'OUR'**
  String get workoutsTitleFirst;

  /// No description provided for @workoutsTitleSecond.
  ///
  /// In en, this message translates to:
  /// **'PROGRAMS'**
  String get workoutsTitleSecond;

  /// No description provided for @workoutsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'ELEVATE YOUR GAME'**
  String get workoutsSubtitle;

  /// No description provided for @workoutsCtaTitle.
  ///
  /// In en, this message translates to:
  /// **'BOOK YOUR FREE TRIAL'**
  String get workoutsCtaTitle;

  /// No description provided for @workoutsCtaText.
  ///
  /// In en, this message translates to:
  /// **'Try any program for free with a certified coach.'**
  String get workoutsCtaText;

  /// No description provided for @workoutsCtaButton.
  ///
  /// In en, this message translates to:
  /// **'BOOK NOW'**
  String get workoutsCtaButton;

  /// No description provided for @workoutsDetailsButton.
  ///
  /// In en, this message translates to:
  /// **'DETAILS'**
  String get workoutsDetailsButton;

  /// No description provided for @workoutsBookSessionButton.
  ///
  /// In en, this message translates to:
  /// **'BOOK A SESSION'**
  String get workoutsBookSessionButton;

  /// No description provided for @workoutsBookingMsg.
  ///
  /// In en, this message translates to:
  /// **'Booking for {program} in progress...'**
  String workoutsBookingMsg(Object program);

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediate;

  /// No description provided for @levelAllLevels.
  ///
  /// In en, this message translates to:
  /// **'All Levels'**
  String get levelAllLevels;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelBeginner;

  /// No description provided for @programHyroxDesc.
  ///
  /// In en, this message translates to:
  /// **'High intensity fitness racing competition training.'**
  String get programHyroxDesc;

  /// No description provided for @programPowerliftingDesc.
  ///
  /// In en, this message translates to:
  /// **'Maximize your 1RM with structured strength protocols.'**
  String get programPowerliftingDesc;

  /// No description provided for @programBoxingDesc.
  ///
  /// In en, this message translates to:
  /// **'Technical striking, footwork, and conditioning.'**
  String get programBoxingDesc;

  /// No description provided for @programYogaDesc.
  ///
  /// In en, this message translates to:
  /// **'Mobility, flexibility, and mindfulness practice.'**
  String get programYogaDesc;

  /// No description provided for @programCrossfitDesc.
  ///
  /// In en, this message translates to:
  /// **'Functional movements at high intensity.'**
  String get programCrossfitDesc;

  /// No description provided for @programRecoveryDesc.
  ///
  /// In en, this message translates to:
  /// **'Active recovery and regeneration sessions.'**
  String get programRecoveryDesc;

  /// No description provided for @partnersTitleFirst.
  ///
  /// In en, this message translates to:
  /// **'OUR'**
  String get partnersTitleFirst;

  /// No description provided for @partnersTitleSecond.
  ///
  /// In en, this message translates to:
  /// **'PARTNERS'**
  String get partnersTitleSecond;

  /// No description provided for @partnersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exceptional brands for your transformation'**
  String get partnersSubtitle;

  /// No description provided for @partnerCategoryNutrition.
  ///
  /// In en, this message translates to:
  /// **'NUTRITION'**
  String get partnerCategoryNutrition;

  /// No description provided for @partnerCategoryEquipment.
  ///
  /// In en, this message translates to:
  /// **'EQUIPMENT'**
  String get partnerCategoryEquipment;

  /// No description provided for @partnerCategoryMachines.
  ///
  /// In en, this message translates to:
  /// **'MACHINES'**
  String get partnerCategoryMachines;

  /// No description provided for @partnerDescOptimum.
  ///
  /// In en, this message translates to:
  /// **'Premium supplements for performance'**
  String get partnerDescOptimum;

  /// No description provided for @partnerDescNike.
  ///
  /// In en, this message translates to:
  /// **'Sports apparel and footwear'**
  String get partnerDescNike;

  /// No description provided for @partnerDescMuscleTech.
  ///
  /// In en, this message translates to:
  /// **'High-quality proteins and creatine'**
  String get partnerDescMuscleTech;

  /// No description provided for @partnerDescUnderArmour.
  ///
  /// In en, this message translates to:
  /// **'Performance and style daily'**
  String get partnerDescUnderArmour;

  /// No description provided for @partnerDescMyProtein.
  ///
  /// In en, this message translates to:
  /// **'Accessible food supplements'**
  String get partnerDescMyProtein;

  /// No description provided for @partnerDescTechnogym.
  ///
  /// In en, this message translates to:
  /// **'High-end fitness equipment'**
  String get partnerDescTechnogym;

  /// No description provided for @partnerDescLifeFitness.
  ///
  /// In en, this message translates to:
  /// **'Professional cardio and strength'**
  String get partnerDescLifeFitness;

  /// No description provided for @partnerDescHammer.
  ///
  /// In en, this message translates to:
  /// **'Maximum strength and power'**
  String get partnerDescHammer;

  /// No description provided for @partnersCtaTitle.
  ///
  /// In en, this message translates to:
  /// **'BECOME A PARTNER'**
  String get partnersCtaTitle;

  /// No description provided for @partnersCtaText.
  ///
  /// In en, this message translates to:
  /// **'Join our network of premium partners and benefit from exceptional visibility.'**
  String get partnersCtaText;

  /// No description provided for @partnersCtaButton.
  ///
  /// In en, this message translates to:
  /// **'CONTACT US'**
  String get partnersCtaButton;

  /// No description provided for @challengesTitleMain.
  ///
  /// In en, this message translates to:
  /// **'LEADERBOARD'**
  String get challengesTitleMain;

  /// No description provided for @challengesSlogan.
  ///
  /// In en, this message translates to:
  /// **'COMPETE. WIN. REPEAT.'**
  String get challengesSlogan;

  /// No description provided for @challengeOfTheMonth.
  ///
  /// In en, this message translates to:
  /// **'CHALLENGE OF THE MONTH'**
  String get challengeOfTheMonth;

  /// No description provided for @challengeTitle.
  ///
  /// In en, this message translates to:
  /// **'30 DAYS OF TRANSFORMATION'**
  String get challengeTitle;

  /// No description provided for @challengeDesc.
  ///
  /// In en, this message translates to:
  /// **'Burn maximum calories and earn exclusive rewards'**
  String get challengeDesc;

  /// No description provided for @daysRemaining.
  ///
  /// In en, this message translates to:
  /// **'DAYS REMAINING'**
  String get daysRemaining;

  /// No description provided for @joinChallengeButton.
  ///
  /// In en, this message translates to:
  /// **'JOIN'**
  String get joinChallengeButton;

  /// No description provided for @leaderboardTitleSection.
  ///
  /// In en, this message translates to:
  /// **'RANKING'**
  String get leaderboardTitleSection;

  /// No description provided for @challengeRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'CHALLENGE RULES'**
  String get challengeRulesTitle;

  /// No description provided for @rule1Title.
  ///
  /// In en, this message translates to:
  /// **'Log every session'**
  String get rule1Title;

  /// No description provided for @rule1Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the app to track your workouts and earn points'**
  String get rule1Desc;

  /// No description provided for @rule2Title.
  ///
  /// In en, this message translates to:
  /// **'Earn bonuses'**
  String get rule2Title;

  /// No description provided for @rule2Desc.
  ///
  /// In en, this message translates to:
  /// **'+50% points for sessions before 8 AM'**
  String get rule2Desc;

  /// No description provided for @rule3Title.
  ///
  /// In en, this message translates to:
  /// **'Invite your friends'**
  String get rule3Title;

  /// No description provided for @rule3Desc.
  ///
  /// In en, this message translates to:
  /// **'Each referral increases your score by 500 points'**
  String get rule3Desc;

  /// No description provided for @rule4Title.
  ///
  /// In en, this message translates to:
  /// **'Claim your rewards'**
  String get rule4Title;

  /// No description provided for @rule4Desc.
  ///
  /// In en, this message translates to:
  /// **'Top 3: 1 month free | Top 10: -50% | Top 20: Goodies'**
  String get rule4Desc;

  /// No description provided for @contactSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Message sent successfully!'**
  String get contactSuccessMessage;

  /// No description provided for @contactErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String contactErrorMessage(Object error);

  /// No description provided for @contactEmailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'your@email.com'**
  String get contactEmailPlaceholder;

  /// No description provided for @contactPhonePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'+213 XXX XXX XXX'**
  String get contactPhonePlaceholder;

  /// No description provided for @contactBranchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Choose a branch'**
  String get contactBranchPlaceholder;

  /// No description provided for @contactEmailValue.
  ///
  /// In en, this message translates to:
  /// **'contact@gymelysee.dz'**
  String get contactEmailValue;

  /// No description provided for @contactPhoneValue.
  ///
  /// In en, this message translates to:
  /// **'+213 555 123 456'**
  String get contactPhoneValue;

  /// No description provided for @contactAddressValue.
  ///
  /// In en, this message translates to:
  /// **'123 Rue des Jardins, Hydra, Algiers 16035'**
  String get contactAddressValue;

  /// No description provided for @branchAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get branchAbout;

  /// No description provided for @branchGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo Gallery'**
  String get branchGallery;

  /// No description provided for @branchEquipments.
  ///
  /// In en, this message translates to:
  /// **'Equipments & Services'**
  String get branchEquipments;

  /// No description provided for @branchTeam.
  ///
  /// In en, this message translates to:
  /// **'Our Team'**
  String get branchTeam;

  /// No description provided for @branchLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get branchLocation;

  /// No description provided for @branchHours.
  ///
  /// In en, this message translates to:
  /// **'Opening Hours'**
  String get branchHours;

  /// No description provided for @branchContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Direct Contact'**
  String get branchContactTitle;

  /// No description provided for @branchVisitTitle.
  ///
  /// In en, this message translates to:
  /// **'Request a Visit'**
  String get branchVisitTitle;

  /// No description provided for @branchVisitName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get branchVisitName;

  /// No description provided for @branchVisitEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get branchVisitEmail;

  /// No description provided for @branchVisitPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get branchVisitPhone;

  /// No description provided for @branchVisitDate.
  ///
  /// In en, this message translates to:
  /// **'yyyy-mm-dd'**
  String get branchVisitDate;

  /// No description provided for @branchVisitMessage.
  ///
  /// In en, this message translates to:
  /// **'Message (optional)'**
  String get branchVisitMessage;

  /// No description provided for @branchVisitButton.
  ///
  /// In en, this message translates to:
  /// **'Book My Visit'**
  String get branchVisitButton;

  /// No description provided for @branchVisitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Visit request sent!'**
  String get branchVisitSuccess;

  /// No description provided for @branchReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Member Reviews'**
  String get branchReviewsTitle;

  /// No description provided for @branchBackLink.
  ///
  /// In en, this message translates to:
  /// **'Back to branches'**
  String get branchBackLink;

  /// No description provided for @branchErrorId.
  ///
  /// In en, this message translates to:
  /// **'Invalid Branch ID'**
  String get branchErrorId;

  /// No description provided for @branchErrorNotFound.
  ///
  /// In en, this message translates to:
  /// **'No branch found'**
  String get branchErrorNotFound;

  /// No description provided for @branchRamadan.
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get branchRamadan;

  /// No description provided for @formRequiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get formRequiredField;

  /// No description provided for @branchTypeMixte.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get branchTypeMixte;

  /// No description provided for @branchTypeWomen.
  ///
  /// In en, this message translates to:
  /// **'Women Only'**
  String get branchTypeWomen;

  /// No description provided for @branchTypeCrossfit.
  ///
  /// In en, this message translates to:
  /// **'CrossFit'**
  String get branchTypeCrossfit;

  /// No description provided for @specialtyBodybuilding.
  ///
  /// In en, this message translates to:
  /// **'Bodybuilding'**
  String get specialtyBodybuilding;

  /// No description provided for @specialtyMMA.
  ///
  /// In en, this message translates to:
  /// **'MMA & Boxing'**
  String get specialtyMMA;

  /// No description provided for @specialtyCrossfit.
  ///
  /// In en, this message translates to:
  /// **'CrossFit'**
  String get specialtyCrossfit;

  /// No description provided for @pricingFeature1Branch.
  ///
  /// In en, this message translates to:
  /// **'Access to 1 branch of choice'**
  String get pricingFeature1Branch;

  /// No description provided for @pricingFeatureGroupClasses.
  ///
  /// In en, this message translates to:
  /// **'Unlimited group classes'**
  String get pricingFeatureGroupClasses;

  /// No description provided for @pricingFeatureLockers.
  ///
  /// In en, this message translates to:
  /// **'Premium locker rooms & showers'**
  String get pricingFeatureLockers;

  /// No description provided for @pricingFeatureMobileApp.
  ///
  /// In en, this message translates to:
  /// **'Mobile app'**
  String get pricingFeatureMobileApp;

  /// No description provided for @pricingFeatureAllBranches.
  ///
  /// In en, this message translates to:
  /// **'Access to all branches'**
  String get pricingFeatureAllBranches;

  /// No description provided for @pricingFeature2PrivateSessions.
  ///
  /// In en, this message translates to:
  /// **'2 private sessions included'**
  String get pricingFeature2PrivateSessions;

  /// No description provided for @pricingFeature1GuestMonth.
  ///
  /// In en, this message translates to:
  /// **'1 free guest/month'**
  String get pricingFeature1GuestMonth;

  /// No description provided for @pricingFeatureUnlimitedBranches.
  ///
  /// In en, this message translates to:
  /// **'Unlimited access all branches'**
  String get pricingFeatureUnlimitedBranches;

  /// No description provided for @pricingFeature5PrivateSessions.
  ///
  /// In en, this message translates to:
  /// **'5 private sessions included'**
  String get pricingFeature5PrivateSessions;

  /// No description provided for @pricingFeature3GuestsMonth.
  ///
  /// In en, this message translates to:
  /// **'3 free guests/month'**
  String get pricingFeature3GuestsMonth;

  /// No description provided for @pricingFeatureBodyAssessment.
  ///
  /// In en, this message translates to:
  /// **'Quarterly body assessment'**
  String get pricingFeatureBodyAssessment;

  /// No description provided for @pricingFeatureNutritionPlan.
  ///
  /// In en, this message translates to:
  /// **'Personalized nutrition plan'**
  String get pricingFeatureNutritionPlan;

  /// No description provided for @pricingFeaturePriorityAccess.
  ///
  /// In en, this message translates to:
  /// **'Priority access to new classes'**
  String get pricingFeaturePriorityAccess;

  /// No description provided for @pricingFeature3xPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment in 3x interest-free'**
  String get pricingFeature3xPayment;

  /// No description provided for @compTableFeature.
  ///
  /// In en, this message translates to:
  /// **'FEATURE'**
  String get compTableFeature;

  /// No description provided for @compMonthlyEquiv.
  ///
  /// In en, this message translates to:
  /// **'Monthly equivalent'**
  String get compMonthlyEquiv;

  /// No description provided for @compBranchAccess.
  ///
  /// In en, this message translates to:
  /// **'Branch access'**
  String get compBranchAccess;

  /// No description provided for @compGroupClasses.
  ///
  /// In en, this message translates to:
  /// **'Group classes'**
  String get compGroupClasses;

  /// No description provided for @compPrivateSessions.
  ///
  /// In en, this message translates to:
  /// **'Private sessions'**
  String get compPrivateSessions;

  /// No description provided for @compFreeGuests.
  ///
  /// In en, this message translates to:
  /// **'Free guests'**
  String get compFreeGuests;

  /// No description provided for @compBodyAssessment.
  ///
  /// In en, this message translates to:
  /// **'Body assessment'**
  String get compBodyAssessment;

  /// No description provided for @compNutritionPlan.
  ///
  /// In en, this message translates to:
  /// **'Nutrition plan'**
  String get compNutritionPlan;

  /// No description provided for @comp3xPayment.
  ///
  /// In en, this message translates to:
  /// **'3x payment'**
  String get comp3xPayment;

  /// No description provided for @compValueOneBranch.
  ///
  /// In en, this message translates to:
  /// **'1 branch'**
  String get compValueOneBranch;

  /// No description provided for @compValueAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get compValueAll;

  /// No description provided for @compValueUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get compValueUnlimited;

  /// No description provided for @compValueQuarterly.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get compValueQuarterly;

  /// No description provided for @qrQuickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get qrQuickAccess;

  /// No description provided for @qrSectionDesc.
  ///
  /// In en, this message translates to:
  /// **'No more waiting in line! Scan your personal QR code at the gym entrance for instant access. Track your workouts, manage your bookings, and receive real-time notifications.'**
  String get qrSectionDesc;

  /// No description provided for @reviewPlaceholder1.
  ///
  /// In en, this message translates to:
  /// **'Best gym in Algiers! Top-notch equipment.'**
  String get reviewPlaceholder1;

  /// No description provided for @reviewPlaceholder2.
  ///
  /// In en, this message translates to:
  /// **'Respectful atmosphere and very professional coaches.'**
  String get reviewPlaceholder2;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorGeneric;

  /// No description provided for @newsletterTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay Informed'**
  String get newsletterTitle;

  /// No description provided for @newsletterTitleThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank You!'**
  String get newsletterTitleThanks;

  /// No description provided for @newsletterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive our fitness tips, recipes and exclusive offers directly in your inbox'**
  String get newsletterSubtitle;

  /// No description provided for @newsletterSubtitleSuccess.
  ///
  /// In en, this message translates to:
  /// **'You are now subscribed to our newsletter.'**
  String get newsletterSubtitleSuccess;

  /// No description provided for @newsletterPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your email'**
  String get newsletterPlaceholder;

  /// No description provided for @newsletterButton.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get newsletterButton;

  /// No description provided for @newsletterErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get newsletterErrorEmpty;

  /// No description provided for @newsletterErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get newsletterErrorInvalid;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'PERSONALIZATION'**
  String get settingsTitle;

  /// No description provided for @settingsRamadanMode.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Mode'**
  String get settingsRamadanMode;

  /// No description provided for @settingsRamadanDesc.
  ///
  /// In en, this message translates to:
  /// **'Adjust schedules and content for Ramadan'**
  String get settingsRamadanDesc;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsDarkDesc.
  ///
  /// In en, this message translates to:
  /// **'Switch between light and dark mode'**
  String get settingsDarkDesc;

  /// No description provided for @ramadanBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Special Ramadan Hours'**
  String get ramadanBannerTitle;

  /// No description provided for @ramadanBannerGreeting.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Kareem'**
  String get ramadanBannerGreeting;

  /// No description provided for @ramadanBannerHours.
  ///
  /// In en, this message translates to:
  /// **'10pm - 2am & 4am - 7am'**
  String get ramadanBannerHours;

  /// No description provided for @appStoreDownloadOn.
  ///
  /// In en, this message translates to:
  /// **'Download on'**
  String get appStoreDownloadOn;

  /// No description provided for @appStoreAvailableOn.
  ///
  /// In en, this message translates to:
  /// **'Available on'**
  String get appStoreAvailableOn;

  /// No description provided for @appStoreMemberCard.
  ///
  /// In en, this message translates to:
  /// **'Your Member Card'**
  String get appStoreMemberCard;

  /// No description provided for @appStorePremiumMember.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get appStorePremiumMember;

  /// No description provided for @qrFeatureCheckin.
  ///
  /// In en, this message translates to:
  /// **'Instant Check-in'**
  String get qrFeatureCheckin;

  /// No description provided for @qrFeatureCheckinDesc.
  ///
  /// In en, this message translates to:
  /// **'Quick 2-second scan'**
  String get qrFeatureCheckinDesc;

  /// No description provided for @qrFeatureBooking.
  ///
  /// In en, this message translates to:
  /// **'Simplified Bookings'**
  String get qrFeatureBooking;

  /// No description provided for @qrFeatureBookingDesc.
  ///
  /// In en, this message translates to:
  /// **'Book classes with one tap'**
  String get qrFeatureBookingDesc;

  /// No description provided for @qrFeatureNotif.
  ///
  /// In en, this message translates to:
  /// **'Smart Notifications'**
  String get qrFeatureNotif;

  /// No description provided for @qrFeatureNotifDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminders and updates'**
  String get qrFeatureNotifDesc;

  /// No description provided for @qrWithQrCode.
  ///
  /// In en, this message translates to:
  /// **'with QR Code'**
  String get qrWithQrCode;

  /// No description provided for @qrMobileApp.
  ///
  /// In en, this message translates to:
  /// **'MOBILE APP'**
  String get qrMobileApp;

  /// No description provided for @ctaReadyTo.
  ///
  /// In en, this message translates to:
  /// **'READY TO'**
  String get ctaReadyTo;

  /// No description provided for @ctaTransform.
  ///
  /// In en, this message translates to:
  /// **'TRANSFORM'**
  String get ctaTransform;

  /// No description provided for @ctaYourLife.
  ///
  /// In en, this message translates to:
  /// **'YOUR LIFE?'**
  String get ctaYourLife;

  /// No description provided for @ctaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join +5000 members who have already taken the first step towards their\nbest version.'**
  String get ctaSubtitle;

  /// No description provided for @ctaButton.
  ///
  /// In en, this message translates to:
  /// **'START NOW'**
  String get ctaButton;

  /// No description provided for @footerTagline.
  ///
  /// In en, this message translates to:
  /// **'The excellence of sport in Algeria. 6 premium branches for your transformation.'**
  String get footerTagline;

  /// No description provided for @footerCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 Gym Élysée DZ. All rights reserved.'**
  String get footerCopyright;

  /// No description provided for @footerBackToTop.
  ///
  /// In en, this message translates to:
  /// **'BACK TO TOP'**
  String get footerBackToTop;

  /// No description provided for @footerNavigation.
  ///
  /// In en, this message translates to:
  /// **'NAVIGATION'**
  String get footerNavigation;

  /// No description provided for @footerBranches.
  ///
  /// In en, this message translates to:
  /// **'BRANCHES'**
  String get footerBranches;

  /// No description provided for @footerContact.
  ///
  /// In en, this message translates to:
  /// **'CONTACT'**
  String get footerContact;

  /// No description provided for @footerHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get footerHome;

  /// No description provided for @footerPricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get footerPricing;

  /// No description provided for @footerHours.
  ///
  /// In en, this message translates to:
  /// **'Mon-Fri: 6am-10pm | Sat-Sun: 8am-8pm'**
  String get footerHours;

  /// No description provided for @landingPricingTag.
  ///
  /// In en, this message translates to:
  /// **'PRICING'**
  String get landingPricingTag;

  /// No description provided for @landingPricingTitle1.
  ///
  /// In en, this message translates to:
  /// **'INVEST'**
  String get landingPricingTitle1;

  /// No description provided for @landingPricingTitle2.
  ///
  /// In en, this message translates to:
  /// **'IN YOUR HEALTH'**
  String get landingPricingTitle2;

  /// No description provided for @landingPricingSubtitleMonthly.
  ///
  /// In en, this message translates to:
  /// **'Maximum flexibility, no commitment'**
  String get landingPricingSubtitleMonthly;

  /// No description provided for @landingPricingSubtitleQuarterly.
  ///
  /// In en, this message translates to:
  /// **'Perfect balance of price & commitment'**
  String get landingPricingSubtitleQuarterly;

  /// No description provided for @landingPricingSubtitleAnnual.
  ///
  /// In en, this message translates to:
  /// **'Best value for money'**
  String get landingPricingSubtitleAnnual;

  /// No description provided for @landingPricingFeaturesMonthly.
  ///
  /// In en, this message translates to:
  /// **'Access to 1 branch,Unlimited classes,Premium lockers,Mobile app'**
  String get landingPricingFeaturesMonthly;

  /// No description provided for @landingPricingFeaturesQuarterly.
  ///
  /// In en, this message translates to:
  /// **'Access to all branches,Unlimited classes,2 private sessions,1 guest pass/month,Premium lockers,Mobile app'**
  String get landingPricingFeaturesQuarterly;

  /// No description provided for @landingPricingFeaturesAnnual.
  ///
  /// In en, this message translates to:
  /// **'Unlimited access all branches,Unlimited classes,5 private sessions,3 guest passes/month,Premium lockers,Mobile app'**
  String get landingPricingFeaturesAnnual;

  /// No description provided for @landingPricingBadge.
  ///
  /// In en, this message translates to:
  /// **'POPULAR'**
  String get landingPricingBadge;

  /// No description provided for @landingPricingBtnDetails.
  ///
  /// In en, this message translates to:
  /// **'VIEW DETAILS'**
  String get landingPricingBtnDetails;

  /// No description provided for @landingPricingBtnAll.
  ///
  /// In en, this message translates to:
  /// **'VIEW ALL PLANS'**
  String get landingPricingBtnAll;

  /// No description provided for @statsBranches.
  ///
  /// In en, this message translates to:
  /// **'BRANCHES'**
  String get statsBranches;

  /// No description provided for @statsMembers.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE MEMBERS'**
  String get statsMembers;

  /// No description provided for @statsCoaches.
  ///
  /// In en, this message translates to:
  /// **'PRO COACHES'**
  String get statsCoaches;

  /// No description provided for @statsExperience.
  ///
  /// In en, this message translates to:
  /// **'YEARS OF EXCELLENCE'**
  String get statsExperience;

  /// No description provided for @featuresTitleTag.
  ///
  /// In en, this message translates to:
  /// **'WHY US'**
  String get featuresTitleTag;

  /// No description provided for @featuresTitle1.
  ///
  /// In en, this message translates to:
  /// **'EXCELLENCE'**
  String get featuresTitle1;

  /// No description provided for @featuresTitle2.
  ///
  /// In en, this message translates to:
  /// **'IN EVERY DETAIL'**
  String get featuresTitle2;

  /// No description provided for @featureEquipTitle.
  ///
  /// In en, this message translates to:
  /// **'PRO EQUIPMENT'**
  String get featureEquipTitle;

  /// No description provided for @featureEquipDesc.
  ///
  /// In en, this message translates to:
  /// **'Latest generation Technogym & Eleiko for optimal results'**
  String get featureEquipDesc;

  /// No description provided for @featureCoachTitle.
  ///
  /// In en, this message translates to:
  /// **'ELITE COACHES'**
  String get featureCoachTitle;

  /// No description provided for @featureCoachDesc.
  ///
  /// In en, this message translates to:
  /// **'International certifications and professional experience'**
  String get featureCoachDesc;

  /// No description provided for @featurePaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'FLEXIBLE PAYMENT'**
  String get featurePaymentTitle;

  /// No description provided for @featurePaymentDesc.
  ///
  /// In en, this message translates to:
  /// **'eDahabia, CIB, Baridimob and 3x installment payment'**
  String get featurePaymentDesc;

  /// No description provided for @featureRamadanTitle.
  ///
  /// In en, this message translates to:
  /// **'RAMADAN MODE'**
  String get featureRamadanTitle;

  /// No description provided for @featureRamadanDesc.
  ///
  /// In en, this message translates to:
  /// **'Adapted hours 10pm-2am & 4am-7am during the holy month'**
  String get featureRamadanDesc;

  /// No description provided for @featureProgramTitle.
  ///
  /// In en, this message translates to:
  /// **'TAILORED PROGRAMS'**
  String get featureProgramTitle;

  /// No description provided for @featureProgramDesc.
  ///
  /// In en, this message translates to:
  /// **'Personalized tracking adapted to your specific goals'**
  String get featureProgramDesc;

  /// No description provided for @featureCommunityTitle.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE COMMUNITY'**
  String get featureCommunityTitle;

  /// No description provided for @featureCommunityDesc.
  ///
  /// In en, this message translates to:
  /// **'+5000 motivated members sharing the same passion'**
  String get featureCommunityDesc;

  /// No description provided for @testimonialsTitleTag.
  ///
  /// In en, this message translates to:
  /// **'TESTIMONIALS'**
  String get testimonialsTitleTag;

  /// No description provided for @testimonialsTitle1.
  ///
  /// In en, this message translates to:
  /// **'THEY'**
  String get testimonialsTitle1;

  /// No description provided for @testimonialsTitle2.
  ///
  /// In en, this message translates to:
  /// **'TRUST US'**
  String get testimonialsTitle2;

  /// No description provided for @testimonials1Quote.
  ///
  /// In en, this message translates to:
  /// **'Tiger Sport DZ transformed me. In 18 months, I went from complete beginner to regional champion. The coaches are incredible and the vibe is electric.'**
  String get testimonials1Quote;

  /// No description provided for @testimonials1Name.
  ///
  /// In en, this message translates to:
  /// **'Karim Benali'**
  String get testimonials1Name;

  /// No description provided for @testimonials1Role.
  ///
  /// In en, this message translates to:
  /// **'Amateur MMA Competitor'**
  String get testimonials1Role;

  /// No description provided for @testimonials2Quote.
  ///
  /// In en, this message translates to:
  /// **'Gym Élysée Women is my refuge. I feel confident and the results are there. I lost 15kg and gained incredible mental strength.'**
  String get testimonials2Quote;

  /// No description provided for @testimonials2Name.
  ///
  /// In en, this message translates to:
  /// **'Samira Hadji'**
  String get testimonials2Name;

  /// No description provided for @testimonials2Role.
  ///
  /// In en, this message translates to:
  /// **'Member since 2 years'**
  String get testimonials2Role;

  /// No description provided for @testimonials3Quote.
  ///
  /// In en, this message translates to:
  /// **'The best boxing gym in Algeria, period. Coach Ahmed prepared me for my last 3 victorious fights. International level equipment and sparring.'**
  String get testimonials3Quote;

  /// No description provided for @testimonials3Name.
  ///
  /// In en, this message translates to:
  /// **'Omar Zidane'**
  String get testimonials3Name;

  /// No description provided for @testimonials3Role.
  ///
  /// In en, this message translates to:
  /// **'Professional Boxer'**
  String get testimonials3Role;

  /// No description provided for @blogPreviewTag.
  ///
  /// In en, this message translates to:
  /// **'THE MAGAZINE'**
  String get blogPreviewTag;

  /// No description provided for @blogPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'TIPS & INSPIRATION'**
  String get blogPreviewTitle;

  /// No description provided for @blogPreviewViewAll.
  ///
  /// In en, this message translates to:
  /// **'EXPLORE THE MAGAZINE'**
  String get blogPreviewViewAll;

  /// No description provided for @blogReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read Article →'**
  String get blogReadMore;

  /// No description provided for @blogDummy1Title.
  ///
  /// In en, this message translates to:
  /// **'Benefits of Intermittent Fasting'**
  String get blogDummy1Title;

  /// No description provided for @blogDummy1Cat.
  ///
  /// In en, this message translates to:
  /// **'NUTRITION'**
  String get blogDummy1Cat;

  /// No description provided for @blogDummy2Title.
  ///
  /// In en, this message translates to:
  /// **'Top 5 Bank Exercises'**
  String get blogDummy2Title;

  /// No description provided for @blogDummy2Cat.
  ///
  /// In en, this message translates to:
  /// **'TRAINING'**
  String get blogDummy2Cat;

  /// No description provided for @blogDummy3Title.
  ///
  /// In en, this message translates to:
  /// **'Recovery After Session'**
  String get blogDummy3Title;

  /// No description provided for @blogDummy3Cat.
  ///
  /// In en, this message translates to:
  /// **'HEALTH'**
  String get blogDummy3Cat;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'MY DASHBOARD'**
  String get dashboardTitle;

  /// No description provided for @dashboardGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String dashboardGreeting(Object name);

  /// No description provided for @dashboardGreetingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready for your session today?'**
  String get dashboardGreetingSubtitle;

  /// No description provided for @dashboardQuickAccess.
  ///
  /// In en, this message translates to:
  /// **'QUICK ACCESS'**
  String get dashboardQuickAccess;

  /// No description provided for @dashboardActionPrograms.
  ///
  /// In en, this message translates to:
  /// **'PROGRAMS'**
  String get dashboardActionPrograms;

  /// No description provided for @dashboardActionBookings.
  ///
  /// In en, this message translates to:
  /// **'BOOKINGS'**
  String get dashboardActionBookings;

  /// No description provided for @dashboardActionBranches.
  ///
  /// In en, this message translates to:
  /// **'BRANCHES'**
  String get dashboardActionBranches;

  /// No description provided for @dashboardActionSparring.
  ///
  /// In en, this message translates to:
  /// **'SPARRING'**
  String get dashboardActionSparring;

  /// No description provided for @dashboardActionQRCode.
  ///
  /// In en, this message translates to:
  /// **'MY QR CODE'**
  String get dashboardActionQRCode;

  /// No description provided for @dashboardNoQR.
  ///
  /// In en, this message translates to:
  /// **'No QR Code available'**
  String get dashboardNoQR;

  /// No description provided for @dashboardStatsWeek.
  ///
  /// In en, this message translates to:
  /// **'WEEKLY STATS'**
  String get dashboardStatsWeek;

  /// No description provided for @dashboardStatsPresentDays.
  ///
  /// In en, this message translates to:
  /// **'Days Present'**
  String get dashboardStatsPresentDays;

  /// No description provided for @dashboardStatsSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions Completed'**
  String get dashboardStatsSessions;

  /// No description provided for @dashboardStatsCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories Burned'**
  String get dashboardStatsCalories;

  /// No description provided for @dashboardPaymentButton.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT'**
  String get dashboardPaymentButton;

  /// No description provided for @dashboardPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'PHOTOS & PROGRESS'**
  String get dashboardPhotosTitle;

  /// No description provided for @dashboardAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'ADD'**
  String get dashboardAddPhoto;

  /// No description provided for @dashboardAddPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a Photo'**
  String get dashboardAddPhotoTitle;

  /// No description provided for @dashboardTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get dashboardTakePhoto;

  /// No description provided for @dashboardGalleryPhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get dashboardGalleryPhoto;

  /// No description provided for @dashboardPhotoOptions.
  ///
  /// In en, this message translates to:
  /// **'Photo Options'**
  String get dashboardPhotoOptions;

  /// No description provided for @dashboardViewFullscreen.
  ///
  /// In en, this message translates to:
  /// **'View Fullscreen'**
  String get dashboardViewFullscreen;

  /// No description provided for @dashboardDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dashboardDelete;

  /// No description provided for @dashboardConfirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Photo?'**
  String get dashboardConfirmDeleteTitle;

  /// No description provided for @dashboardConfirmDeleteContent.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get dashboardConfirmDeleteContent;

  /// No description provided for @dashboardCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dashboardCancel;

  /// No description provided for @qrTitle.
  ///
  /// In en, this message translates to:
  /// **'My QR Code'**
  String get qrTitle;

  /// No description provided for @qrInstructions.
  ///
  /// In en, this message translates to:
  /// **'Present this QR code at your gym entrance'**
  String get qrInstructions;

  /// No description provided for @qrValid.
  ///
  /// In en, this message translates to:
  /// **'Valid for 5 minutes'**
  String get qrValid;

  /// No description provided for @paymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentTitle;

  /// No description provided for @paymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount to Pay'**
  String get paymentAmount;

  /// No description provided for @paymentContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue Payment'**
  String get paymentContinue;

  /// No description provided for @paymentMethodEdahabia.
  ///
  /// In en, this message translates to:
  /// **'eDahabia'**
  String get paymentMethodEdahabia;

  /// No description provided for @paymentMethodEdahabiaDesc.
  ///
  /// In en, this message translates to:
  /// **'Algeria Post Prepaid Card'**
  String get paymentMethodEdahabiaDesc;

  /// No description provided for @paymentMethodCib.
  ///
  /// In en, this message translates to:
  /// **'CIB'**
  String get paymentMethodCib;

  /// No description provided for @paymentMethodCibDesc.
  ///
  /// In en, this message translates to:
  /// **'Interbank Card'**
  String get paymentMethodCibDesc;

  /// No description provided for @paymentMethodBaridimob.
  ///
  /// In en, this message translates to:
  /// **'Baridimob'**
  String get paymentMethodBaridimob;

  /// No description provided for @paymentMethodBaridimobDesc.
  ///
  /// In en, this message translates to:
  /// **'Algeria Post Mobile Wallet'**
  String get paymentMethodBaridimobDesc;

  /// No description provided for @paymentMethodCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodCash;

  /// No description provided for @paymentMethodCashDesc.
  ///
  /// In en, this message translates to:
  /// **'Pay at Reception'**
  String get paymentMethodCashDesc;

  /// No description provided for @paymentMethodTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get paymentMethodTransfer;

  /// No description provided for @paymentMethodTransferDesc.
  ///
  /// In en, this message translates to:
  /// **'Direct Bank Transfer'**
  String get paymentMethodTransferDesc;

  /// No description provided for @paymentInstructionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment via {method}'**
  String paymentInstructionsTitle(Object method);

  /// No description provided for @paymentInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions:'**
  String get paymentInstructions;

  /// No description provided for @paymentInstructionStep1.
  ///
  /// In en, this message translates to:
  /// **'1. Perform payment via {method}'**
  String paymentInstructionStep1(Object method);

  /// No description provided for @paymentInstructionStep2.
  ///
  /// In en, this message translates to:
  /// **'2. Take a screenshot of confirmation'**
  String get paymentInstructionStep2;

  /// No description provided for @paymentInstructionStep3.
  ///
  /// In en, this message translates to:
  /// **'3. Upload the screenshot below'**
  String get paymentInstructionStep3;

  /// No description provided for @paymentUploadProof.
  ///
  /// In en, this message translates to:
  /// **'Upload Proof'**
  String get paymentUploadProof;

  /// No description provided for @paymentUploadToDo.
  ///
  /// In en, this message translates to:
  /// **'Upload functionality to be implemented'**
  String get paymentUploadToDo;

  /// No description provided for @paymentCashTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment'**
  String get paymentCashTitle;

  /// No description provided for @paymentCashContent.
  ///
  /// In en, this message translates to:
  /// **'You can pay in cash directly at your branch reception. Your subscription will be activated upon payment confirmation.'**
  String get paymentCashContent;

  /// No description provided for @paymentUnderstood.
  ///
  /// In en, this message translates to:
  /// **'Understood'**
  String get paymentUnderstood;

  /// No description provided for @paymentTransferTitle.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get paymentTransferTitle;

  /// No description provided for @paymentTransferTo.
  ///
  /// In en, this message translates to:
  /// **'Transfer to:'**
  String get paymentTransferTo;

  /// No description provided for @paymentTransferBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get paymentTransferBank;

  /// No description provided for @paymentTransferRib.
  ///
  /// In en, this message translates to:
  /// **'RIB'**
  String get paymentTransferRib;

  /// No description provided for @paymentTransferAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get paymentTransferAmount;

  /// No description provided for @paymentTransferUploadHint.
  ///
  /// In en, this message translates to:
  /// **'After transfer, upload the receipt.'**
  String get paymentTransferUploadHint;

  /// No description provided for @paymentClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get paymentClose;

  /// No description provided for @programsTitle.
  ///
  /// In en, this message translates to:
  /// **'PROGRAMS'**
  String get programsTitle;

  /// No description provided for @programsTabDiscover.
  ///
  /// In en, this message translates to:
  /// **'DISCOVER'**
  String get programsTabDiscover;

  /// No description provided for @programsTabMyPrograms.
  ///
  /// In en, this message translates to:
  /// **'MY PROGRAMS'**
  String get programsTabMyPrograms;

  /// No description provided for @programsTabHistory.
  ///
  /// In en, this message translates to:
  /// **'HISTORY'**
  String get programsTabHistory;

  /// No description provided for @programsFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get programsFilterTitle;

  /// No description provided for @programsFilterLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get programsFilterLevel;

  /// No description provided for @programsFilterType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get programsFilterType;

  /// No description provided for @programsFilterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get programsFilterApply;

  /// No description provided for @programsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No programs found'**
  String get programsEmpty;

  /// No description provided for @programsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Try changing your filters'**
  String get programsEmptyHint;

  /// No description provided for @programsError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String programsError(Object error);

  /// No description provided for @programsRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get programsRetry;

  /// No description provided for @programsPlaceholderMy.
  ///
  /// In en, this message translates to:
  /// **'My Programs (Coming Soon)'**
  String get programsPlaceholderMy;

  /// No description provided for @programsPlaceholderHistory.
  ///
  /// In en, this message translates to:
  /// **'History (Coming Soon)'**
  String get programsPlaceholderHistory;

  /// No description provided for @programLevelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get programLevelBeginner;

  /// No description provided for @programLevelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get programLevelIntermediate;

  /// No description provided for @programLevelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get programLevelAdvanced;

  /// No description provided for @programLevelPro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get programLevelPro;

  /// No description provided for @programTypeStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get programTypeStrength;

  /// No description provided for @programTypeCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get programTypeCardio;

  /// No description provided for @programTypeBoxing.
  ///
  /// In en, this message translates to:
  /// **'Boxing'**
  String get programTypeBoxing;

  /// No description provided for @programTypeMma.
  ///
  /// In en, this message translates to:
  /// **'MMA'**
  String get programTypeMma;

  /// No description provided for @programTypeGrappling.
  ///
  /// In en, this message translates to:
  /// **'Grappling'**
  String get programTypeGrappling;

  /// No description provided for @programTypeHybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get programTypeHybrid;

  /// No description provided for @programCoach.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get programCoach;

  /// No description provided for @programDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get programDuration;

  /// No description provided for @programPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Per Week'**
  String get programPerWeek;

  /// No description provided for @programEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Enrolled'**
  String get programEnrolled;

  /// No description provided for @programDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get programDescription;

  /// No description provided for @programSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get programSchedule;

  /// No description provided for @programStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get programStart;

  /// No description provided for @programWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count} weeks'**
  String programWeeks(Object count);

  /// No description provided for @programWeekShort.
  ///
  /// In en, this message translates to:
  /// **'W{number}'**
  String programWeekShort(Object number);

  /// No description provided for @programWeekTile.
  ///
  /// In en, this message translates to:
  /// **'Week {number}'**
  String programWeekTile(Object number);

  /// No description provided for @programDayTile.
  ///
  /// In en, this message translates to:
  /// **'Day {number}'**
  String programDayTile(Object number);

  /// No description provided for @programSessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions'**
  String programSessionsCount(Object count);

  /// No description provided for @programExercisesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} exercises'**
  String programExercisesCount(Object count);

  /// No description provided for @bookingTitle.
  ///
  /// In en, this message translates to:
  /// **'BOOKING'**
  String get bookingTitle;

  /// No description provided for @bookingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Plan your sessions'**
  String get bookingSubtitle;

  /// No description provided for @bookingMyBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get bookingMyBookings;

  /// No description provided for @bookingTabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get bookingTabUpcoming;

  /// No description provided for @bookingTabPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get bookingTabPast;

  /// No description provided for @bookingTabCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookingTabCancelled;

  /// No description provided for @bookingFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get bookingFilterAll;

  /// No description provided for @bookingFilterClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get bookingFilterClass;

  /// No description provided for @bookingFilterPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get bookingFilterPrivate;

  /// No description provided for @bookingSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get bookingSelectDate;

  /// No description provided for @bookingConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get bookingConfirmTitle;

  /// No description provided for @bookingConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get bookingConfirmButton;

  /// No description provided for @bookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed! ✓'**
  String get bookingSuccess;

  /// No description provided for @bookingCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking?'**
  String get bookingCancelTitle;

  /// No description provided for @bookingCancelContent.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get bookingCancelContent;

  /// No description provided for @bookingCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, cancel'**
  String get bookingCancelConfirm;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled'**
  String get bookingCancelled;

  /// No description provided for @bookingStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get bookingStatusPending;

  /// No description provided for @bookingStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get bookingStatusConfirmed;

  /// No description provided for @bookingFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get bookingFull;

  /// No description provided for @bookingSpots.
  ///
  /// In en, this message translates to:
  /// **'{count} spots'**
  String bookingSpots(Object count);

  /// No description provided for @bookingReserve.
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get bookingReserve;

  /// No description provided for @bookingEmptyPast.
  ///
  /// In en, this message translates to:
  /// **'No past bookings'**
  String get bookingEmptyPast;

  /// No description provided for @bookingEmptyCancelled.
  ///
  /// In en, this message translates to:
  /// **'No cancelled bookings'**
  String get bookingEmptyCancelled;

  /// No description provided for @sparringTitle.
  ///
  /// In en, this message translates to:
  /// **'SPARRING'**
  String get sparringTitle;

  /// No description provided for @sparringSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find your partner'**
  String get sparringSubtitle;

  /// No description provided for @sparringFilters.
  ///
  /// In en, this message translates to:
  /// **'FILTERS'**
  String get sparringFilters;

  /// No description provided for @sparringFilterDiscipline.
  ///
  /// In en, this message translates to:
  /// **'Discipline'**
  String get sparringFilterDiscipline;

  /// No description provided for @sparringFilterLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get sparringFilterLevel;

  /// No description provided for @sparringFilterWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get sparringFilterWeight;

  /// No description provided for @sparringWins.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get sparringWins;

  /// No description provided for @sparringDraws.
  ///
  /// In en, this message translates to:
  /// **'Draws'**
  String get sparringDraws;

  /// No description provided for @sparringBranch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get sparringBranch;

  /// No description provided for @sparringAvailability.
  ///
  /// In en, this message translates to:
  /// **'Avail.'**
  String get sparringAvailability;

  /// No description provided for @sparringRequestButton.
  ///
  /// In en, this message translates to:
  /// **'REQUEST SPARRING'**
  String get sparringRequestButton;

  /// No description provided for @sparringRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'SPARRING REQUEST'**
  String get sparringRequestTitle;

  /// No description provided for @sparringMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message (optional)'**
  String get sparringMessageLabel;

  /// No description provided for @sparringMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m looking for a partner for...'**
  String get sparringMessageHint;

  /// No description provided for @sparringDateLabel.
  ///
  /// In en, this message translates to:
  /// **'PREFERRED DATE'**
  String get sparringDateLabel;

  /// No description provided for @sparringDateThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get sparringDateThisWeek;

  /// No description provided for @sparringDateNextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get sparringDateNextWeek;

  /// No description provided for @sparringDateFlexible.
  ///
  /// In en, this message translates to:
  /// **'Flexible'**
  String get sparringDateFlexible;

  /// No description provided for @sparringSendRequest.
  ///
  /// In en, this message translates to:
  /// **'SEND REQUEST'**
  String get sparringSendRequest;

  /// No description provided for @sparringRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent to {name}!'**
  String sparringRequestSent(Object name);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileTitle;

  /// No description provided for @profileLevelGold.
  ///
  /// In en, this message translates to:
  /// **'Gold Level'**
  String get profileLevelGold;

  /// No description provided for @profileStatsSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get profileStatsSessions;

  /// No description provided for @profileStatsPrograms.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get profileStatsPrograms;

  /// No description provided for @profileStatsPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get profileStatsPoints;

  /// No description provided for @profileMenuStats.
  ///
  /// In en, this message translates to:
  /// **'My Stats'**
  String get profileMenuStats;

  /// No description provided for @profileMenuStatsDesc.
  ///
  /// In en, this message translates to:
  /// **'Progression, weight, performance'**
  String get profileMenuStatsDesc;

  /// No description provided for @profileMenuSubscription.
  ///
  /// In en, this message translates to:
  /// **'My Subscription'**
  String get profileMenuSubscription;

  /// No description provided for @profileMenuSubscriptionDesc.
  ///
  /// In en, this message translates to:
  /// **'Premium - Expires {date}'**
  String profileMenuSubscriptionDesc(Object date);

  /// No description provided for @profileMenuBadges.
  ///
  /// In en, this message translates to:
  /// **'My Badges'**
  String get profileMenuBadges;

  /// No description provided for @profileMenuBadgesDesc.
  ///
  /// In en, this message translates to:
  /// **'{count} badges unlocked'**
  String profileMenuBadgesDesc(Object count);

  /// No description provided for @profileMenuQRCode.
  ///
  /// In en, this message translates to:
  /// **'My QR Code'**
  String get profileMenuQRCode;

  /// No description provided for @profileMenuQRCodeDesc.
  ///
  /// In en, this message translates to:
  /// **'Check-in at the gym'**
  String get profileMenuQRCodeDesc;

  /// No description provided for @profileMenuHelp.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get profileMenuHelp;

  /// No description provided for @profileMenuHelpDesc.
  ///
  /// In en, this message translates to:
  /// **'FAQ, Contact, Report an issue'**
  String get profileMenuHelpDesc;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogout;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated!'**
  String get profilePhotoUpdated;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'REGISTER'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account to get started'**
  String get registerSubtitle;

  /// No description provided for @registerTypeMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get registerTypeMember;

  /// No description provided for @registerTypeCoach.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get registerTypeCoach;

  /// No description provided for @registerFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get registerFirstName;

  /// No description provided for @registerLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get registerLastName;

  /// No description provided for @registerEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerEmail;

  /// No description provided for @registerPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get registerPhone;

  /// No description provided for @registerPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPassword;

  /// No description provided for @registerConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get registerConfirmPassword;

  /// No description provided for @registerPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get registerPasswordMismatch;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'REGISTER'**
  String get registerButton;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'WELCOME'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to your member area'**
  String get loginSubtitle;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'your@email.com'**
  String get loginEmailHint;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get loginRememberMe;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'LOG IN'**
  String get loginButton;

  /// No description provided for @loginOr.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get loginOr;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Not a member yet? '**
  String get loginNoAccount;

  /// No description provided for @loginSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get loginSignUp;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingStart;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Desc.
  ///
  /// In en, this message translates to:
  /// **'Discover GYM ÉLYSÉE DZ, your premium gym chain in Algeria'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Our Branches'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Desc.
  ///
  /// In en, this message translates to:
  /// **'6 specialized branches: Bodybuilding, Boxing, MMA, Grappling, Women, Performance'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'QR Code Check-In'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Desc.
  ///
  /// In en, this message translates to:
  /// **'Quickly access your gym with your personal QR code'**
  String get onboarding3Desc;

  /// No description provided for @splashTitle.
  ///
  /// In en, this message translates to:
  /// **'GYM ÉLYSÉE DZ'**
  String get splashTitle;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your premium gym'**
  String get splashSubtitle;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network connection error'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get errorServer;

  /// No description provided for @errorAuth.
  ///
  /// In en, this message translates to:
  /// **'Authentication error'**
  String get errorAuth;

  /// No description provided for @errorCache.
  ///
  /// In en, this message translates to:
  /// **'Cache error'**
  String get errorCache;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get errorUnknown;

  /// No description provided for @errorLoadBranches.
  ///
  /// In en, this message translates to:
  /// **'Error loading branches'**
  String get errorLoadBranches;

  /// No description provided for @errorLoadPrograms.
  ///
  /// In en, this message translates to:
  /// **'Error loading programs'**
  String get errorLoadPrograms;

  /// No description provided for @errorLoadSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Error loading subscriptions'**
  String get errorLoadSubscriptions;

  /// No description provided for @errorLogin.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get errorLogin;

  /// No description provided for @errorRegister.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get errorRegister;

  /// No description provided for @transformationsTitle.
  ///
  /// In en, this message translates to:
  /// **'SUCCESS STORIES'**
  String get transformationsTitle;

  /// No description provided for @transformationsHeading1.
  ///
  /// In en, this message translates to:
  /// **'INSPIRING'**
  String get transformationsHeading1;

  /// No description provided for @transformationsHeading2.
  ///
  /// In en, this message translates to:
  /// **'TRANSFORMATIONS'**
  String get transformationsHeading2;

  /// No description provided for @transformationsBefore.
  ///
  /// In en, this message translates to:
  /// **'BEFORE'**
  String get transformationsBefore;

  /// No description provided for @transformationsAfter.
  ///
  /// In en, this message translates to:
  /// **'AFTER'**
  String get transformationsAfter;

  /// No description provided for @transformationsResult.
  ///
  /// In en, this message translates to:
  /// **'RESULT'**
  String get transformationsResult;

  /// No description provided for @transformationsGains.
  ///
  /// In en, this message translates to:
  /// **'GAINS'**
  String get transformationsGains;

  /// No description provided for @trName1.
  ///
  /// In en, this message translates to:
  /// **'Karim'**
  String get trName1;

  /// No description provided for @trAge1.
  ///
  /// In en, this message translates to:
  /// **'28 years'**
  String get trAge1;

  /// No description provided for @trDuration1.
  ///
  /// In en, this message translates to:
  /// **'6 MONTHS'**
  String get trDuration1;

  /// No description provided for @trWeight1.
  ///
  /// In en, this message translates to:
  /// **'-18KG'**
  String get trWeight1;

  /// No description provided for @trMuscle1.
  ///
  /// In en, this message translates to:
  /// **'+8KG MUSCLE'**
  String get trMuscle1;

  /// No description provided for @trQuote1.
  ///
  /// In en, this message translates to:
  /// **'I lost 18kg and completely changed my life. The coaches are incredible.'**
  String get trQuote1;

  /// No description provided for @trProgram1.
  ///
  /// In en, this message translates to:
  /// **'INTENSIVE BODYBUILDING'**
  String get trProgram1;

  /// No description provided for @trGym1.
  ///
  /// In en, this message translates to:
  /// **'Gym Élysée DZ'**
  String get trGym1;

  /// No description provided for @trName2.
  ///
  /// In en, this message translates to:
  /// **'Amel'**
  String get trName2;

  /// No description provided for @trAge2.
  ///
  /// In en, this message translates to:
  /// **'32 years'**
  String get trAge2;

  /// No description provided for @trDuration2.
  ///
  /// In en, this message translates to:
  /// **'4 MONTHS'**
  String get trDuration2;

  /// No description provided for @trWeight2.
  ///
  /// In en, this message translates to:
  /// **'-12KG'**
  String get trWeight2;

  /// No description provided for @trMuscle2.
  ///
  /// In en, this message translates to:
  /// **'TONED'**
  String get trMuscle2;

  /// No description provided for @trQuote2.
  ///
  /// In en, this message translates to:
  /// **'Finally a program that works! I feel stronger and more confident.'**
  String get trQuote2;

  /// No description provided for @trProgram2.
  ///
  /// In en, this message translates to:
  /// **'FITNESS TRANSFORMATION'**
  String get trProgram2;

  /// No description provided for @trGym2.
  ///
  /// In en, this message translates to:
  /// **'Gym Élysée Women'**
  String get trGym2;

  /// No description provided for @trName3.
  ///
  /// In en, this message translates to:
  /// **'Yacine'**
  String get trName3;

  /// No description provided for @trAge3.
  ///
  /// In en, this message translates to:
  /// **'25 years'**
  String get trAge3;

  /// No description provided for @trDuration3.
  ///
  /// In en, this message translates to:
  /// **'8 MONTHS'**
  String get trDuration3;

  /// No description provided for @trWeight3.
  ///
  /// In en, this message translates to:
  /// **'-5KG FAT'**
  String get trWeight3;

  /// No description provided for @trMuscle3.
  ///
  /// In en, this message translates to:
  /// **'+12KG MUSCLE'**
  String get trMuscle3;

  /// No description provided for @trQuote3.
  ///
  /// In en, this message translates to:
  /// **'Preparation for my first competition. The support is total.'**
  String get trQuote3;

  /// No description provided for @trProgram3.
  ///
  /// In en, this message translates to:
  /// **'BOXING PRO'**
  String get trProgram3;

  /// No description provided for @trGym3.
  ///
  /// In en, this message translates to:
  /// **'Gym Élysée Boxing'**
  String get trGym3;

  /// No description provided for @labelBodyFat.
  ///
  /// In en, this message translates to:
  /// **'Body Fat'**
  String get labelBodyFat;

  /// No description provided for @branchNameWomen.
  ///
  /// In en, this message translates to:
  /// **'Gym Élysée Women'**
  String get branchNameWomen;

  /// No description provided for @branchNameBoxing.
  ///
  /// In en, this message translates to:
  /// **'Gym Élysée Boxing'**
  String get branchNameBoxing;

  /// No description provided for @adminNavDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get adminNavDashboard;

  /// No description provided for @adminNavMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get adminNavMembers;

  /// No description provided for @adminNavCoaches.
  ///
  /// In en, this message translates to:
  /// **'Coaches'**
  String get adminNavCoaches;

  /// No description provided for @adminNavPrograms.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get adminNavPrograms;

  /// No description provided for @adminNavBranches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get adminNavBranches;

  /// No description provided for @adminNavPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get adminNavPayments;

  /// No description provided for @adminNavSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get adminNavSettings;

  /// No description provided for @adminStatTotalMembers.
  ///
  /// In en, this message translates to:
  /// **'Total Members'**
  String get adminStatTotalMembers;

  /// No description provided for @adminStatActiveNow.
  ///
  /// In en, this message translates to:
  /// **'Active Now'**
  String get adminStatActiveNow;

  /// No description provided for @adminStatRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get adminStatRevenue;

  /// No description provided for @adminStatAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get adminStatAlerts;

  /// No description provided for @adminErrorStats.
  ///
  /// In en, this message translates to:
  /// **'Error loading stats'**
  String get adminErrorStats;

  /// No description provided for @adminSectionRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Registrations'**
  String get adminSectionRecentActivity;

  /// No description provided for @adminSectionQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get adminSectionQuickActions;

  /// No description provided for @adminActionAddMember.
  ///
  /// In en, this message translates to:
  /// **'Add New Member'**
  String get adminActionAddMember;

  /// No description provided for @adminActionCreatePost.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get adminActionCreatePost;

  /// No description provided for @adminActionValidatePayments.
  ///
  /// In en, this message translates to:
  /// **'Validate Payments'**
  String get adminActionValidatePayments;

  /// No description provided for @adminActionModeratePosts.
  ///
  /// In en, this message translates to:
  /// **'Moderate Posts'**
  String get adminActionModeratePosts;

  /// No description provided for @adminPlaceholderModule.
  ///
  /// In en, this message translates to:
  /// **'{module} Module'**
  String adminPlaceholderModule(Object module);

  /// No description provided for @adminComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get adminComingSoon;

  /// No description provided for @adminRegisteredSpecially.
  ///
  /// In en, this message translates to:
  /// **'Registered specially for \"Summer Shred\"'**
  String get adminRegisteredSpecially;

  /// No description provided for @adminTimeMinAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String adminTimeMinAgo(Object minutes);

  /// No description provided for @adminMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Members Management'**
  String get adminMembersTitle;

  /// No description provided for @adminMembersAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get adminMembersAdd;

  /// No description provided for @adminMembersSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search members...'**
  String get adminMembersSearchPlaceholder;

  /// No description provided for @adminMembersNotFound.
  ///
  /// In en, this message translates to:
  /// **'No members found'**
  String get adminMembersNotFound;

  /// No description provided for @adminMembersNoEmail.
  ///
  /// In en, this message translates to:
  /// **'No email'**
  String get adminMembersNoEmail;

  /// No description provided for @adminMembersStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminMembersStatusActive;

  /// No description provided for @adminMembersErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading members: {error}'**
  String adminMembersErrorLoading(Object error);

  /// No description provided for @adminCoachesTitle.
  ///
  /// In en, this message translates to:
  /// **'Coaches Management'**
  String get adminCoachesTitle;

  /// No description provided for @adminCoachesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Coach'**
  String get adminCoachesAdd;

  /// No description provided for @adminCoachesNotFound.
  ///
  /// In en, this message translates to:
  /// **'No coaches found'**
  String get adminCoachesNotFound;

  /// No description provided for @adminCoachesDefaultSpecialization.
  ///
  /// In en, this message translates to:
  /// **'General Coach'**
  String get adminCoachesDefaultSpecialization;

  /// No description provided for @adminCoachesErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading coaches: {error}'**
  String adminCoachesErrorLoading(Object error);

  /// No description provided for @adminProgramsTitle.
  ///
  /// In en, this message translates to:
  /// **'Programs Management'**
  String get adminProgramsTitle;

  /// No description provided for @adminProgramsNew.
  ///
  /// In en, this message translates to:
  /// **'New Program'**
  String get adminProgramsNew;

  /// No description provided for @adminProgramsNotFound.
  ///
  /// In en, this message translates to:
  /// **'No programs found'**
  String get adminProgramsNotFound;

  /// No description provided for @adminProgramsUntitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled Program'**
  String get adminProgramsUntitled;

  /// No description provided for @adminProgramsAllLevels.
  ///
  /// In en, this message translates to:
  /// **'All Levels'**
  String get adminProgramsAllLevels;

  /// No description provided for @adminProgramsNoDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get adminProgramsNoDescription;

  /// No description provided for @adminProgramsDurationWeeks.
  ///
  /// In en, this message translates to:
  /// **'{duration} weeks'**
  String adminProgramsDurationWeeks(Object duration);

  /// No description provided for @adminProgramsEnrolledCount.
  ///
  /// In en, this message translates to:
  /// **'{count} enrolled'**
  String adminProgramsEnrolledCount(Object count);

  /// No description provided for @adminProgramsErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading programs: {error}'**
  String adminProgramsErrorLoading(Object error);

  /// No description provided for @adminBranchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Branches Management'**
  String get adminBranchesTitle;

  /// No description provided for @adminBranchesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Branch'**
  String get adminBranchesAdd;

  /// No description provided for @adminBranchesNotFound.
  ///
  /// In en, this message translates to:
  /// **'No branches found'**
  String get adminBranchesNotFound;

  /// No description provided for @adminBranchesUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown Branch'**
  String get adminBranchesUnknown;

  /// No description provided for @adminBranchesEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get adminBranchesEdit;

  /// No description provided for @adminBranchesDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get adminBranchesDelete;

  /// No description provided for @adminBranchesNoAddress.
  ///
  /// In en, this message translates to:
  /// **'No address provided'**
  String get adminBranchesNoAddress;

  /// No description provided for @adminBranchesNoPhone.
  ///
  /// In en, this message translates to:
  /// **'No phone'**
  String get adminBranchesNoPhone;

  /// No description provided for @adminBranchesErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading branches: {error}'**
  String adminBranchesErrorLoading(Object error);

  /// No description provided for @adminPaymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get adminPaymentsTitle;

  /// No description provided for @adminPaymentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No transaction history'**
  String get adminPaymentsEmpty;

  /// No description provided for @adminPaymentsColumnId.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get adminPaymentsColumnId;

  /// No description provided for @adminPaymentsColumnMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get adminPaymentsColumnMember;

  /// No description provided for @adminPaymentsColumnAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get adminPaymentsColumnAmount;

  /// No description provided for @adminPaymentsColumnDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get adminPaymentsColumnDate;

  /// No description provided for @adminPaymentsColumnMethod.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get adminPaymentsColumnMethod;

  /// No description provided for @adminPaymentsColumnStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get adminPaymentsColumnStatus;

  /// No description provided for @adminPaymentsUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get adminPaymentsUnknown;

  /// No description provided for @adminPaymentsErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading history: {error}'**
  String adminPaymentsErrorLoading(Object error);

  /// No description provided for @adminDialogFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get adminDialogFirstName;

  /// No description provided for @adminDialogLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get adminDialogLastName;

  /// No description provided for @adminDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminDialogCancel;

  /// No description provided for @adminDialogSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get adminDialogSaveChanges;

  /// No description provided for @adminDialogRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get adminDialogRequired;

  /// No description provided for @adminDialogPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get adminDialogPhone;

  /// No description provided for @adminDialogAddMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Member'**
  String get adminDialogAddMemberTitle;

  /// No description provided for @adminDialogEditMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Member'**
  String get adminDialogEditMemberTitle;

  /// No description provided for @adminDialogMemberSuccessAdd.
  ///
  /// In en, this message translates to:
  /// **'Member added successfully'**
  String get adminDialogMemberSuccessAdd;

  /// No description provided for @adminDialogMemberSuccessUpdate.
  ///
  /// In en, this message translates to:
  /// **'Member updated successfully'**
  String get adminDialogMemberSuccessUpdate;

  /// No description provided for @adminDialogMemberErrorSave.
  ///
  /// In en, this message translates to:
  /// **'Error saving member: {error}'**
  String adminDialogMemberErrorSave(Object error);

  /// No description provided for @adminDialogEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get adminDialogEmail;

  /// No description provided for @adminDialogGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get adminDialogGender;

  /// No description provided for @adminDialogGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get adminDialogGenderMale;

  /// No description provided for @adminDialogGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get adminDialogGenderFemale;

  /// No description provided for @adminDialogAddMemberButton.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get adminDialogAddMemberButton;

  /// No description provided for @adminDialogAddCoachTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Coach'**
  String get adminDialogAddCoachTitle;

  /// No description provided for @adminDialogEditCoachTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Coach'**
  String get adminDialogEditCoachTitle;

  /// No description provided for @adminDialogCoachSuccessAdd.
  ///
  /// In en, this message translates to:
  /// **'Coach added successfully'**
  String get adminDialogCoachSuccessAdd;

  /// No description provided for @adminDialogCoachSuccessUpdate.
  ///
  /// In en, this message translates to:
  /// **'Coach updated successfully'**
  String get adminDialogCoachSuccessUpdate;

  /// No description provided for @adminDialogCoachErrorSave.
  ///
  /// In en, this message translates to:
  /// **'Error saving coach: {error}'**
  String adminDialogCoachErrorSave(Object error);

  /// No description provided for @adminDialogSpecialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get adminDialogSpecialization;

  /// No description provided for @adminDialogSpecializationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Yoga, HIIT, Boxing'**
  String get adminDialogSpecializationHint;

  /// No description provided for @adminDialogBio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get adminDialogBio;

  /// No description provided for @adminDialogAddCoachButton.
  ///
  /// In en, this message translates to:
  /// **'Add Coach'**
  String get adminDialogAddCoachButton;

  /// No description provided for @adminDialogCreateProgramTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Program'**
  String get adminDialogCreateProgramTitle;

  /// No description provided for @adminDialogEditProgramTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Program'**
  String get adminDialogEditProgramTitle;

  /// No description provided for @adminDialogProgramSuccessCreate.
  ///
  /// In en, this message translates to:
  /// **'Program \"{title}\" created'**
  String adminDialogProgramSuccessCreate(Object title);

  /// No description provided for @adminDialogProgramSuccessUpdate.
  ///
  /// In en, this message translates to:
  /// **'Program \"{title}\" updated'**
  String adminDialogProgramSuccessUpdate(Object title);

  /// No description provided for @adminDialogProgramErrorCreate.
  ///
  /// In en, this message translates to:
  /// **'Error creating program: {error}'**
  String adminDialogProgramErrorCreate(Object error);

  /// No description provided for @adminDialogProgramTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Program Title'**
  String get adminDialogProgramTitleLabel;

  /// No description provided for @adminDialogDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration (Weeks)'**
  String get adminDialogDurationLabel;

  /// No description provided for @adminDialogLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get adminDialogLevelLabel;

  /// No description provided for @adminDialogLevelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get adminDialogLevelBeginner;

  /// No description provided for @adminDialogLevelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get adminDialogLevelIntermediate;

  /// No description provided for @adminDialogLevelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get adminDialogLevelAdvanced;

  /// No description provided for @adminDialogLevelAll.
  ///
  /// In en, this message translates to:
  /// **'All Levels'**
  String get adminDialogLevelAll;

  /// No description provided for @adminDialogDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get adminDialogDescriptionLabel;

  /// No description provided for @adminDialogCreateProgramButton.
  ///
  /// In en, this message translates to:
  /// **'Create Program'**
  String get adminDialogCreateProgramButton;

  /// No description provided for @adminDialogAddBranchTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Branch'**
  String get adminDialogAddBranchTitle;

  /// No description provided for @adminDialogEditBranchTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Branch'**
  String get adminDialogEditBranchTitle;

  /// No description provided for @adminDialogBranchSuccessAdd.
  ///
  /// In en, this message translates to:
  /// **'Branch \"{name}\" added'**
  String adminDialogBranchSuccessAdd(Object name);

  /// No description provided for @adminDialogBranchSuccessUpdate.
  ///
  /// In en, this message translates to:
  /// **'Branch \"{name}\" updated'**
  String adminDialogBranchSuccessUpdate(Object name);

  /// No description provided for @adminDialogBranchErrorAdd.
  ///
  /// In en, this message translates to:
  /// **'Error adding branch: {error}'**
  String adminDialogBranchErrorAdd(Object error);

  /// No description provided for @adminDialogBranchNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch Name'**
  String get adminDialogBranchNameLabel;

  /// No description provided for @adminDialogAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get adminDialogAddressLabel;

  /// No description provided for @adminDialogManagerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Manager Name'**
  String get adminDialogManagerNameLabel;

  /// No description provided for @adminDialogAddBranchButton.
  ///
  /// In en, this message translates to:
  /// **'Add Branch'**
  String get adminDialogAddBranchButton;

  /// No description provided for @adminDialogCreatePostTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Post'**
  String get adminDialogCreatePostTitle;

  /// No description provided for @adminDialogPostContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Post Content'**
  String get adminDialogPostContentLabel;

  /// No description provided for @adminDialogPostContentHint.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get adminDialogPostContentHint;

  /// No description provided for @adminDialogPostButton.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get adminDialogPostButton;

  /// No description provided for @adminDialogPostSuccess.
  ///
  /// In en, this message translates to:
  /// **'Post created successfully'**
  String get adminDialogPostSuccess;

  /// No description provided for @adminDialogPostError.
  ///
  /// In en, this message translates to:
  /// **'Error creating post: {error}'**
  String adminDialogPostError(Object error);

  /// No description provided for @adminDialogPendingPostsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending Posts'**
  String get adminDialogPendingPostsTitle;

  /// No description provided for @adminDialogNoPendingPosts.
  ///
  /// In en, this message translates to:
  /// **'No pending posts'**
  String get adminDialogNoPendingPosts;

  /// No description provided for @adminDialogUnknownMember.
  ///
  /// In en, this message translates to:
  /// **'Unknown Member'**
  String get adminDialogUnknownMember;

  /// No description provided for @adminDialogJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get adminDialogJustNow;

  /// No description provided for @adminDialogRejectButton.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get adminDialogRejectButton;

  /// No description provided for @adminDialogApproveButton.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get adminDialogApproveButton;

  /// No description provided for @adminDialogPostRejected.
  ///
  /// In en, this message translates to:
  /// **'Post Rejected'**
  String get adminDialogPostRejected;

  /// No description provided for @adminDialogPostApproved.
  ///
  /// In en, this message translates to:
  /// **'Post Approved'**
  String get adminDialogPostApproved;

  /// No description provided for @adminDialogClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get adminDialogClose;

  /// No description provided for @adminDialogPendingPaymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending Payments'**
  String get adminDialogPendingPaymentsTitle;

  /// No description provided for @adminDialogNoPendingPayments.
  ///
  /// In en, this message translates to:
  /// **'No pending payments'**
  String get adminDialogNoPendingPayments;

  /// No description provided for @adminDialogAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount: {amount} DZD'**
  String adminDialogAmountLabel(Object amount);

  /// No description provided for @adminDialogUserLabel.
  ///
  /// In en, this message translates to:
  /// **'User: {user}'**
  String adminDialogUserLabel(Object user);

  /// No description provided for @adminDialogValidateButton.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get adminDialogValidateButton;

  /// No description provided for @adminDialogPaymentValidated.
  ///
  /// In en, this message translates to:
  /// **'Payment Validated'**
  String get adminDialogPaymentValidated;

  /// No description provided for @programNoEnrollments.
  ///
  /// In en, this message translates to:
  /// **'You are not enrolled in any program'**
  String get programNoEnrollments;

  /// No description provided for @programDiscoverCta.
  ///
  /// In en, this message translates to:
  /// **'Discover Programs'**
  String get programDiscoverCta;

  /// No description provided for @programJoin.
  ///
  /// In en, this message translates to:
  /// **'Join Program'**
  String get programJoin;

  /// No description provided for @programJoining.
  ///
  /// In en, this message translates to:
  /// **'Joining...'**
  String get programJoining;

  /// No description provided for @programEnrollSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully enrolled!'**
  String get programEnrollSuccess;

  /// No description provided for @programEnrollError.
  ///
  /// In en, this message translates to:
  /// **'Enrollment error: {error}'**
  String programEnrollError(Object error);

  /// No description provided for @paymentUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get paymentUploading;

  /// No description provided for @paymentProofSuccess.
  ///
  /// In en, this message translates to:
  /// **'Proof uploaded successfully!'**
  String get paymentProofSuccess;

  /// No description provided for @sparringNoPartners.
  ///
  /// In en, this message translates to:
  /// **'No partners found'**
  String get sparringNoPartners;

  /// No description provided for @settingsSectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'SECURITY'**
  String get settingsSectionSecurity;

  /// No description provided for @settingsEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get settingsEditProfile;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get settingsThemeLight;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get settingsNotifications;

  /// No description provided for @settingsChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get settingsChangePassword;

  /// No description provided for @settingsPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get settingsPhone;

  /// No description provided for @settingsSectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get settingsSectionNotifications;

  /// No description provided for @settingsPushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get settingsPushNotifications;

  /// No description provided for @settingsEmailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get settingsEmailNotifications;

  /// No description provided for @settingsEmailNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Summaries, invoices'**
  String get settingsEmailNotificationsDesc;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsRamadanOff.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Mode Disabled'**
  String get settingsRamadanOff;

  /// No description provided for @settingsSectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsSectionLanguage;

  /// No description provided for @settingsSectionGymPreferences.
  ///
  /// In en, this message translates to:
  /// **'GYM PREFERENCES'**
  String get settingsSectionGymPreferences;

  /// No description provided for @settingsFavoriteBranch.
  ///
  /// In en, this message translates to:
  /// **'Favorite Branch'**
  String get settingsFavoriteBranch;

  /// No description provided for @settingsFitnessGoal.
  ///
  /// In en, this message translates to:
  /// **'Fitness Goal'**
  String get settingsFitnessGoal;

  /// No description provided for @settingsSectionPrivacy.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY'**
  String get settingsSectionPrivacy;

  /// No description provided for @settingsProfileVisibility.
  ///
  /// In en, this message translates to:
  /// **'Profile Visibility'**
  String get settingsProfileVisibility;

  /// No description provided for @settingsProfileVisibilityDesc.
  ///
  /// In en, this message translates to:
  /// **'Who can see my stats'**
  String get settingsProfileVisibilityDesc;

  /// No description provided for @settingsDownloadData.
  ///
  /// In en, this message translates to:
  /// **'Download My Data'**
  String get settingsDownloadData;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get settingsSectionAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get settingsTerms;

  /// No description provided for @settingsContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get settingsContactSupport;

  /// No description provided for @dashboardHello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get dashboardHello;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready for your workout?'**
  String get dashboardSubtitle;

  /// No description provided for @dashboardExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get dashboardExpired;

  /// No description provided for @dashboardActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get dashboardActive;

  /// No description provided for @dashboardRenew.
  ///
  /// In en, this message translates to:
  /// **'Renew Now'**
  String get dashboardRenew;

  /// No description provided for @dashboardDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Today} =1{1 day left} other{{count} days left}}'**
  String dashboardDaysLeft(num count);

  /// No description provided for @dashboardPayNow.
  ///
  /// In en, this message translates to:
  /// **'PAY NOW'**
  String get dashboardPayNow;

  /// No description provided for @dashboardThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get dashboardThisWeek;

  /// No description provided for @dashboardQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashboardQuickActions;

  /// No description provided for @dashboardQRCode.
  ///
  /// In en, this message translates to:
  /// **'My QR Code'**
  String get dashboardQRCode;

  /// No description provided for @dashboardBookClass.
  ///
  /// In en, this message translates to:
  /// **'Book Class'**
  String get dashboardBookClass;

  /// No description provided for @dashboardMyStats.
  ///
  /// In en, this message translates to:
  /// **'My Stats'**
  String get dashboardMyStats;

  /// No description provided for @dashboardCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get dashboardCommunity;

  /// No description provided for @settingsSectionApp.
  ///
  /// In en, this message translates to:
  /// **'APP SETTINGS'**
  String get settingsSectionApp;

  /// No description provided for @settingsThemeDesc.
  ///
  /// In en, this message translates to:
  /// **'Light / Dark'**
  String get settingsThemeDesc;

  /// No description provided for @settingsSectionSupport.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get settingsSectionSupport;

  /// No description provided for @settingsHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get settingsHelpCenter;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsRamadanModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable Ramadan mode'**
  String get settingsRamadanModeDesc;

  /// No description provided for @settingsChooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get settingsChooseLanguage;

  /// No description provided for @settingsDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccountTitle;

  /// No description provided for @settingsDeleteAccountContent.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible. All your data will be permanently deleted.'**
  String get settingsDeleteAccountContent;

  /// No description provided for @settingsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsCancel;

  /// No description provided for @settingsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get settingsDelete;

  /// No description provided for @settingsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get settingsSave;

  /// No description provided for @coachNewProgramTitle.
  ///
  /// In en, this message translates to:
  /// **'New Program'**
  String get coachNewProgramTitle;

  /// No description provided for @coachProgramName.
  ///
  /// In en, this message translates to:
  /// **'Program Name'**
  String get coachProgramName;

  /// No description provided for @coachProgramDesc.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get coachProgramDesc;

  /// No description provided for @coachProgramType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get coachProgramType;

  /// No description provided for @coachProgramLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get coachProgramLevel;

  /// No description provided for @coachProgramSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions / week'**
  String get coachProgramSessions;

  /// No description provided for @coachCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get coachCreate;

  /// No description provided for @commonRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get commonRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
