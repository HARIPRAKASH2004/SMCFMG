class VendorModel {
  final String? id;
  final String? name;
  final String? description;
  final String? contactNumber;
  final String? email;
  final String? address;
  final List<ProductModel> products; // List of products related to the vendor
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Additional fields
  final String companyName;
  final String phone;
  final String status;
  final String city;
  final String pincode;
  final String gstNumber;
  final String contactPerson;
  final String category;
  final int productCount;
  final String state;

  VendorModel({
    this.id,
    this.name,
    this.description,
    this.contactNumber,
    this.email,
    this.address,
    this.products = const [], // Initialize products to an empty list
    this.createdAt,
    this.updatedAt,
    required this.companyName,
    required this.phone,
    required this.status,
    required this.city,
    required this.pincode,
    required this.gstNumber,
    required this.contactPerson,
    required this.category,
    required this.productCount,
    required this.state,
  });

  // Factory constructor to create a VendorModel from a Map
  factory VendorModel.fromMap(Map<String, dynamic> map) {
    return VendorModel(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
      description: map['description']?.toString(),
      contactNumber: map['contactNumber']?.toString(),
      email: map['email']?.toString(),
      address: map['address']?.toString(),
      products: map['products'] != null
          ? List<ProductModel>.from(
        map['products'].map((product) => ProductModel.fromMap(product)),
      )
          : [],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
      companyName: map['companyName']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      pincode: map['pincode']?.toString() ?? '',
      gstNumber: map['gstNumber']?.toString() ?? '',
      contactPerson: map['contactPerson']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      productCount: map['productCount'] != null
          ? int.tryParse(map['productCount'].toString())!
          : 0,
      state: map['state']?.toString() ?? '',
    );
  }

  get location => null;

  // Method to convert VendorModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
      'products': products.map((product) => product.toMap()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'companyName': companyName,
      'phone': phone,
      'status': status,
      'city': city,
      'pincode': pincode,
      'gstNumber': gstNumber,
      'contactPerson': contactPerson,
      'category': category,
      'productCount': productCount,
      'state': state,
    };
  }

  // Method to create a copy of the current VendorModel instance with updated fields
  VendorModel copyWith({
    String? id,
    String? name,
    String? description,
    String? contactNumber,
    String? email,
    String? address,
    List<ProductModel>? products,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? companyName,
    String? phone,
    String? status,
    String? city,
    String? pincode,
    String? gstNumber,
    String? contactPerson,
    String? category,
    int? productCount,
    String? state,
  }) {
    return VendorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      products: products ?? this.products,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      companyName: companyName ?? this.companyName,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      gstNumber: gstNumber ?? this.gstNumber,
      contactPerson: contactPerson ?? this.contactPerson,
      category: category ?? this.category,
      productCount: productCount ?? this.productCount,
      state: state ?? this.state,
    );
  }
}

class ProductModel {
  final String? id;
  final String? name;
  final String? description;
  final double? price;
  final String? category;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.category,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create a ProductModel from a Map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
      description: map['description']?.toString(),
      price: map['price'] != null ? double.tryParse(map['price'].toString()) : null,
      category: map['category']?.toString(),
      imageUrl: map['imageUrl']?.toString(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
    );
  }

  // Method to convert ProductModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Method to create a copy of the current ProductModel instance with updated fields
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
