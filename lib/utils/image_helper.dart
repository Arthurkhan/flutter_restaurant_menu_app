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
      shape: RoundedRectangleBorder(
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
              Divider(),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                },
              ),
              SizedBox(height: 16),
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
    final filename = '${_uuid.v4()}${path.extension(imageFile.path)}';
    final savedFile = await imageFile.copy('${imagesDir.path}/$filename');
    
    return savedFile.path;
  }
  
  /// Returns a widget to display an image based on its path
  static Widget getImageWidget(String? imagePath, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (imagePath == null || imagePath.isEmpty) {
      return _buildPlaceholder(width: width, height: height);
    }
    
    try {
      if (imagePath.startsWith('assets/')) {
        return Image.asset(
          imagePath,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder(width: width, height: height);
          },
        );
      } else if (imagePath.startsWith('/')) {
        return Image.file(
          File(imagePath),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder(width: width, height: height);
          },
        );
      } else {
        return _buildPlaceholder(width: width, height: height);
      }
    } catch (e) {
      debugPrint('Error loading image: $e');
      return _buildPlaceholder(width: width, height: height);
    }
  }
  
  /// Builds a placeholder widget when no image is available
  static Widget _buildPlaceholder({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.image,
          size: 48,
          color: Colors.grey[600],
        ),
      ),
    );
  }
  
  /// Deletes an image file if it's a local file path
  static Future<bool> deleteImage(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty || imagePath.startsWith('assets/')) {
      return false;
    }
    
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }
  
  /// Creates a decorated container for image selection
  static Widget buildImagePickerWidget({
    required BuildContext context, 
    required String? currentImagePath,
    required Function(String?) onImageSelected,
    double? width,
    double? height,
    double? borderRadius,
  }) {
    return GestureDetector(
      onTap: () async {
        final newImagePath = await pickImage(context);
        if (newImagePath != null) {
          // Delete the old image if it's not an asset
          if (currentImagePath != null && 
              currentImagePath.isNotEmpty && 
              !currentImagePath.startsWith('assets/')) {
            await deleteImage(currentImagePath);
          }
          onImageSelected(newImagePath);
        }
      },
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              getImageWidget(currentImagePath, width: width, height: height),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}