import 'package:flutter/material.dart';

class UserSearch extends SearchDelegate {
  List<dynamic> products;
  late String selectedResult = "";

  UserSearch(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(selectedResult),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<dynamic> suggestedUser = [];
    query.isEmpty
        ? suggestedUser = products
        : suggestedUser.addAll(products.where(
            (element) => element['item_name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()),
          ));

    return ListView.builder(
      itemCount: suggestedUser.length,
      itemBuilder: (context, index) => Column(
        children: [
          ListTile(
            title: Text(
              products[index]['item_name'],
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            subtitle: Text(products[index]['item_hsn'],
                textAlign: TextAlign.start,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.currency_rupee_rounded),
                Text(
                  products[index]['basic_value'] +
                      " / " +
                      products[index]['item_unit'],
                  style: const TextStyle(
                      color: Color.fromARGB(255, 162, 55, 28),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            onTap: () {},
            onLongPress: () {},
          ),
          const Divider(
            height: 5,
          )
        ],
      ),
    );
  }
}
