import 'package:flutter/material.dart';

class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String? brand;
  final String sku;
  final double weight;
  final DimensionsModel dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  // final List<ReviewModel> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final MetaModel meta;
  final List<String> images;
  final String thumbnail;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    // required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.images,
    required this.thumbnail,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'] as int,
      tags: List<String>.from(json['tags'] ?? []),
      brand: json['brand'] as String?,
      sku: json['sku'] as String,
      weight: (json['weight'] as num).toDouble(),
      dimensions: DimensionsModel.fromJson(
          json['dimensions'] as Map<String, dynamic>),
      warrantyInformation: json['warrantyInformation'] as String,
      shippingInformation: json['shippingInformation'] as String,
      availabilityStatus: json['availabilityStatus'] as String,
      // reviews: (json['reviews'] as List<dynamic>)
      //     .map((r) => ReviewModel.fromJson(r as Map<String, dynamic>))
      //     .toList(),
      returnPolicy: json['returnPolicy'] as String,
      minimumOrderQuantity: json['minimumOrderQuantity'] as int,
      meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
      images: List<String>.from(json['images'] ?? []),
      thumbnail: json['thumbnail'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'price': price,
        'discountPercentage': discountPercentage,
        'rating': rating,
        'stock': stock,
        'tags': tags,
        'brand': brand,
        'sku': sku,
        'weight': weight,
        'dimensions': dimensions.toJson(),
        'warrantyInformation': warrantyInformation,
        'shippingInformation': shippingInformation,
        'availabilityStatus': availabilityStatus,
        // 'reviews': reviews.map((r) => r.toJson()).toList(),
        'returnPolicy': returnPolicy,
        'minimumOrderQuantity': minimumOrderQuantity,
        'meta': meta.toJson(),
        'images': images,
        'thumbnail': thumbnail,
      };

  // Computed helpers
  double get discountedPrice =>
      price - (price * discountPercentage / 100);

  bool get isLowStock => stock < 10;

  bool get isInStock => availabilityStatus == 'In Stock';
}

// ── dimensions_model.dart ────────────────────────────────────
class DimensionsModel {
  final double width;
  final double height;
  final double depth;

