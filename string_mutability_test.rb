def change_string(my_string)
  my_string.gsub("x", "y")
end

original_string = "axbxcx"

new_string = change_string(original_string)

puts original_string
puts new_string
