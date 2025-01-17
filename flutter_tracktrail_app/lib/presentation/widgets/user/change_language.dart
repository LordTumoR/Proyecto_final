import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/language/language_bloc.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/language/language_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.changeLanguage),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("English"),
            onTap: () {
              BlocProvider.of<LanguageBloc>(context)
                  .add(ChangeLanguageEvent(const Locale('en')));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Español"),
            onTap: () {
              BlocProvider.of<LanguageBloc>(context)
                  .add(ChangeLanguageEvent(const Locale('es')));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Frances"),
            onTap: () {
              BlocProvider.of<LanguageBloc>(context)
                  .add(ChangeLanguageEvent(const Locale('fr')));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
