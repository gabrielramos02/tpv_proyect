import 'package:flutter/material.dart';
import 'package:flutter_proyect/utils/proyect_styles.dart';

class EditProduct extends StatelessWidget {
  const EditProduct({
    super.key,
    required this.product,
    required this.onSaveProduct,
    required this.onCancelEdit,
    required this.onRemoveProduct,
    required this.onAddProductUnit,
    required this.onRemoveProductUnit,
  });
  final Map<String, dynamic> product;
  final void Function(Map<String, dynamic>) onSaveProduct;
  final void Function(Map<String, dynamic>) onRemoveProduct;
  final void Function(Map<String, dynamic>) onAddProductUnit;
  final void Function(Map<String, dynamic>) onRemoveProductUnit;
  final void Function() onCancelEdit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(border: BoxBorder.all(color: Colors.black)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  ElevatedButton(
                    style: ProyectStyles.buttonStyles(context),
                    onPressed: () {
                      onCancelEdit();
                    },
                    child: Text(
                      "Precio Libre",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  ElevatedButton(
                    style: ProyectStyles.buttonStyles(context),
                    onPressed: () {
                      onRemoveProductUnit(product);
                      product["quantity"] --;
                    },
                    child: Text(
                      "-",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  ElevatedButton(
                    style: ProyectStyles.buttonStyles(context),
                    onPressed: () {
                      onAddProductUnit(product);
                      product["quantity"] ++;
                    },
                    child: Text(
                      "+",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  ElevatedButton(
                    style: ProyectStyles.buttonStyles(context),
                    onPressed: () {
                      onCancelEdit();
                    },
                    child: Text(
                      "Back",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  ElevatedButton(
                    style: ProyectStyles.buttonStyles(context),
                    onPressed: () {
                      onRemoveProduct(product);
                    },
                    child: Text(
                      "Remove",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
