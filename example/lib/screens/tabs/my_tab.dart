import 'package:flutter/material.dart';
import 'package:m3e_widgets/m3e_widgets.dart';

// TODO
// remove hover radius animation
// focus ring

class MyTab extends StatefulWidget {
  const MyTab({super.key});

  @override
  State<MyTab> createState() => _MyTabState();
}

class _MyTabState extends State<MyTab> {
  final sizes = <M3EButtonSize>[.sm, .xs, .md, .lg, .xl];
  final styles = <M3EButtonStyle>[
    .elevated,
    .filled,
    .outlined,
    .tonal,
    .text,
    .standard,
  ];
  var styleIndex = 1;

  final iconWidth = <M3EIconButtonWidth>[.narrow, .standard, .wide];
  var iconWidthIndex = 1;

  final widgetTypes = [
    'button',
    'iconButton',
    'toggle',
    'iconToggle',
    'splitButton',
  ];
  var typeIndex = 4;

  bool enabled = true;
  bool isRound = true;
  bool toggled = false;

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              M3EToggleButtonGroup(
                type: .connected,
                style: .filled,
                selectedIndex: typeIndex,
                onSelectedIndexChanged: (value) => setState(() {
                  if (value == null) return;
                  typeIndex = value;
                }),
                actions: List.generate(
                  widgetTypes.length,
                  (index) => M3EToggleButtonGroupAction(
                    label: Text(widgetTypes[index]),
                  ),
                ),
              ),
              M3EToggleButtonGroup(
                style: .tonal,
                selectedIndex: styleIndex,
                onSelectedIndexChanged: (value) => setState(() {
                  if (value == null) return;
                  styleIndex = value;
                }),
                actions: List.generate(
                  styles.length,
                  (index) => M3EToggleButtonGroupAction(
                    label: Text(styles[index].toString().split('.').last),
                  ),
                ),
              ),
              Row(
                children: [
                  Text('Enabled'),
                  Switch(
                    value: enabled,
                    onChanged: (value) => setState(() {
                      enabled = value;
                    }),
                  ),
                  if (typeIndex == 0 || typeIndex == 1) Text('Round'),
                  if (typeIndex == 0 || typeIndex == 1)
                    Switch(
                      value: isRound,
                      onChanged: (value) => setState(() {
                        isRound = value;
                      }),
                    ),
                ],
              ),
              if (typeIndex == 1 || typeIndex == 3)
                M3EToggleButtonGroup(
                  type: .connected,
                  style: .outlined,
                  selectedIndex: iconWidthIndex,
                  onSelectedIndexChanged: (value) => setState(() {
                    if (value == null) return;
                    iconWidthIndex = value;
                  }),
                  actions: List.generate(
                    iconWidth.length,
                    (index) => M3EToggleButtonGroupAction(
                      label: Text(iconWidth[index].toString().split('.').last),
                    ),
                  ),
                ),
              SizedBox(height: 48),
              if (typeIndex == 0)
                Column(
                  spacing: 8,
                  children: List.generate(
                    sizes.length,
                    (index) => M3EButton.icon(
                      shape: isRound ? .round : .square,
                      size: sizes[index],
                      enabled: enabled,
                      onPressed: () {},
                      style: styles[styleIndex],
                      label: Text('Label'),
                      icon: Icon(Icons.stars),
                    ),
                  ),
                ),
              if (typeIndex == 1)
                Column(
                  spacing: 8,
                  children: List.generate(
                    sizes.length,
                    (index) => M3EIconButton(
                      width: iconWidth[iconWidthIndex],
                      shape: isRound ? .round : .square,
                      size: sizes[index],
                      enabled: enabled,
                      onPressed: () {},
                      style: styles[styleIndex],
                      icon: Icon(Icons.stars),
                    ),
                  ),
                ),
              if (typeIndex == 2)
                Column(
                  spacing: 8,
                  children: List.generate(
                    sizes.length,
                    (index) => M3EToggleButton(
                      size: sizes[index],
                      checked: toggled,
                      enabled: enabled,
                      onCheckedChange: (value) => setState(() {
                        toggled = value;
                      }),
                      style: styles[styleIndex],
                      label: Text('Label'),
                      icon: Icon(Icons.stars_outlined),
                      checkedIcon: Icon(Icons.stars),
                    ),
                  ),
                ),
              if (typeIndex == 3)
                Column(
                  spacing: 8,
                  children: List.generate(
                    sizes.length,
                    (index) => M3EToggleIconButton(
                      width: iconWidth[iconWidthIndex],
                      size: sizes[index],
                      checked: toggled,
                      enabled: enabled,
                      onCheckedChange: (value) => setState(() {
                        toggled = value;
                      }),
                      style: styles[styleIndex],
                      icon: Icon(Icons.stars_outlined),
                      checkedIcon: Icon(Icons.stars),
                    ),
                  ),
                ),
              if (typeIndex == 4)
                Column(
                  spacing: 8,
                  children: List.generate(
                    sizes.length - 1,
                    (index) => M3ESplitButton(
                      label: 'Label',
                      onSelected: print,
                      items: [
                        M3ESplitButtonItem(value: '1', label: 'One', icon: Icons.one_k),
                        M3ESplitButtonItem(value: '2', child: Text('Data')),
                        M3ESplitButtonItem(value: '3', child: Text('Data')),
                      ],
                      onPressed: () {},
                      size: sizes[index],
                      enabled: enabled,
                      style: styles[styleIndex],
                      leadingIcon: Icons.stars_outlined,
                    ),
                  ),
                ),
              SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
