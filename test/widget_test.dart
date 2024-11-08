import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';

void main() {
  testWidgets('ToDoIn App - Tambah Tugas dan Cek Tampilan', (WidgetTester tester) async {
    await tester.pumpWidget(TodoApp());

    // Temukan dan klik tombol tambah tugas
    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Isi judul tugas
    await tester.enterText(find.byType(TextField).first, 'Belajar Flutter');
    await tester.enterText(find.byType(TextField).last, 'Deskripsi: Kerjakan tugas TodoIn App');

    // Pilih kategori
    await tester.tap(find.text('Pekerjaan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pribadi').last);
    await tester.pumpAndSettle();

    // Pilih prioritas
    await tester.tap(find.text('Tinggi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sedang').last);
    await tester.pumpAndSettle();

    // Tambahkan tugas
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    // Verifikasi tugas muncul di layar
    expect(find.text('Belajar Flutter'), findsOneWidget);
    expect(find.text('Kategori: Pribadi'), findsOneWidget);
    expect(find.text('Deskripsi: Kerjakan tugas TodoIn App'), findsOneWidget);
  });

  testWidgets('ToDoIn App - Ubah Mode Gelap', (WidgetTester tester) async {
    await tester.pumpWidget(TodoApp());

    // Temukan saklar mode gelap dan aktifkan
    expect(find.byType(Switch), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // Verifikasi mode gelap aktif
    expect(Theme.of(tester.element(find.byType(Scaffold))).brightness, Brightness.dark);
  });

  testWidgets('ToDoIn App - Pencarian Tugas', (WidgetTester tester) async {
    await tester.pumpWidget(TodoApp());

    // Tambahkan tugas untuk diuji pencariannya
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Beli bahan makanan');
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    // Cari tugas yang baru ditambahkan
    await tester.enterText(find.byType(TextField).first, 'Beli bahan makanan');
    await tester.pumpAndSettle();

    // Verifikasi tugas yang sesuai muncul
    expect(find.text('Beli bahan makanan'), findsOneWidget);
  });

  testWidgets('ToDoIn App - Tandai dan Hapus Tugas', (WidgetTester tester) async {
    await tester.pumpWidget(TodoApp());

    // Tambah tugas untuk diuji
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Belajar Bahasa Dart');
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    // Tandai tugas sebagai selesai
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();
    expect(find.text('Belajar Bahasa Dart'), findsNothing);

    // Hapus tugas dari daftar
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Verifikasi tugas terhapus
    expect(find.text('Belajar Bahasa Dart'), findsNothing);
  });
}
