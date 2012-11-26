def full_title(page_title)

  base_title = "Fest Mate"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

#  RSpec utilities - define page title for Spec tests