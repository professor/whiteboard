
desc "This is a one time script for making images smaller"
task :image_processing => :environment do |t|

# Reference material
# http://www.entropy.ch/software/Macosx/coreimagetool/
# http://www.macresearch.org/apples_coreimage_power_in_the_terminal
# http://developer.apple.com/documentation/GraphicsImaging/Reference/CoreImageFilterReference/Reference/reference.html
  

#       CoreImageTool load kids kids.jpg \
#            filter kids CILanczosScaleTransform scale=0.5 \
#            store kids kids-medium.jpg public.jpeg \
#            filter kids , output_directory scale=0.5 \
#            store kids kids-small.jpg public.jpeg


  image_directory = File.dirname(__FILE__) + "/../../public/images/"

#  master_directory = File.dirname(__FILE__) + "/../../original_images/students/2009/SM-original/"
#  output_directory = File.dirname(__FILE__) + "/../../original_images/students/2009/SM/"
  master_directory = "/Users/tsedano/Documents/subversion/cmu/something/students/2009/SM/"
  master_directory = "/Users/tsedano/Documents/subversion/cmu/SM/"
  output_directory = "/tmp/SM/"
  
  def lowercase_filetype(filename)
   parts = filename.split(".")
   filetype = parts.pop.downcase 
   return parts.join + "." + filetype
  end
  
  # originally I was going to build a tool that would recursively parse images,
  # but then I would need to check to see if directories in the ouptut directory existed,
  # instead, I'll assume that all the files are in one directory and are going to one directory.

  def process_image(image_path, output_directory)
   parts = image_path.split("/")
   filename = parts[parts.length - 1]
   image_small_path = output_directory + lowercase_filetype(filename)
   ratio = 0.125
   ratio = 0.071
    command = "CoreImageTool load my_image #{image_path} \
           filter my_image CILanczosScaleTransform scale=#{ratio} \
           store my_image #{image_small_path} public.jpeg"
   puts "processing #{image_path} #{image_small_path}"
   system(command)    
  end
  
  
  #Process lowercase JPG files
  Dir[master_directory + "**/*jpg"].each do | image_path|   
    process_image(image_path, output_directory)
  end 

  #Process uppercase JPG files
  Dir[master_directory + "**/*JPG"].each do | image_path|   
    process_image(image_path, output_directory)
  end


  
end
