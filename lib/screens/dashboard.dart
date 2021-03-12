import 'package:byte_bank2/screens/contacts_feature.dart';
import 'package:byte_bank2/screens/transactions_list.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: LayoutBuilder(
        builder: (context, constrains) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constrains.maxHeight,
            ),
            child: Column(
              // main representa o Y do eixo
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'images/bytebank_logo.png',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  // InkWell precisa ser envolvido por Material
                  child: SingleChildScrollView(
                    // scroll horizontall y
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCard(
                          context,
                          'Transfer to',
                          Icon(
                            Icons.monetization_on_outlined,
                            color: Colors.white,
                          ),
                          onClick: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ContactsFeature(),
                            ));
                          },
                        ),
                        _buildCard(
                            context,
                            'Transaction Feed',
                            Icon(
                              Icons.description_outlined,
                              color: Colors.white,
                            ), onClick: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TransactionsList(),
                          ));
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String cardName, Icon cardIcon,
      {@required Function onClick}) {
    assert(cardIcon != null, onClick != null);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: Material(
        color: Theme.of(context).primaryColor,
        // gesturedetector do material
        child: InkWell(
          onTap: () {
            onClick();
          },
          child: Container(
            padding: EdgeInsets.all(8),
            height: 100,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cardIcon,
                Text(
                  cardName,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
