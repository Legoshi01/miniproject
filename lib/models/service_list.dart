class Listservice {
  int? value;
  String? name;

  Listservice(this.value, this.name);

  static List<Listservice> getListProductType() {
    return [
      Listservice(1, 'โทรศัพท์มือถือ'),
      Listservice(2, 'สมาร์ททีวี'),
      Listservice(3, 'แท็บเล็ต'),
    ];
  }
}
