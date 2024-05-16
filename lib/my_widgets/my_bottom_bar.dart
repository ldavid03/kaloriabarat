part of 'my_widgets.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final Function(int) onTap;
  final int index;
  final bool isGuest;

  MyBottomNavigationBar({required this.onTap, required this.index, required this.isGuest});

  @override
  Widget build(BuildContext context) {
    Color selectedItem = Theme.of(context).colorScheme.secondary;
    Color unselectedItem = Theme.of(context).colorScheme.primary;

    return BottomNavigationBar(
      backgroundColor: getColorScheme(context).onSecondary,
      onTap: onTap,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: isGuest
          ? Icon(
            CupertinoIcons.restart,
            color: index == 0 ? selectedItem : unselectedItem,
          )
          
          :  Icon(
            CupertinoIcons.home,
            color: index == 0 ? selectedItem : unselectedItem,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                FontAwesomeIcons.solidMessage,
                color: index == 1 ? selectedItem : unselectedItem,
              ),
              Positioned(
        top: -2.0, // Adjust as needed
        left: 4.0, // Adjust as needed
        child: MyText("AI", "m", "b"),
      ),
            ],
          ),
          label: 'Stats',
        ),
      ],
    );
  }
}

class MyFloatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        
        //shape: BoxShape.circle,
        color: getColorScheme(context).secondary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: getColorScheme(context).shadow,
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Icon(CupertinoIcons.add,
          color: Theme.of(context).colorScheme.onSecondary),
    );
  }
}
