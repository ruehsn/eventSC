namespace :photos do
  desc "Process existing student photos to create headshot crops"
  task process_existing: :environment do
    puts "Processing existing student photos for headshot cropping..."
    
    processed_count = 0
    skipped_count = 0
    error_count = 0
    
    Student.includes(photo_attachment: :blob).each do |student|
      if student.photo.attached?
        print "Processing #{student.display_name}... "
        
        begin
          original_blob = student.photo.blob
          processed_blob = PhotoCroppingService.process_headshot(original_blob)
          
          if processed_blob && processed_blob != original_blob
            # Replace the photo with the processed version
            student.photo.purge
            student.photo.attach(processed_blob)
            puts "✓ Processed"
            processed_count += 1
          else
            puts "⚠ Skipped (no processing needed)"
            skipped_count += 1
          end
        rescue => e
          puts "✗ Error: #{e.message}"
          error_count += 1
        end
      else
        print "#{student.display_name}: "
        puts "⚠ No photo attached"
        skipped_count += 1
      end
    end
    
    puts "\nProcessing complete!"
    puts "Processed: #{processed_count}"
    puts "Skipped: #{skipped_count}"
    puts "Errors: #{error_count}"
  end
  
  desc "Show photo processing configuration"
  task show_config: :environment do
    config = Rails.application.config.x.photo_processing
    
    puts "Photo Processing Configuration:"
    puts "  Auto-crop headshots: #{config.auto_crop_headshots}"
    puts "  Target dimensions: #{config.headshot_width}x#{config.headshot_height}"
    puts "  JPEG quality: #{config.jpeg_quality}"
    puts "  Favor upper crop: #{config.favor_upper_crop}"
    puts "  Upper crop bias: #{config.upper_crop_bias}"
  end
  
  desc "Test photo processing on a single student"
  task :test, [:student_id] => :environment do |t, args|
    if args[:student_id].blank?
      puts "Usage: rails photos:test[student_id]"
      exit 1
    end
    
    student = Student.find(args[:student_id])
    
    unless student.photo.attached?
      puts "Student #{student.display_name} has no photo attached"
      exit 1
    end
    
    puts "Testing photo processing for #{student.display_name}..."
    
    begin
      original_blob = student.photo.blob
      puts "Original: #{original_blob.filename} (#{original_blob.byte_size} bytes)"
      
      processed_blob = PhotoCroppingService.process_headshot(original_blob)
      
      if processed_blob != original_blob
        puts "Processed: #{processed_blob.filename} (#{processed_blob.byte_size} bytes)"
        puts "Processing successful - would replace original photo"
      else
        puts "No processing applied (auto-crop disabled or processing skipped)"
      end
      
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace.first(5)
    end
  end
end
