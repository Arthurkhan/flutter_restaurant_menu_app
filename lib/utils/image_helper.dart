import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../config/constants.dart';

/// Utility class for handling image selection and management
class ImageHelper {
  static final ImagePicker _picker = ImagePicker();
  static const _uuid = Uuid();

  /// Shows a modal bottom sheet with image source options
  static Future<String?> pickImage(BuildContext context) async {
    final source = await _showImageSourceDialog(context);
    if (source == null) return null;

    try {
      final XFile? imageFile = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (imageFile == null) return null;

      // Save the image to a persistent location
      final savedPath = await _saveImageLocally(File(imageFile.path));
      return savedPath;
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
      return null;
    }
  }

  /// Shows a dialog to choose between camera and gallery
  static Future<ImageSource?> _showImageSourceDialog(BuildContext context) async {
    return await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select Image Source',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  /// Saves an image file to the app's documents directory
  static Future<String> _saveImageLocally(File imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/menu_images');
    
    // Create the directory if it doesn't exist
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    
    // Generate a unique filename
    final filename = '${_uuid.v4()}${path.extension(imageFile.path)}';\n    final savedFile = await imageFile.copy('${imagesDir.path}/$filename');\n    \n    return savedFile.path;\n  }\n  \n  /// Returns a widget to display an image based on its path\n  static Widget getImageWidget(String? imagePath, {double? width, double? height, BoxFit fit = BoxFit.cover}) {\n    if (imagePath == null || imagePath.isEmpty) {\n      return _buildPlaceholder(width: width, height: height);\n    }\n    \n    try {\n      if (imagePath.startsWith('assets/')) {\n        return Image.asset(\n          imagePath,\n          width: width,\n          height: height,\n          fit: fit,\n          errorBuilder: (context, error, stackTrace) {\n            return _buildPlaceholder(width: width, height: height);\n          },\n        );\n      } else if (imagePath.startsWith('/')) {\n        return Image.file(\n          File(imagePath),\n          width: width,\n          height: height,\n          fit: fit,\n          errorBuilder: (context, error, stackTrace) {\n            return _buildPlaceholder(width: width, height: height);\n          },\n        );\n      } else {\n        return _buildPlaceholder(width: width, height: height);\n      }\n    } catch (e) {\n      debugPrint('Error loading image: $e');\n      return _buildPlaceholder(width: width, height: height);\n    }\n  }\n  \n  /// Builds a placeholder widget when no image is available\n  static Widget _buildPlaceholder({double? width, double? height}) {\n    return Container(\n      width: width,\n      height: height,\n      color: Colors.grey[300],\n      child: Center(\n        child: Icon(\n          Icons.image,\n          size: 48,\n          color: Colors.grey[600],\n        ),\n      ),\n    );\n  }\n  \n  /// Deletes an image file if it's a local file path\n  static Future<bool> deleteImage(String? imagePath) async {\n    if (imagePath == null || imagePath.isEmpty || imagePath.startsWith('assets/')) {\n      return false;\n    }\n    \n    try {\n      final file = File(imagePath);\n      if (await file.exists()) {\n        await file.delete();\n        return true;\n      }\n      return false;\n    } catch (e) {\n      debugPrint('Error deleting image: $e');\n      return false;\n    }\n  }\n  \n  /// Creates a decorated container for image selection\n  static Widget buildImagePickerWidget({\n    required BuildContext context, \n    required String? currentImagePath,\n    required Function(String?) onImageSelected,\n    double? width,\n    double? height,\n    double? borderRadius,\n  }) {\n    return GestureDetector(\n      onTap: () async {\n        final newImagePath = await pickImage(context);\n        if (newImagePath != null) {\n          // Delete the old image if it's not an asset\n          if (currentImagePath != null && \n              currentImagePath.isNotEmpty && \n              !currentImagePath.startsWith('assets/')) {\n            await deleteImage(currentImagePath);\n          }\n          onImageSelected(newImagePath);\n        }\n      },\n      child: Container(\n        width: width ?? double.infinity,\n        height: height ?? 200,\n        decoration: BoxDecoration(\n          borderRadius: BorderRadius.circular(borderRadius ?? 12),\n          border: Border.all(color: Colors.grey[400]!.withAlpha(255)),\n        ),\n        child: ClipRRect(\n          borderRadius: BorderRadius.circular(borderRadius ?? 12),\n          child: Stack(\n            fit: StackFit.expand,\n            children: [\n              getImageWidget(currentImagePath, width: width, height: height),\n              Container(\n                decoration: BoxDecoration(\n                  gradient: LinearGradient(\n                    begin: Alignment.bottomCenter,\n                    end: Alignment.center,\n                    colors: [\n                      Colors.black.withAlpha(128),\n                      Colors.transparent,\n                    ],\n                  ),\n                ),\n              ),\n              Positioned(\n                bottom: 12,\n                right: 12,\n                child: Container(\n                  padding: const EdgeInsets.all(8),\n                  decoration: BoxDecoration(\n                    color: Theme.of(context).primaryColor,\n                    shape: BoxShape.circle,\n                  ),\n                  child: const Icon(\n                    Icons.camera_alt,\n                    color: Colors.white,\n                    size: 20,\n                  ),\n                ),\n              ),\n            ],\n          ),\n        ),\n      ),\n    );\n  }\n}