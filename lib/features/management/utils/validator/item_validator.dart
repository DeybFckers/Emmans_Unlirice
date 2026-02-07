class ItemValidator {

  static String? name(String? value){
    if(value == null || value.isEmpty){
      return 'Please enter Item Name';
    }
    return null;
  }

  static String? cost(String? value){
    if(value == null || value.isEmpty){
      return 'Please enter Product Cost';
    }

    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return 'Please enter a valid Cost';
    }
    return null;
  }

}