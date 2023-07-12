import 'package:flutter/material.dart';
// import 'package:multiselect_formfield/multiselect_formfield.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.contain,
    width: 240,
    height: 240,
    // color: Colors.white,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.blue.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

DropdownButtonFormField<String> reusableDropdownButton(
    String labelText,
    String? value,
    IconData icon,
    List<DropdownMenuItem<String>> items,
    Function(String?) onChanged) {
  return DropdownButtonFormField<String>(
    value: value,
    items: items,
    onChanged: onChanged,
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.blue.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none),
    ),
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    iconEnabledColor: Colors.white70,
    dropdownColor: Colors.blue.withOpacity(0.3),
  );
}

// MultiSelectFormField<String> reusableMultiSelectDropdownButton(
//     String labelText,
//     List<String> selectedValues,
//     List<DropdownMenuItem<String>> items,
//     Function(dynamic) onChanged) {
//   return MultiSelectFormField(
//     autovalidate: AutovalidateMode.onUserInteraction,
//     chipBackGroundColor: Colors.blue.withOpacity(0.3),
//     chipLabelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
//     dialogTextStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
//     checkBoxActiveColor: Colors.white70,
//     checkBoxCheckColor: Colors.white.withOpacity(0.9),
//     dialogShapeBorder: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.all(Radius.circular(12.0)),
//     ),
//     title: Text(
//       labelText,
//       style: TextStyle(color: Colors.white.withOpacity(0.9)),
//     ),
//     validator: (value) {
//       if (value == null || value.isEmpty) {
//         return 'Please select at least one option';
//       }
//       return null;
//     },
//     dataSource: items.map((item) {
//       return {"display": item.child, "value": item.value};
//     }).toList(),
//     textFieldBuilder: (controller, focusNode) {
//       return reusableTextField(
//         labelText,
//         Icons.arrow_drop_down,
//         false,
//         controller,
//       );
//     },
//     initialValue: selectedValues,
//     onSaved: onChanged,
//   );
// }

// // Inside _SignUpScreenState
// List<DropdownMenuItem<String>> _facultyDropdownItems = [
//   const DropdownMenuItem(
//     value: "Faculty of Science & Agriculture",
//     child: Text('Faculty of Science & Agriculture'),
//   ),
//   const DropdownMenuItem(
//     value: "Faculty of Education",
//     child: Text('Faculty of Education'),
//   ),
//   const DropdownMenuItem(
//     value: "Faculty of Arts",
//     child: Text('Faculty of Arts'),
//   ),
//   const DropdownMenuItem(
//     value: "Faculty of Commerce, Administration & Law",
//     child: Text('Faculty of Commerce, Administration & Law'),
//   ),
// ];
