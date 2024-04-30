part of 'my_widgets.dart';

class MyLogOutButton extends StatelessWidget {
  final bool isHidden;

  MyLogOutButton(this.isHidden);

  @override
  Widget build(BuildContext context) {
    return isHidden
        ? Container()
        : IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(const SignOutRequired());
            },
            icon: const Icon(Icons.login),
          );
  }
}