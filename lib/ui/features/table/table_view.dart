import 'package:flutter/material.dart';
import 'package:flutter_proyect/data/repositories/order_repository.dart';
import 'package:flutter_proyect/data/repositories/products_repository.dart';
import 'package:flutter_proyect/data/repositories/table_repository.dart';
import 'package:flutter_proyect/data/services/database/database_service.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/domain/constants.dart';
import 'package:flutter_proyect/ui/core/widgets/edit_product.dart';
import 'package:flutter_proyect/ui/core/widgets/keyboard.dart';
import 'package:flutter_proyect/ui/core/widgets/product_list.dart';
import 'package:flutter_proyect/ui/core/widgets/product_types.dart';
import 'package:flutter_proyect/ui/core/widgets/products.dart';
import 'package:flutter_proyect/ui/features/table/checkout.dart';
import 'package:flutter_proyect/ui/features/table/forms/add_products_form.dart';
import 'package:flutter_proyect/ui/features/table/forms/add_types_form.dart';
import 'package:flutter_proyect/ui/features/table/forms/edit_products_form.dart';
import 'package:flutter_proyect/ui/features/table/forms/edit_types_form.dart';
import 'package:flutter_proyect/ui/features/table/forms/free_price_form.dart';
import 'package:flutter_proyect/ui/features/table/split_table.dart';
import 'package:flutter_proyect/ui/features/table/view_models/table_view_model.dart';
import 'package:provider/provider.dart';

class TableView extends StatefulWidget {
  const TableView({super.key, required this.table});
  final RestTable table;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  late final TableViewModel _viewModel = TableViewModel(
    orderRepository: OrderRepository(context.read<DatabaseService>().database),
    tableRepository: TableRepository(context.read<DatabaseService>().database),
    productRepository: ProductRepository(
      context.read<DatabaseService>().database,
    ),
    table: widget.table,
  );
  @override
  void initState() {
    super.initState();
    _viewModel.initialize();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  // ***************************************
  // ***PRODUCT TYPE RELATED***

  void onEditProductType(ProductTypesTableData productType) async {
    final String? newName = await showDialog<String>(
      context: context,
      builder: (context) => EditTypesForm(product: productType),
    );
    _viewModel.onEditProductType(productType, newName);
  }

  void onAddProductType() async {
    final AddTypesFormResponse? result = await showDialog<AddTypesFormResponse>(
      context: context,
      builder: (context) => AddTypesForm(),
    );
    _viewModel.onAddProductType(result);
  }

  // ***************************************************
  // ***PRODUCT RELATED***
  void onEditProduct(ProductsClassData product) async {
    final EditProductsFormResponse? result =
        await showDialog<EditProductsFormResponse>(
          context: context,
          builder: (context) => EditProductsForm(product: product),
        );

    _viewModel.onEditProduct(result, product);
  }

  void onAddProduct() async {
    final AddProductsFormResponse? result =
        await showDialog<AddProductsFormResponse>(
          context: context,
          builder: (context) =>
              AddProductsForm(selectedFamily: _viewModel.selectedType),
        );
    _viewModel.onAddProduct(result);
  }

  // ****************************************************

  // ***PRODUCT LIST RELATED***

  void onSaveEditProductList() async {
    final FreePriceResult? result = await showDialog<FreePriceResult>(
      context: context,
      builder: (context) => FreePriceForm(),
    );
    _viewModel.onSaveEditProductList(result);
  }

  void onCheckout() async {
    await _viewModel.updateOrders();
    if (!mounted) return;
    if (!_viewModel.orderLines.isNotEmpty) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            "No hay productos en la mesa",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ok', style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      );
      return;
    }

    final List<Order>? result = await showDialog<List<Order>>(
      context: context,
      builder: (context) => Checkout(mesaID: widget.table.id),
    );
    if (!mounted) return;
    if (result?.isEmpty ?? false) {
      Navigator.of(context).pop();
    }
    _viewModel.postCheckout();
  }

  void onSplitTable() async {
    await _viewModel.updateOrders();
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => SplitTable(mesa: widget.table),
    );
    _viewModel.postCheckout();
  }

  void onDeleteTable() async {
    final result =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.spaceBetween,
            content: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Estas seguro que deseas borrar la mesa?",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'No',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Si',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ) ??
        0;
    if (result && context.mounted) {
      await _viewModel.onDeleteTable();

      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  // *** Print Related ***

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            return Row(
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Expanded(
                        child: ProductList(
                          items: _viewModel.orderLines,
                          onSelectProduct: _viewModel.onEditProductList,
                          mesa: widget.table.number,
                        ),
                      ),
                      Flexible(
                        child: Keyboard(
                          key: _viewModel.keyboardKey,
                          onChangePriceText: _viewModel.onChangePriceText,
                          onEnter: _viewModel.onTapProduct,
                          onCheckout: onCheckout,
                          onDeleteTable: onDeleteTable,
                          onSplitTable: onSplitTable,
                          onPrintReceive: _viewModel.onPrintReceive,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Builder(
                    builder: (context) {
                      if (_viewModel.editedProduct == null) {
                        return Column(
                          children: [
                            Flexible(
                              child: ProductTypes(
                                productTypesList: _viewModel.productTypes,
                                onSelectType: _viewModel.selectType,
                                onEditType: onEditProductType,
                                onAddType: onAddProductType,
                              ),
                            ),
                            Visibility(
                              visible:
                                  _viewModel.selectedType != allProductTypesId,
                              child: Flexible(
                                child: Products(
                                  productsList: _viewModel.products
                                      .where(
                                        (e) =>
                                            e.type == _viewModel.selectedType,
                                      )
                                      .toList(),
                                  onEditProduct: onEditProduct,
                                  onAddProduct: onAddProduct,
                                  onTapProduct: _viewModel.onTapProduct,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return EditProduct(
                        product: _viewModel.editedProduct,
                        onSaveProduct: onSaveEditProductList,
                        onCancelEdit: _viewModel.onCancelEditProductList,
                        onRemoveProduct: _viewModel.onRemoveProductFromList,
                        onAddProductUnit: _viewModel.onAddProductUnitFromList,
                        onRemoveProductUnit:
                            _viewModel.onRemoveProductUnitFromList,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
