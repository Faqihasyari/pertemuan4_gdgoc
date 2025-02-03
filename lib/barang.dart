class Barang {
  Data() {
    return [
      {
        'barang_id': 1,
        'kode': 2300,
        'barang': 'Sepatu',
        'Harga': 120000
      },
      {
        'barang_id': 2,
        'kode': 2301,
        'barang': 'Sendal',
        'Harga': 15000
      },
      {
        'barang_id': 3,
        'kode': 2302,
        'barang': 'Pulpen',
        'Harga': 5000
      },
    ];
  }

  fintById(int id) {
    for (int i = 0; i < this.Data().length; i++) {
      var row = this.Data()[i];
      if (row['barang_id'] == id) {
        return row;
      }
    }
  }
}
