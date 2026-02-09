class ItemValidator {

  static String? name(String? value){
    if(value == null || value.isEmpty){
      return 'Please enter Item Name';
    }
    return null;
  }

  static String? cost(String? value){
    if(value == null || value.isEmpty){
      return 'Please enter Item Cost';
    }
    final cost = double.tryParse(value);
    if(cost == null){
      return 'Please enter a valid number';
    }
    if(cost <= 0){
      return 'Cost must be greater than 0';
    }
    return null;
  }

}