part of 'helpers.dart';

showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const AlertDialog(
      title: Text('Espere...'),
      content: LinearProgressIndicator(),
    ),
  );
}

showAlert(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        MaterialButton(
          child: const Text('Ok'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ),
  );
}
