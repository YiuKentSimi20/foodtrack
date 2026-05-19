class CategorieMasaDto {
  final int id;
  final String nume;
  final int numarOrdine;
  final bool isActive;

  CategorieMasaDto({
    required this.id,
    required this.nume,
    required this.numarOrdine,
    required this.isActive,
  });

  factory CategorieMasaDto.fromJson(Map<String, dynamic> json) {
    return CategorieMasaDto(
      id: (json['id'] as num).toInt(),
      nume: (json['nume'] as String?) ?? 'Categorie',
      numarOrdine: (json['numar_ordine'] as num?)?.toInt() ?? 0,
      isActive: (json['is_active'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nume': nume,
      'numar_ordine': numarOrdine,
      'is_active': isActive,
    };
  }

  CategorieMasaDto copyWith({
    int? id,
    String? nume,
    int? numarOrdine,
    bool? isActive,
  }) {
    return CategorieMasaDto(
      id: id ?? this.id,
      nume: nume ?? this.nume,
      numarOrdine: numarOrdine ?? this.numarOrdine,
      isActive: isActive ?? this.isActive,
    );
  }
}