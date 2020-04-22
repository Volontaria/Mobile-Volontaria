import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// API configuration
final Map<String,String> routesAPI = {
  'activation':'/users/activate',
  'authentication':'/authentication',
  'cells':'/volunteer/cells',
  'cycles':'/volunteer/cycles',
  'events':'/volunteer/events',
  'participations':'/volunteer/participations',
  'profile':'/profile',
  'tasktypes':'/volunteer/tasktypes',
  'users':'/users',
  'reset_password':'/reset_password',
  'change_password':'/change_password',
};

// Theme configuration
// Colors
final Color defaultAccentColor = Colors.deepOrange;
final Color defaultAccentTextThemeTextStyleColor = Colors.white;
final Color defaultBackgroundColor = Color.fromRGBO(45, 62, 80, 1.0);
final Color defaultButtonColor = Color.fromRGBO(45, 62, 80, 1.0);
final Color defaultCardColor = Color.fromRGBO(45, 62, 80, 0.9);
final Color defaultCursorColor = Colors.white;
final Color defaultDialogBackgroundColor = Colors.white;
final Color defaultErrorColor = Colors.red;
final Color defaultHintColor = Colors.white;
final Color defaultPrimaryColor = Color.fromRGBO(45, 62, 80, 1.0);
final Color defaultTextThemeTextStyleColor = Colors.white;
final Color defaultIconThemeColor = Colors.white;
final Color defaultAlreadyRegisteredCardColor = Color.fromRGBO(0, 78, 56, 1.0);

final String defaultFontFamily = "Montserrat";

// Icons
final IconData defaultIconVolunteer = FontAwesomeIcons.userAlt;
final IconData defaultIconStandby = FontAwesomeIcons.userClock;

// Texts
final String cancellationDialogTitle = "Me désinscrire";
final String cancellationDialogDescription = "L'annulation de ta participation est un acte important puisque les autres bénévoles compte sur ta présence. Es-tu vraiment sûr de vouloir annuler ta participation ?";
final String registrationDialogTitle = "M'inscrire";
final String registrationDialogDescription = "Es-tu vraiment sûr de vouloir t'inscrire à cet évènement ?";
final String changeInstanceDialogTitle = "Changer d'organisme";
final String changeInstanceDialogDescription = "Cette action mène vers la configuration initiale de l'application. Es-tu vraiment sûr de vouloir de changer d'organisme ?";