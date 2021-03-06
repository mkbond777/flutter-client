import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoiceninja_flutter/data/models/entities.dart';
import 'package:invoiceninja_flutter/ui/app/forms/custom_field.dart';
import 'package:invoiceninja_flutter/ui/vendor/edit/vendor_edit_vm.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:invoiceninja_flutter/ui/app/form_card.dart';

class VendorEditDetails extends StatefulWidget {
  const VendorEditDetails({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final VendorEditVM viewModel;

  @override
  VendorEditDetailsState createState() => VendorEditDetailsState();
}

class VendorEditDetailsState extends State<VendorEditDetails> {
  final _nameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _vatNumberController = TextEditingController();
  final _websiteController = TextEditingController();
  final _phoneController = TextEditingController();
  final _custom1Controller = TextEditingController();
  final _custom2Controller = TextEditingController();

  final List<TextEditingController> _controllers = [];

  @override
  void didChangeDependencies() {
    final List<TextEditingController> _controllers = [
      _nameController,
      _idNumberController,
      _vatNumberController,
      _websiteController,
      _phoneController,
      _custom1Controller,
      _custom2Controller,
    ];

    _controllers
        .forEach((dynamic controller) => controller.removeListener(_onChanged));

    final vendor = widget.viewModel.vendor;
    _nameController.text = vendor.name;
    _idNumberController.text = vendor.idNumber;
    _vatNumberController.text = vendor.vatNumber;
    _websiteController.text = vendor.website;
    _phoneController.text = vendor.workPhone;
    _custom1Controller.text = vendor.customValue1;
    _custom2Controller.text = vendor.customValue2;

    _controllers
        .forEach((dynamic controller) => controller.addListener(_onChanged));

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllers.forEach((dynamic controller) {
      controller.removeListener(_onChanged);
      controller.dispose();
    });

    super.dispose();
  }

  void _onChanged() {
    final viewModel = widget.viewModel;
    final vendor = viewModel.vendor.rebuild((b) => b
      ..name = _nameController.text.trim()
      ..idNumber = _idNumberController.text.trim()
      ..vatNumber = _vatNumberController.text.trim()
      ..website = _websiteController.text.trim()
      ..workPhone = _phoneController.text.trim()
      ..customValue1 = _custom1Controller.text.trim()
      ..customValue2 = _custom2Controller.text.trim());
    if (vendor != viewModel.vendor) {
      viewModel.onChanged(vendor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;
    final company = viewModel.company;

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        FormCard(
          children: <Widget>[
            TextFormField(
              autocorrect: false,
              controller: _nameController,
              decoration: InputDecoration(
                labelText: localization.name,
              ),
              validator: (String val) => val == null || val.isEmpty
                  ? AppLocalization.of(context).pleaseEnterAName
                  : null,
            ),
            TextFormField(
              autocorrect: false,
              controller: _idNumberController,
              decoration: InputDecoration(
                labelText: localization.idNumber,
              ),
            ),
            TextFormField(
              autocorrect: false,
              controller: _vatNumberController,
              decoration: InputDecoration(
                labelText: localization.vatNumber,
              ),
            ),
            TextFormField(
              autocorrect: false,
              controller: _websiteController,
              decoration: InputDecoration(
                labelText: localization.website,
              ),
              keyboardType: TextInputType.url,
            ),
            TextFormField(
              autocorrect: false,
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: localization.phone,
              ),
              keyboardType: TextInputType.phone,
            ),
            CustomField(
              controller: _custom1Controller,
              labelText: company.getCustomFieldLabel(CustomFieldType.vendor1),
              options: company.getCustomFieldValues(CustomFieldType.vendor1),
            ),
            CustomField(
              controller: _custom2Controller,
              labelText: company.getCustomFieldLabel(CustomFieldType.vendor2),
              options: company.getCustomFieldValues(CustomFieldType.vendor2),
            ),
          ],
        ),
      ],
    );
  }
}
