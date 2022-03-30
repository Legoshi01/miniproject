class Listservice {
  int? value;
  String? name;

  Listservice(this.value, this.name);

  static List<Listservice> getListservice() {
    return [
      Listservice(1, 'ขัดหินปูน'),
      Listservice(2, 'ดัดฟัน'),
      Listservice(3, 'ถอนฟัน'),
    ];
  }
}
