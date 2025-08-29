namespace :students do
  desc "Bulk upload student photos from a directory"
  task :bulk_upload_photos, [:directory_path] => :environment do |task, args|
    directory_path = args[:directory_path]
    
    unless directory_path && Dir.exist?(directory_path)
      puts "❌ Error: Please provide a valid directory path"
      puts "Usage: rails students:bulk_upload_photos[/path/to/photos]"
      exit 1
    end

    puts "🔍 Scanning directory: #{directory_path}"
    
    # Find all image files
    image_extensions = %w[.jpg .jpeg .png .gif .webp .bmp]
    image_files = Dir.glob("#{directory_path}/*").select do |file|
      File.file?(file) && image_extensions.include?(File.extname(file).downcase)
    end
    
    if image_files.empty?
      puts "❌ No image files found in #{directory_path}"
      puts "Supported formats: #{image_extensions.join(', ')}"
      exit 1
    end

    puts "📸 Found #{image_files.count} image files"
    puts "📊 Processing uploads..."
    puts

    results = { success: [], failed: [] }
    
    image_files.each_with_index do |file_path, index|
      filename = File.basename(file_path, File.extname(file_path))
      student = find_student_by_identifier(filename)
      
      print "#{index + 1}/#{image_files.count} Processing #{File.basename(file_path)}... "
      
      if student
        begin
          student.photo.attach(
            io: File.open(photo_path),
            filename: File.basename(photo_path),
            content_type: "image/#{File.extname(photo_path)[1..]}"
          )
          # Note: Automatic cropping will be handled by the Student model callback
          puts "✓ #{student.display_name} (#{File.basename(photo_path)})"
          success_count += 1
        rescue => e
          puts "✗ #{File.basename(photo_path)}: #{e.message}"
          failed_count += 1
        end
      else
        results[:failed] << { file: File.basename(file_path), error: "Student not found" }
        puts "❌ Student not found"
      end
    end

    puts
    puts "📈 Upload Summary:"
    puts "✅ Successful: #{results[:success].count}"
    puts "❌ Failed: #{results[:failed].count}"
    puts
    
    if results[:success].any?
      puts "✅ Successfully uploaded photos for:"
      results[:success].each do |upload|
        puts "   • #{upload[:student]} (#{upload[:file]})"
      end
      puts
    end
    
    if results[:failed].any?
      puts "❌ Failed uploads:"
      results[:failed].each do |failure|
        puts "   • #{failure[:file]}: #{failure[:error]}"
      end
      puts
      puts "💡 Tips for failed uploads:"
      puts "   • Check that filenames match student short_names, first_names, or last_names"
      puts "   • Use formats: 'john_doe.jpg', 'jane-smith.png', or 'John Smith.jpg'"
      puts "   • Ensure image files are valid and not corrupted"
    end
  end

  desc "List students without photos"
  task list_without_photos: :environment do
    students_without_photos = Student.left_joins(:photo_attachment)
                                   .where(active_storage_attachments: { id: nil })
                                   .order(:short_name)
    
    if students_without_photos.any?
      puts "👥 Students without photos (#{students_without_photos.count}):"
      students_without_photos.each do |student|
        puts "   • #{student.short_name} - #{student.display_name}"
      end
    else
      puts "✅ All students have photos!"
    end
  end

  desc "Show photo upload statistics"
  task photo_stats: :environment do
    total_students = Student.count
    students_with_photos = Student.joins(:photo_attachment).count
    students_without_photos = total_students - students_with_photos
    
    puts "📊 Student Photo Statistics:"
    puts "   Total students: #{total_students}"
    puts "   With photos: #{students_with_photos} (#{(students_with_photos.to_f / total_students * 100).round(1)}%)"
    puts "   Without photos: #{students_without_photos} (#{(students_without_photos.to_f / total_students * 100).round(1)}%)"
  end

  private

  def find_student_by_identifier(identifier)
    # Clean the identifier (remove common separators and normalize)
    clean_id = identifier.gsub(/[-_\s]+/, ' ').strip.downcase
    
    # Try exact match on short_name first
    student = Student.find_by("LOWER(short_name) = ?", clean_id)
    return student if student

    # Try partial matches
    Student.where(
      "LOWER(short_name) LIKE ? OR LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(CONCAT(first_name, ' ', last_name)) LIKE ?",
      "%#{clean_id}%", "%#{clean_id}%", "%#{clean_id}%", "%#{clean_id}%"
    ).first
  end
end
