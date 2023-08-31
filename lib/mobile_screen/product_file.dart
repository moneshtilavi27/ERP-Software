import 'package:flutter/material.dart';


class Product {
  final String name;
  final String image;
  final List<String> units;
  String selectedUnit;
  int quantity;

  Product({
    required this.name,
    required this.image,
    required this.units,
    this.quantity = 0,
  }) : selectedUnit = units.isNotEmpty ? units[0] : '';
}

class ProductListUI extends StatefulWidget {
  const ProductListUI({super.key});

  @override
  _ProductListUIState createState() => _ProductListUIState();
}

class _ProductListUIState extends State<ProductListUI> {
  List<Product> products = [
    Product(
        name: 'Product Product Product',
        image: 'image1.jpg',
        units: ['pcs', 'kg', 'g']),
    Product(name: 'Product 2', image: 'image2.jpg', units: ['pcs', 'kg', 'g']),
    Product(name: 'Product 3', image: 'image3.jpg', units: ['pcs', 'kg', 'g']),
    // Add more products here
  ];

  void incrementQuantity(int index) {
    setState(() {
      products[index].quantity++;
    });
  }

  void decrementQuantity(int index) {
    setState(() {
      if (products[index].quantity > 0) {
        products[index].quantity--;
      }
    });
  }

  void onUnitChanged(int index, String newUnit) {
    setState(() {
      products[index].selectedUnit = newUnit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            products[index].name,
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          subtitle: Text(products[index].name,
              textAlign: TextAlign.start,
              maxLines: 1,
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          trailing: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.currency_rupee_rounded),
              Text(
                "500 / Kg",
                style: TextStyle(
                    color: Color.fromARGB(255, 128, 127, 124),
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          onTap: () {},
        );
      },
    );
  }
}



// Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Image(
//                     alignment: Alignment.center,
//                     fit: BoxFit.contain,
//                     image: AssetImage('lib/service/asset/logo.png'),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 160,
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           products[index].name,
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.w400),
//                         ),
//                         Text(products[index].name,
//                             style: TextStyle(
//                                 color: Colors.grey.shade400,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w600)),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 0),
//                   child: SizedBox(
//                     width: 80,
//                     height: 35,
//                     child: Button(
//                       onPress: () {
//                         // callAPI();
//                       },
//                       btnColor: Colors.orange,
//                       textColor: Colors.white,
//                       btnText: 'Add',
//                     ),
//                   ),
//                 ),
//               ],
//             ),