  const DimensionsModel({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory DimensionsModel.fromJson(Map<String, dynamic> json) =>
      DimensionsModel(
        width: (json['width'] as num).toDouble(),
        height: (json['height'] as num).toDouble(),
        depth: (json['depth'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'depth': depth,
      };
}

// ── review_model.dart ────────────────────────────────────────
// class ReviewModel {
//   final int rating;
//   final String comment;
//   final String date;
//   final String reviewerName;
//   final String reviewerEmail;

//   const ReviewModel({
//     required this.rating,
//     required this.comment,
//     required this.date,
//     required this.reviewerName,
//     required this.reviewerEmail,
//   });

//   factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
//         rating: json['rating'] as int,
//         comment: json['comment'] as String,
//         date: json['date'] as String,
//         reviewerName: json['reviewerName'] as String,
//         reviewerEmail: json['reviewerEmail'] as String,
//       );

//   Map<String, dynamic> toJson() => {
//         'rating': rating,
//         'comment': comment,
//         'date': date,
//         'reviewerName': reviewerName,
//         'reviewerEmail': reviewerEmail,
//       };
// }



class CommentTile extends StatelessWidget {
  final String name;
  final String comment;
  final int rating;
  final String timeAgo;
  final bool isOwn;
  final VoidCallback? onDelete;
  const CommentTile({
    super.key,
    required this.name,
    required this.comment,
    required this.rating,
    required this.timeAgo,
    this.isOwn = false,
    this.onDelete,
  });
  @override
  Widget build(BuildContext context) => const SizedBox(); // use your real widget
}
// ── meta_model.dart ──────────────────────────────────────────
class MetaModel {
  final String createdAt;
  final String updatedAt;
  final String barcode;
  final String qrCode;

  const MetaModel({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) => MetaModel(
        createdAt: json['createdAt'] as String,
        updatedAt: json['updatedAt'] as String,
        barcode: json['barcode'] as String,
        qrCode: json['qrCode'] as String,
      );

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'barcode': barcode,
        'qrCode': qrCode,
      };
}

// ── products_response_model.dart (للـ list endpoints) ────────
class ProductsResponseModel {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  const ProductsResponseModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) =>
      ProductsResponseModel(
        products: (json['products'] as List<dynamic>)
            .map((p) =>
                ProductModel.fromJson(p as Map<String, dynamic>))
            .toList(),
        total: json['total'] as int,
        skip: json['skip'] as int,
        limit: json['limit'] as int,
      );
}

// ── category_model.dart ──────────────────────────────────────
class CategoryModel {
  final String slug;
  final String name;
  final String url;

  const CategoryModel({
    required this.slug,
    required this.name,
    required this.url,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      CategoryModel(
        slug: json['slug'] as String,
        name: json['name'] as String,
        url: json['url'] as String,
      );

  Map<String, dynamic> toJson() => {
        'slug': slug,
        'name': name,
        'url': url,
      };
}

// ── add_product_request_model.dart ───────────────────────────
class AddProductRequestModel {
  final String title;
  final String? description;
  final double? price;
  final String? category;
  final double? discountPercentage;
  final String? thumbnail;

  const AddProductRequestModel({
    required this.title,
    this.description,
    this.price,
    this.category,
    this.discountPercentage,
    this.thumbnail,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'title': title};
    if (description != null) map['description'] = description;
    if (price != null) map['price'] = price;
    if (category != null) map['category'] = category;
    if (discountPercentage != null) {
      map['discountPercentage'] = discountPercentage;
    }
    if (thumbnail != null) map['thumbnail'] = thumbnail;
    return map;
  }
}

// ── update_product_request_model.dart ────────────────────────
class UpdateProductRequestModel {
  final String? title;
  final String? description;
  final double? price;
  final String? category;
  final double? discountPercentage;
  final int? stock;

  const UpdateProductRequestModel({
    this.title,
    this.description,
    this.price,
    this.category,
    this.discountPercentage,
    this.stock,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (title != null) map['title'] = title;
    if (description != null) map['description'] = description;
    if (price != null) map['price'] = price;
    if (category != null) map['category'] = category;
    if (discountPercentage != null) {
      map['discountPercentage'] = discountPercentage;
    }
    if (stock != null) map['stock'] = stock;
    return map;
  }
}

// ── deleted_product_model.dart ───────────────────────────────
class DeletedProductModel extends ProductModel {
  final bool isDeleted;
  final String deletedOn;

  const DeletedProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.price,
    required super.discountPercentage,
    required super.rating,
    required super.stock,
    required super.tags,
    super.brand,
    required super.sku,
    required super.weight,
    required super.dimensions,
    required super.warrantyInformation,
    required super.shippingInformation,
    required super.availabilityStatus,
    // required super.reviews,
    required super.returnPolicy,
    required super.minimumOrderQuantity,
    required super.meta,
    required super.images,
    required super.thumbnail,
    required this.isDeleted,
    required this.deletedOn,
  });

  factory DeletedProductModel.fromJson(Map<String, dynamic> json) {
    final base = ProductModel.fromJson(json);
    return DeletedProductModel(
      id: base.id,
      title: base.title,
      description: base.description,
      category: base.category,
      price: base.price,
      discountPercentage: base.discountPercentage,
      rating: base.rating,
      stock: base.stock,
      tags: base.tags,
      brand: base.brand,
      sku: base.sku,
      weight: base.weight,
      dimensions: base.dimensions,
      warrantyInformation: base.warrantyInformation,
      shippingInformation: base.shippingInformation,
      availabilityStatus: base.availabilityStatus,
      // reviews: base.reviews,
      returnPolicy: base.returnPolicy,
      minimumOrderQuantity: base.minimumOrderQuantity,
      meta: base.meta,
      images: base.images,
      thumbnail: base.thumbnail,
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedOn: json['deletedOn'] as String? ?? '',
    );
  }
}
