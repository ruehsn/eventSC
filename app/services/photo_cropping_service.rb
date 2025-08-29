class PhotoCroppingService
  # Crop uploaded photos to headshot format with smart face-aware cropping
  
  def self.process_headshot(photo_blob)
    return photo_blob unless photo_blob.attached?
    return photo_blob unless Rails.application.config.x.photo_processing.auto_crop_headshots
    
    # Download the image data
    image_data = photo_blob.download
    
    # Use VIPS to process the image
    image = Vips::Image.new_from_buffer(image_data, "")
    
    # Get image dimensions
    width  = image.width
    height = image.height
    
    # Get target dimensions from configuration
    target_width = Rails.application.config.x.photo_processing.headshot_width
    target_height = Rails.application.config.x.photo_processing.headshot_height
    jpeg_quality = Rails.application.config.x.photo_processing.jpeg_quality
    face_padding = Rails.application.config.x.photo_processing.face_padding_ratio
    min_face_size = Rails.application.config.x.photo_processing.min_face_size_ratio
    
    target_ratio = target_width.to_f / target_height.to_f
    current_ratio = width.to_f / height.to_f
    
    # Try face detection first for tighter cropping
    face_region = detect_face_region(image)
    
    cropped_image = if face_region
      # Face detected - crop tightly around the face with padding
      crop_around_face(image, face_region, target_ratio, face_padding, min_face_size)
    else
      # No face detected - fall back to smart cropping
      smart_crop_fallback(image, target_ratio, width, height)
    end
    
    # Resize to target dimensions
    final_image = cropped_image.resize(target_width.to_f / cropped_image.width)
    
    # Convert to JPEG with configured quality
    jpeg_data = final_image.write_to_buffer(".jpg[Q=#{jpeg_quality}]")
    
    # Create a new blob with the processed image
    processed_blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(jpeg_data),
      filename: "#{photo_blob.filename.base}_headshot.jpg",
      content_type: "image/jpeg"
    )
    
    processed_blob
  rescue => e
    Rails.logger.error "Error processing headshot: #{e.message}"
    # Return original blob if processing fails
    photo_blob
  end

  private

  # Detect face region using VIPS edge detection and heuristics
  def self.detect_face_region(image)
    begin
      # Convert to grayscale for processing
      gray = image.colourspace(:b_w)
      
      # Apply edge detection to find features
      edges = gray.sobel
      
      # Look for face-like regions in the upper 2/3 of the image
      height = image.height
      width = image.width
      search_height = (height * 0.67).to_i
      
      # Scan for regions with high edge density (likely faces)
      face_candidates = []
      
      # Divide image into a grid and analyze edge density
      grid_size = 20
      step_x = width / grid_size
      step_y = search_height / grid_size
      
      (0...grid_size).each do |y|
        (0...grid_size).each do |x|
          region_x = x * step_x
          region_y = y * step_y
          region_w = [step_x, width - region_x].min
          region_h = [step_y, search_height - region_y].min
          
          next if region_w <= 0 || region_h <= 0
          
          # Extract region and calculate edge density
          region = edges.crop(region_x, region_y, region_w, region_h)
          density = region.avg
          
          # If this region has high edge density, it might contain a face
          if density > 30 # Threshold for edge density
            face_candidates << {
              x: region_x,
              y: region_y,
              width: region_w,
              height: region_h,
              density: density,
              center_x: region_x + region_w / 2,
              center_y: region_y + region_h / 2
            }
          end
        end
      end
      
      # Find the best face candidate (highest density in upper portion)
      return nil if face_candidates.empty?
      
      best_candidate = face_candidates.max_by do |candidate|
        # Prefer faces in the upper portion and with high density
        upper_bias = 1.0 - (candidate[:center_y].to_f / search_height) * 0.5
        candidate[:density] * upper_bias
      end
      
      # Expand the region to include more of the face/head
      expansion_factor = 1.5
      face_x = [best_candidate[:center_x] - (best_candidate[:width] * expansion_factor / 2), 0].max.to_i
      face_y = [best_candidate[:center_y] - (best_candidate[:height] * expansion_factor / 2), 0].max.to_i
      face_w = [best_candidate[:width] * expansion_factor, width - face_x].min.to_i
      face_h = [best_candidate[:height] * expansion_factor, height - face_y].min.to_i
      
      {
        x: face_x,
        y: face_y,
        width: face_w,
        height: face_h,
        center_x: face_x + face_w / 2,
        center_y: face_y + face_h / 2
      }
    rescue => e
      Rails.logger.warn "Face detection failed: #{e.message}"
      nil
    end
  end

  # Crop image around detected face with appropriate padding
  def self.crop_around_face(image, face_region, target_ratio, face_padding, min_face_size)
    width = image.width
    height = image.height
    
    # Calculate face dimensions
    face_width = face_region[:width]
    face_height = face_region[:height]
    face_center_x = face_region[:center_x]
    face_center_y = face_region[:center_y]
    
    # Ensure minimum face size relative to image
    min_width = (width * min_face_size).to_i
    min_height = (height * min_face_size).to_i
    
    if face_width < min_width || face_height < min_height
      # Face too small, fall back to smart cropping
      return smart_crop_fallback(image, target_ratio, width, height)
    end
    
    # Add padding around the face
    padded_width = (face_width * (1 + face_padding)).to_i
    padded_height = (face_height * (1 + face_padding)).to_i
    
    # Adjust dimensions to match target ratio
    if padded_width.to_f / padded_height > target_ratio
      # Too wide, adjust height
      padded_height = (padded_width / target_ratio).to_i
    else
      # Too tall, adjust width
      padded_width = (padded_height * target_ratio).to_i
    end
    
    # Calculate crop coordinates centered on face
    crop_x = [face_center_x - padded_width / 2, 0].max
    crop_y = [face_center_y - padded_height / 2, 0].max
    
    # Ensure crop doesn't exceed image boundaries
    crop_x = [crop_x, width - padded_width].min if crop_x + padded_width > width
    crop_y = [crop_y, height - padded_height].min if crop_y + padded_height > height
    
    # Final boundary check
    final_width = [padded_width, width - crop_x].min
    final_height = [padded_height, height - crop_y].min
    
    image.crop(crop_x, crop_y, final_width, final_height)
  end

  # Fallback to original smart cropping logic
  def self.smart_crop_fallback(image, target_ratio, width, height)
    favor_upper = Rails.application.config.x.photo_processing.favor_upper_crop
    upper_bias = Rails.application.config.x.photo_processing.upper_crop_bias
    current_ratio = width.to_f / height.to_f
    
    if current_ratio > target_ratio
      # Image is too wide, crop horizontally (center crop)
      new_width = (height * target_ratio).to_i
      crop_x = (width - new_width) / 2
      image.crop(crop_x, 0, new_width, height)
    else
      # Image is too tall, crop vertically 
      new_height = (width / target_ratio).to_i
      if favor_upper
        # Favor upper portion for headshots
        crop_y = [(height - new_height) * upper_bias, 0].max.to_i
      else
        # Center crop
        crop_y = (height - new_height) / 2
      end
      image.crop(0, crop_y, width, new_height)
    end
  end
