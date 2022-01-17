class ShoppingModel{
  String text;

  ShoppingModel(this.text);

  Map<String, dynamic> toJson() => {
    'text': text,
  };
}
