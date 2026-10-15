class Book {
  final String id;
  final String title;
  final String author;
  final double price;
  final String? imageUrl;
  final String category;
  final String description;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    this.imageUrl,
    required this.category,
    required this.description,
  });
}

// Daftar buku statis untuk katalog
const List<Book> sampleBooks = [
  Book(
    id: 'b001',
    title: 'Laskar Pelangi',
    author: 'Andrea Hirata',
    price: 89000,
    category: 'Novel',
    description:
        'Kisah inspiratif tentang sepuluh anak kampung Belitong yang berjuang untuk mendapatkan pendidikan.',
  ),
  Book(
    id: 'b002',
    title: 'Bumi Manusia',
    author: 'Pramoedya Ananta Toer',
    price: 115000,
    category: 'Sastra',
    description:
        'Novel pertama dari Tetralogi Buru, mengisahkan Minke di era kolonial Belanda.',
  ),
  Book(
    id: 'b003',
    title: 'Atomic Habits',
    author: 'James Clear',
    price: 145000,
    category: 'Self-Help',
    description:
        'Panduan praktis membangun kebiasaan kecil yang membawa perubahan luar biasa dalam hidup.',
  ),
  Book(
    id: 'b004',
    title: 'Dilan: Dia adalah Dilanku Tahun 1990',
    author: 'Pidi Baiq',
    price: 79000,
    category: 'Novel',
    description:
        'Kisah cinta remaja yang manis antara Milea dan Dilan di Bandung tahun 1990.',
  ),
  Book(
    id: 'b005',
    title: 'Filosofi Teras',
    author: 'Henry Manampiring',
    price: 98000,
    category: 'Self-Help',
    description:
        'Memperkenalkan filsafat Stoa untuk menghadapi kesulitan hidup di era modern.',
  ),
  Book(
    id: 'b006',
    title: 'Negeri 5 Menara',
    author: 'Ahmad Fuadi',
    price: 92000,
    category: 'Novel',
    description:
        'Petualangan enam santri Pondok Madani yang bermimpi meraih cita-cita setinggi langit.',
  ),
];
