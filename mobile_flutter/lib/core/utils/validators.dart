

class Validators {
  // Validate nomor pekerja (format: DRV001, SUP001, etc)
  static String? validateNoPekerja(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor pekerja tidak boleh kosong';
    }
    
    if (value.length < 5) {
      return 'Nomor pekerja minimal 5 karakter';
    }
    
    // Optional: Check format (3 huruf + 3 angka)
    final regex = RegExp(r'^[A-Z]{3}\d{3}$');
    if (!regex.hasMatch(value)) {
      return 'Format: 3 huruf + 3 angka (contoh: DRV001)';
    }
    
    return null;
  }

  // Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    
    return null;
  }

  // Validate nama (tidak boleh kosong)
  static String? validateNama(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    
    if (value.length < 3) {
      return 'Nama minimal 3 karakter';
    }
    
    return null;
  }

  // Validate nomor kendaraan (format: B 1234 XYZ)
  static String? validateNomorKendaraan(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor kendaraan tidak boleh kosong';
    }
    
    if (value.length < 5) {
      return 'Nomor kendaraan tidak valid';
    }
    
    return null;
  }

  // Validate dropdown selection
  static String? validateDropdown(dynamic value, String fieldName) {
    if (value == null || value.toString().isEmpty) {
      return '$fieldName harus dipilih';
    }
    
    return null;
  }

  // Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    
    return null;
  }

  // Validate GPS coordinates
  static bool isValidCoordinates(double? lat, double? lon) {
    if (lat == null || lon == null) return false;
    
    // Latitude: -90 to 90
    // Longitude: -180 to 180
    return lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180;
  }

  // Clean/trim string input
  static String cleanInput(String input) {
    return input.trim();
  }

  // Normalize nomor pekerja to uppercase
  static String normalizeNoPekerja(String input) {
    return cleanInput(input).toUpperCase();
  }

  // Normalize nomor kendaraan to uppercase
  static String normalizeNomorKendaraan(String input) {
    return cleanInput(input).toUpperCase();
  }
}