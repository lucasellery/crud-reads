import 'package:read/read.dart';

class Read extends ManagedObject<_Read> implements _Read {
  @Serialize()
  String get detail => '$title by $author in year $year';
}

class _Read {
  @primaryKey
  int id;

  @Column(unique: true)
  String title;

  @Column()
  String author;

  @Column()
  int year;
}
