require 'prawn'
require 'prawn/measurement_extensions'
require 'front_matter_parser'

serif = 'fonts/Signifier-Regular.otf'
sans = 'fonts/Söhne-Buch.otf'

Dir.glob('data/*') do |file|
  data = FrontMatterParser::Parser.parse_file(file)
  document_name = "#{ file.split('/').last.gsub('.md', '') }-#{ data.front_matter['version'] }.pdf"
  file_name = "pdfs/#{ document_name }"
  title = data.front_matter['title']
  puts title
  Prawn::Document.generate( file_name,
                            page_size: 'A4',
                            top_margin: 10.mm,
                            right_margin: 10.mm,
                            bottom_margin: 10.mm,
                            left_margin: 65.mm) do
    chapters = data.content.split('#')
    chapters.shift
    chapters.each_with_index do |chapter, index|
      parts = chapter.split("\n")
      h1 = "#{index+1}. #{parts.shift}"
      p = parts.join("\n")
      puts h1
      move_down 5.mm unless index.zero?
      font sans
      font_size 15
      text h1
      move_down 2.mm
      font serif
      font_size 10
      text p, leading: 0
    end
    repeat(:all, dynamic: true) do
      font sans
      font_size 26
      text_box  title,
                at: [-55.mm, 277.mm],
                width: 50.mm,
                height: 75.mm
      line_width 0.25
      stroke_line [-55.mm, 150], [-10.mm, 150]
      draw_text "Page #{page_number}", at: [-55.mm, 0], size: 8
    end
  end
end
