#!/usr/bin/env ruby

# This script helps with bulk photo uploads for students
# Place this in your EventSC project root directory

require 'fileutils'

def show_help
  puts <<~HELP
    📸 EventSC Student Photo Bulk Upload Helper
    
    This script helps you prepare and upload student photos in bulk.
    
    METHODS:
    
    1. WEB UPLOAD (Recommended for smaller batches):
       - Go to: http://localhost:3000/students/bulk_upload
       - Select multiple photos
       - Upload through the web interface
    
    2. COMMAND LINE UPLOAD (Best for large batches):
       - Organize photos in a folder
       - Name files with student identifiers
       - Run: rails students:bulk_upload_photos[/path/to/photos]
    
    PHOTO NAMING CONVENTIONS:
    - Use student short_name: "john_doe.jpg"
    - Use first name: "john.jpg" 
    - Use last name: "doe.jpg"
    - Use full name: "john doe.jpg"
    - Separators: underscore, dash, or space
    
    SUPPORTED FORMATS:
    - JPG, JPEG, PNG, GIF, WebP, BMP
    
    USEFUL COMMANDS:
    - rails students:photo_stats          # Show upload statistics
    - rails students:list_without_photos  # List students needing photos
    
    EXAMPLES:
    
    1. Upload from Desktop folder:
       rails students:bulk_upload_photos[~/Desktop/student_photos]
    
    2. Upload from current directory:
       rails students:bulk_upload_photos[.]
    
    3. Check which students need photos:
       rails students:list_without_photos
    
    TIPS:
    - Photos are automatically resized and optimized
    - Existing photos will be replaced
    - Failed uploads show helpful error messages
    - Use consistent naming for best results
    
  HELP
end

def main
  if ARGV.include?('--help') || ARGV.include?('-h') || ARGV.empty?
    show_help
    exit 0
  end
  
  command = ARGV[0]
  
  case command
  when 'stats'
    system('rails students:photo_stats')
  when 'list'
    system('rails students:list_without_photos')
  when 'upload'
    if ARGV[1]
      system("rails students:bulk_upload_photos[#{ARGV[1]}]")
    else
      puts "❌ Please specify a directory path"
      puts "Usage: ruby photo_upload_helper.rb upload /path/to/photos"
    end
  else
    puts "❌ Unknown command: #{command}"
    puts "Use --help for usage information"
  end
end

main if __FILE__ == $0
