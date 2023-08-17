import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:erp/service/asset/constants.dart';

class ProductTable extends StatefulWidget {
  // final List columnList;
  final List<Map<String, String>> columnList;
  final List dataList;
  final Function? onTab;

  const ProductTable(
      {Key? key, required this.columnList, required this.dataList, this.onTab})
      : super(key: key);

  @override
  _ProductTableState createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
// ScrollGroupController,
  // To Scroll the multiple scroll-view in sync using controller
  LinkedScrollControllerGroup controllerGroup = LinkedScrollControllerGroup();

  ScrollController? headerScrollController;
  ScrollController? dataScrollController;

  @override
  void initState() {
    super.initState();
    headerScrollController = controllerGroup.addAndGet();
    dataScrollController = controllerGroup.addAndGet();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          tableContent(),
          tableHeader(),
        ],
      ),
    );
  }

  Widget tableContent() {
    return SingleChildScrollView(
      child: Row(children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: dataScrollController,
            child: DataTable(
              showCheckboxColumn: false,
              headingRowColor: MaterialStateProperty.all(Colors.blue),
              dataRowColor: MaterialStateProperty.all(Colors.blue.shade100),
              columns: [
                for (int i = 0; i < widget.columnList.length; i++)
                  DataColumn(
                    label: Text(
                      widget.columnList[i]['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
              rows: List.generate(widget.dataList.length, (index) {
                return DataRow(
                    color: ConstantValues.getTableTheams(context),
                    onSelectChanged: widget.onTab != null
                        ? (value) => ({widget.onTab!(widget.dataList[index])})
                        : (value) => {print(value)},
                    cells: [
                      for (int i = 0; i < widget.columnList.length; i++)
                        DataCell(SizedBox(
                            width: double.parse(widget.columnList[i]['width']!),
                            child: Text(widget.dataList[index]
                                    [widget.columnList[i]['key']!]
                                .toString()))),
                    ]);
              }),
            ),
          ),
        ),
      ]),
    );
  }

  Widget tableHeader() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: headerScrollController,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.blue),
              dataRowColor:
                  MaterialStateProperty.all(Color.fromARGB(255, 81, 164, 232)),
              columns: [
                for (int i = 0; i < widget.columnList.length; i++)
                  DataColumn(
                    label: SizedBox(
                      width: double.parse(widget.columnList[i]['width']!),
                      child: Text(
                        widget.columnList[i]['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
              rows: const [],
            ),
          ),
        ),
      ],
    );
  }
}
