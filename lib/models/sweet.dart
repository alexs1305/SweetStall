class Sweet {
  final String id;
  final String name;

  const Sweet({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sweet && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);

  @override
  String toString() => 'Sweet(id: $id, name: $name)';
}
