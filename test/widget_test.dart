import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';

void main() {
  testWidgets('ToDoIn App - Tambah Tugas dan Cek Tampilan', (WidgetTester tester) async {
    // Jalankan aplikasi
    await tester.pumpWidget(const TodoApp());

    // Temukan tombol tambah tugas dan klik
    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Isi judul tugas dan deskripsi
    await tester.enterText(find.byType(TextField).at(0), 'Belajar Flutter');
    await tester.enterText(find.byType(TextField).at(1), 'Deskripsi: Kerjakan tugas TodoIn App');

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

    // Verifikasi tugas muncul di daftar
    expect(find.text('Belajar Flutter'), findsOneWidget);
    expect(find.text('Kategori: Pribadi'), findsOneWidget);
    expect(find.text('Deskripsi: Kerjakan tugas TodoIn App'), findsOneWidget);
  });

  testWidgets('ToDoIn App - Ubah Mode Gelap', (WidgetTester tester) async {
    // Jalankan aplikasi
    await tester.pumpWidget(const TodoApp());

    // Temukan ikon mode gelap dan aktifkan
    expect(find.byType(Switch), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // Verifikasi mode gelap aktif
    final scaffoldFinder = find.byType(Scaffold);
    final scaffoldElement = tester.element(scaffoldFinder);
    final scaffold = scaffoldElement.widget as Scaffold;

    expect(scaffold.backgroundColor, equals(Colors.black)); // Warna gelap lebih pekat
  });

  testWidgets('ToDoIn App - Pencarian Tugas', (WidgetTester tester) async {
    // Jalankan aplikasi
    await tester.pumpWidget(const TodoApp());

    // Tambahkan tugas untuk diuji pencarian
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Beli bahan makanan');
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    // Cari tugas
    await tester.enterText(find.byType(TextField).first, 'Beli bahan makanan');
    await tester.pumpAndSettle();

    // Verifikasi tugas yang sesuai muncul
    expect(find.text('Beli bahan makanan'), findsOneWidget);
  });

  testWidgets('ToDoIn App - Tandai dan Hapus Tugas', (WidgetTester tester) async {
    // Jalankan aplikasi
    await tester.pumpWidget(const TodoApp());

    // Tambah tugas untuk diuji
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Belajar Bahasa Dart');
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    // Tandai tugas sebagai selesai
    final checkIcon = find.byIcon(Icons.check_circle);
    expect(checkIcon, findsOneWidget);
    await tester.tap(checkIcon);
    await tester.pumpAndSettle();

    // Verifikasi tugas ditandai selesai
    final textFinder = find.text('Belajar Bahasa Dart');
    expect(textFinder, findsOneWidget);

    // Hapus tugas dari daftar
    final deleteIcon = find.byIcon(Icons.delete);
    await tester.tap(deleteIcon);
    await tester.pumpAndSettle();

    // Verifikasi tugas terhapus
    expect(find.text('Belajar Bahasa Dart'), findsNothing);
  });
}
