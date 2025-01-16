
class IndexDTO {
   String collection;

   String indexKey;
   String indexValue;

   String indexShowKey;
   String indexShowValue;

  IndexDTO({
    required this.collection,
    required this.indexKey,
    required this.indexValue,
    required this.indexShowKey,
    required this.indexShowValue,
  });

  factory IndexDTO.fromJson(Map<String, dynamic> json) {
    return IndexDTO(
      collection: json['collection'],

      indexKey: json['indexKey'],
      indexValue: json['indexValue'],

      indexShowKey: json['indexShowKey'], // Ensure this is parsed
      indexShowValue: json['indexShowValue'],
      
    );
  }
}
