# Student Photo Upload Guide

This guide explains how to upload student photos to the EventSC system. All uploaded photos are automatically cropped to headshot format (3:4 portrait ratio) for consistency.

## Automatic Photo Processing

When you upload photos, the system will automatically:
- Crop images to headshot format (300x400 pixels, 3:4 ratio)
- Favor the upper portion of the image for better headshots
- Optimize file size and quality
- Generate thumbnail variants for different display sizes

You can configure this behavior in `config/initializers/photo_processing.rb`.

## 📋 Quick Summary

You have **3 main options** for bulk uploading student photos:

1. **🌐 Web Upload** (Recommended for small batches: 1-50 photos)
2. **⚡ Command Line** (Best for large batches: 50+ photos)  
3. **📁 Manual Upload** (Individual students)

---

## 🌐 Option 1: Web-Based Bulk Upload

### Access the Web Interface
1. Start your Rails server: `bin/dev`
2. Navigate to: `http://localhost:3000/students`
3. Click **"Bulk Upload Photos"** button (admin only)

### Upload Process
1. Select multiple photo files (Ctrl/Cmd + click)
2. Click **"Upload Photos"**
3. View results and any error messages

### Photo Naming Requirements
- Name files with student identifiers:
  - `john_doe.jpg` (short_name)
  - `john.jpg` (first_name)  
  - `doe.jpg` (last_name)
  - `john doe.jpg` (full_name)
- Supported separators: underscore `_`, dash `-`, space ` `
- Supported formats: JPG, PNG, GIF, WebP, BMP

---

## ⚡ Option 2: Command Line Bulk Upload

### Quick Start
```bash
# Navigate to your project directory
cd /home/nr/eventSC_fix

# Upload from a folder
rails students:bulk_upload_photos[/path/to/photos]

# Examples:
rails students:bulk_upload_photos[~/Desktop/student_photos]
rails students:bulk_upload_photos[/tmp/photos]
rails students:bulk_upload_photos[.]  # Current directory
```

### Helper Script (Easier)
```bash
# Make the helper executable (one time)
chmod +x photo_upload_helper.rb

# Show help
./photo_upload_helper.rb --help

# Upload photos
./photo_upload_helper.rb upload /path/to/photos

# Check statistics
./photo_upload_helper.rb stats

# List students without photos
./photo_upload_helper.rb list
```

### Useful Rails Tasks
```bash
# Show photo upload statistics
rails students:photo_stats

# List students who need photos
rails students:list_without_photos

# Bulk upload from directory
rails students:bulk_upload_photos[/path/to/directory]
```

---

## 📁 Option 3: Manual Individual Upload

1. Go to: `http://localhost:3000/students`
2. Click on a student's **"Edit"** link
3. Use the **"Photo"** field to upload
4. Save the student

---

## 📸 Photo Preparation Tips

### File Naming Best Practices
- **Consistent naming**: If you use `john_doe.jpg`, use underscores for all
- **Check student data**: View `/students` to see exact `short_name` values
- **Backup strategy**: Keep original photos in a separate folder

### File Requirements
- **Formats**: JPG, JPEG, PNG, GIF, WebP, BMP
- **Size**: Any size (automatically resized)
- **Quality**: Higher quality recommended (will be optimized)

### Naming Examples
```
✅ Good Examples:
- john_doe.jpg (matches short_name)
- jane-smith.png (matches short_name)  
- John.jpg (matches first_name)
- Smith.jpg (matches last_name)
- John Smith.jpg (matches full_name)

❌ Avoid:
- IMG_1234.jpg (no student identifier)
- john.doe.jpg (dots confuse the system)
- john_doe_photo.jpg (extra words)
```

---

## 🔧 Troubleshooting

### Common Issues & Solutions

**"Student not found" errors:**
- Check exact spelling of short_name in `/students`
- Try using first_name or last_name instead
- Ensure consistent separators (all _ or all -)

**"Upload failed" errors:**
- Check file isn't corrupted
- Ensure file format is supported
- Try smaller file sizes

**Photos not displaying:**
- Check that VIPS library is installed: `sudo apt install libvips-dev`
- Restart Rails server: `bin/dev`
- Clear browser cache

### Checking Upload Status
```bash
# See overall statistics
rails students:photo_stats

# List students still needing photos  
rails students:list_without_photos

# Check Rails logs for errors
tail -f log/development.log
```

---

## 📊 Monitoring Progress

### Web Interface
- Visit `/students` to see photo thumbnails
- Green checkmarks indicate successful uploads
- Red X indicates missing photos

### Command Line Monitoring
```bash
# Quick stats
rails students:photo_stats

# Detailed list of students without photos
rails students:list_without_photos

# Example output:
# 📊 Student Photo Statistics:
#    Total students: 150
#    With photos: 142 (94.7%)
#    Without photos: 8 (5.3%)
```

---

## 🚀 Advanced Usage

### Batch Processing Large Sets
```bash
# Process photos in smaller batches
ls /path/to/photos/*.jpg | head -50 | xargs -I {} cp {} /tmp/batch1/
rails students:bulk_upload_photos[/tmp/batch1]

# Continue with next batch
ls /path/to/photos/*.jpg | tail -n +51 | head -50 | xargs -I {} cp {} /tmp/batch2/
rails students:bulk_upload_photos[/tmp/batch2]
```

### Organizing Photos by Living Area
```bash
# Create folders by living area
mkdir -p uploads/{building1,building2,building3}

# Sort photos by student living areas
# Then upload each folder separately
rails students:bulk_upload_photos[uploads/building1]
rails students:bulk_upload_photos[uploads/building2]
```

### Automated Workflows
```bash
# Script to process new photos daily
#!/bin/bash
PHOTO_DIR="/path/to/new_photos"
if [ "$(ls -A $PHOTO_DIR)" ]; then
    cd /home/nr/eventSC_fix
    rails students:bulk_upload_photos[$PHOTO_DIR]
    mv $PHOTO_DIR/* /path/to/processed_photos/
fi
```

---

## 🔒 Security & Permissions

- Only **admin users** can access bulk upload features
- Photos are stored using Rails Active Storage (secure)
- Original photos are preserved and variants auto-generated
- Upload logs are recorded for audit trails

---

## 📞 Need Help?

1. **Check the logs**: `tail -f log/development.log`
2. **Use the helper script**: `./photo_upload_helper.rb --help`
3. **Test with small batches first** (5-10 photos)
4. **Verify student data** in `/students` before bulk upload

---

*This system automatically handles photo resizing, optimization, and variant generation for optimal performance across all views.*
