/*
 *  This file is part of BoxBox (https://github.com/BrightDV/BoxBox).
 * 
 * BoxBox is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * BoxBox is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with BoxBox.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Copyright (c) 2022, BrightDV
 */

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditOrderScreen extends StatefulWidget {
  final Function updateParent;
  const EditOrderScreen(this.updateParent, {Key? key}) : super(key: key);

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  @override
  Widget build(BuildContext context) {
    bool useDarkMode =
        Hive.box('settings').get('darkMode', defaultValue: true) as bool;
    List feedsNames = Hive.box('feeds').get(
      'feedsNames',
      defaultValue: [
        'WTF1.com',
        'Racefans.net',
        'Beyondtheflag.com',
        'Motorsport.com',
        'Autosport.com',
        'GPFans.com',
        'Racer.com',
        'Thecheckeredflag.co.uk',
        'Motorsportweek.com',
        'Crash.net',
        'Pitpass.com',
      ],
    ) as List;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
      ),
      backgroundColor:
          useDarkMode ? Theme.of(context).backgroundColor : Colors.white,
      body: Theme(
        data: ThemeData(canvasColor: Colors.transparent),
        child: ReorderableListView.builder(
          header: Padding(
            padding: EdgeInsets.all(5),
            child: Text.rich(
              TextSpan(
                text: 'Change order by long-pressing an item.',
              ),
              style: TextStyle(
                color:
                    useDarkMode ? Colors.grey.shade500 : Colors.grey.shade300,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          itemBuilder: (context, index) => ListTile(
            key: Key('$index'),
            title: Text(
              feedsNames[index],
              style: TextStyle(
                color: useDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          itemCount: feedsNames.length,
          onReorder: (int oldIndex, int newIndex) {
            setState(
              () {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final String item = feedsNames.removeAt(oldIndex);
                feedsNames.insert(newIndex, item);
                Hive.box('feeds').put('feedsNames', feedsNames);
                widget.updateParent();
              },
            );
          },
        ),
      ),
    );
  }
}
