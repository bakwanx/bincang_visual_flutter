extension ImagePath on String? {
  String svg() {
    return 'assets/images/$this.svg';
  }

  String gif() {
    return 'assets/images/$this.gif';
  }

  String png() {
    return 'assets/images/$this.png';
  }

  String jpg() {
    return 'assets/images/$this.jpg';
  }
}
