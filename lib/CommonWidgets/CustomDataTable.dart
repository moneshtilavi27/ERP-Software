import 'package:flutter/material.dart';

class CustomDataTable extends StatefulWidget {
  final List dataList;
  final List<Map<String, String>> columnList;

  const CustomDataTable(this.columnList, this.dataList, {Key? key})
      : super(key: key);

  @override
  _CustomDataTableState createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  // int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _rowsPerPage = 5;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void _sort<T>(Comparable<T> Function(Map<String, dynamic> d) getField,
      int columnIndex, bool ascending) {
    widget.dataList.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: PaginatedDataTable(
              rowsPerPage:
                  MediaQuery.of(context).size.width < 3 ? 5 : _rowsPerPage,
              availableRowsPerPage: const [5, 10, 25, 50, 100],
              onPageChanged: (int rowIndex) {
                print('Page changes to index $rowIndex');
              },
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              onRowsPerPageChanged: (int? value) {
                setState(() {
                  _rowsPerPage = value!;
                });
              },
              columns: [
                for (int i = 0; i < widget.columnList.length; i++)
                  DataColumn(
                    label: Text(
                      widget.columnList[i]['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onSort: (columnIndex, ascending) {
                      _sort<String>((d) => d[widget.columnList[i]['key']!],
                          columnIndex, ascending);
                    },
                  ),
              ],
              source: _DataSource(context, widget.dataList, widget.columnList),
            ),
          ),
        ),
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, this.dataList, this.columnList);

  final BuildContext context;
  final List dataList;
  final List<Map<String, String>> columnList;

  @override
  DataRow? getRow(int index) {
    if (index >= dataList.length) {
      return null;
    }
    final data = dataList[index];
    return DataRow(cells: [
      for (int i = 0; i < columnList.length; i++)
        DataCell(Text(data[columnList[i]['key']!].toString())),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dataList.length;

  @override
  int get selectedRowCount => 0;
}
