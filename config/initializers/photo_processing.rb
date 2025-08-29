# Configuration for automatic photo cropping
Rails.application.configure do
  # Photo processing settings
  config.x.photo_processing = ActiveSupport::OrderedOptions.new
  
  # Enable automatic headshot cropping for uploaded photos (DISABLED)
  config.x.photo_processing.auto_crop_headshots = false
  
  # Target dimensions for headshots (width x height) - optimized for face crops
  config.x.photo_processing.headshot_width = 280
  config.x.photo_processing.headshot_height = 350
  
  # JPEG quality for processed images (0-100)
  config.x.photo_processing.jpeg_quality = 85
  
  # Whether to favor upper portion of image for cropping (good for headshots)
  config.x.photo_processing.favor_upper_crop = true
  
  # Crop bias - how much to favor the upper portion (0.0 = center, 0.5 = top)
  config.x.photo_processing.upper_crop_bias = 0.25
  
  # Face detection settings for tighter cropping
  # Padding around detected face (0.5 = 50% padding)
  config.x.photo_processing.face_padding_ratio = 0.4
  
  # Minimum face size as ratio of image (prevents cropping tiny faces)
  config.x.photo_processing.min_face_size_ratio = 0.15
end
