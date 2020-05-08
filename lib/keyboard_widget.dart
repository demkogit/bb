import 'package:bb/ProductItem.dart';
import 'package:bb/cart_bloc.dart';
import 'package:bb/data_model_done.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';

// class KeyboardWidget extends StatelessWidget {
//   final CartBloc cartBloc = CartBloc();

//   @override
//   Widget build(BuildContext context) {
//     //var model = Provider.of<DataModelBloc>(context);
//     var model = Provider.of<DataModel>(context);

//     return Visibility(
//       child: Positioned(
//         bottom: 0,
//         child: Container(
//             color: Colors.red,
//             width: MediaQuery.of(context).size.width,
//             height: 40,
//             child: Provider.of<DataModel>(context).product.id == -1
//                 ? Text('')
//                 : RaisedButton(
//                     child: Text('Done'),
//                     onPressed: _onPressed(
//                         Provider.of<DataModel>(context).context,
//                         Provider.of<DataModel>(context).controller,
//                         Provider.of<DataModel>(context).product))),
//       ),
//     );
//   }

//   _onPressed(BuildContext context, TextEditingController controller,
//       ProductItem product) {
//     if (controller.text.isEmpty) {
//       controller.text = '0';
//       product.count = 0;
//     } else
//       product.count = int.parse(controller.text);
//     print('productcount: ${product.count}');
//     cartBloc.changeCount.add(product);
//     FocusScope.of(context).unfocus();
//   }
// }

class KeyboardWidget extends StatefulWidget {
  @override
  _KeyboardWidgetState createState() => _KeyboardWidgetState();
}

class _KeyboardWidgetState extends State<KeyboardWidget> {
  final CartBloc cartBloc = CartBloc();
  bool isKeyboadVisible = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // KeyboardVisibilityNotification().addNewListener(
    //   onChange: (bool visible) {
    //     print(visible);
    //     setState(() => isKeyboadVisible = visible);
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<DataModel>(context);

    return Visibility(
      visible: model.controller == 'null',
      child: Positioned(
        bottom: 0,
        child: Container(
            color: Colors.red,
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: model.product.id == -1
                ? Text('')
                : RaisedButton(
                    child: Text('asdas'),
                    onPressed: _onPressed(
                        model.context, model.controller, model.product))),
      ),
    );
  }

  _onPressed(BuildContext context, TextEditingController controller,
      ProductItem product) {
    if (controller.text.isEmpty) {
      controller.text = '0';
      product.count = 0;
    } else
      product.count = int.parse(controller.text);
    print('productcount: ${product.count}');
    cartBloc.changeCount.add(product);
    FocusScope.of(context).unfocus();
  }
}
