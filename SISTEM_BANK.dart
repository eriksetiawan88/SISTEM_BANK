import 'dart:io';

void main() {
  var saldo = 2000000;
  const pin = 112233;

  if (!login(pin)) {
    return;
  }

  while (true) {
    tampilkanMenu();
    final pilihan = stdin.readLineSync();

    if (pilihan == null) {
      return;
    }

    switch (pilihan.trim()) {
      case '1':
        print('\nSaldo Anda = Rp $saldo\n');
        break;
      case '2':
        final saldoBaru = setorTunai(saldo);
        if (saldoBaru == null) return;
        saldo = saldoBaru;
        break;
      case '3':
        final saldoBaru = tarikTunai(saldo);
        if (saldoBaru == null) return;
        saldo = saldoBaru;
        break;
      case '4':
        print('\nTerima kasih telah menggunakan ATM kami.');
        return;
      default:
        print('\nPilihan tidak valid. Silakan pilih menu 1-4.\n');
    }
  }
}

bool login(int pin) {
  while (true) {
    print('================================');
    print('          BANK SERBA ADA        ');
    print('================================');
    stdout.write('Masukkan PIN Anda: ');

    final inputPin = stdin.readLineSync();
    if (inputPin == null) {
      return false;
    }

    if (int.tryParse(inputPin.trim()) == pin) {
      print('\nLogin berhasil!\n');
      return true;
    }

    print('\nPIN yang Anda masukkan salah. Silakan coba lagi.\n');
  }
}

void tampilkanMenu() {
  print('================================');
  print('1. Cek Saldo');
  print('2. Setor Tunai');
  print('3. Tarik Tunai');
  print('4. Keluar');
  print('================================');
  stdout.write('Pilih menu (1/2/3/4): ');
}

int? setorTunai(int saldo) {
  final jumlah = bacaAngka('Masukkan jumlah yang ingin Anda setor: ');
  if (jumlah == null) return null;

  if (jumlah <= 0 || jumlah % 50000 != 0) {
    print('Setoran harus lebih dari 0 dan kelipatan Rp 50.000.\n');
    return saldo;
  }

  final saldoBaru = saldo + jumlah;
  print('Penyetoran berhasil!');
  print('Saldo Anda sekarang: Rp $saldoBaru\n');
  return saldoBaru;
}

int? tarikTunai(int saldo) {
  print('\n--- Tarik Tunai ---');
  final jumlahTarik = bacaAngka('Masukkan total uang yang ingin Anda tarik: ');
  if (jumlahTarik == null) return null;

  if (jumlahTarik <= 0 || jumlahTarik % 50000 != 0) {
    print('Penarikan harus lebih dari 0 dan kelipatan Rp 50.000.\n');
    return saldo;
  }

  if (jumlahTarik > saldo) {
    print('Saldo Anda tidak mencukupi untuk penarikan Rp $jumlahTarik.\n');
    return saldo;
  }

  print('\nPilih pecahan untuk total Rp $jumlahTarik:');
  final lembar50000 = bacaJumlahLembar('Jumlah lembar Rp 50.000: ');
  if (lembar50000 == null) return null;

  final lembar100000 = bacaJumlahLembar('Jumlah lembar Rp 100.000: ');
  if (lembar100000 == null) return null;

  final totalPecahan = (lembar50000 * 50000) + (lembar100000 * 100000);
  if (totalPecahan != jumlahTarik) {
    print(
      'Jumlah pecahan yang dipilih adalah Rp $totalPecahan, '
      'tidak sama dengan total penarikan Rp $jumlahTarik. '
      'Transaksi dibatalkan.\n',
    );
    return saldo;
  }

  final saldoBaru = saldo - jumlahTarik;
  print('Penarikan berhasil!');
  print('Rp 50.000: $lembar50000 lembar');
  print('Rp 100.000: $lembar100000 lembar');
  print('Total penarikan: Rp $jumlahTarik');
  print('Sisa saldo Anda: Rp $saldoBaru\n');
  return saldoBaru;
}

int? bacaJumlahLembar(String prompt) {
  while (true) {
    final jumlah = bacaAngka(prompt);
    if (jumlah == null) return null;
    if (jumlah >= 0) return jumlah;
    print('Jumlah lembar tidak boleh negatif. Silakan coba lagi.');
  }
}

int? bacaAngka(String prompt) {
  while (true) {
    stdout.write(prompt);
    final input = stdin.readLineSync();
    if (input == null) return null;

    final angka = int.tryParse(input.trim());
    if (angka != null) return angka;

    print('Input harus berupa angka. Silakan coba lagi.');
  }
}
