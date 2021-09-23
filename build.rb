require 'prawn'
require 'prawn-svg'
require 'prawn/measurement_extensions'
require 'front_matter_parser'

serif = 'fonts/Signifier-Regular.otf'
sans = 'fonts/Söhne-Buch.otf'

puts 'Generating documents'
puts

def extract_hierarchy(text, separator)
  chapters = []
  paragraph = ''
  text.each_line do |line|
    if line.start_with? separator
      chapters << paragraph unless paragraph.empty?
      paragraph = line.gsub(separator, '')
    else
      paragraph += "#{line}\n"
    end
  end
  chapters << paragraph
  chapters
end

Dir.glob('data/*') do |file|
  data = FrontMatterParser::Parser.parse_file(file)
  title = data.front_matter['title']
  version = data.front_matter['version']
  document_name = "#{ file.split('/').last.gsub('.md', '') }-#{ version }.pdf"
  file_name = "pdfs/#{ document_name }"
  puts title
  Prawn::Document.generate( file_name,
                            page_size: 'A4',
                            top_margin: 10.mm,
                            right_margin: 10.mm,
                            bottom_margin: 10.mm,
                            left_margin: 65.mm) do
    chapters = extract_hierarchy data.content, '# '
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
    # On each page
    repeat(:all, dynamic: true) do
      font sans
      font_size 22
      text_box  title,
                at: [-55.mm, 277.mm],
                width: 50.mm,
                height: 75.mm
      line_width 0.25
      [
        document_name,
        data.front_matter['date'],
        "Version #{ version }",
        "Page #{ page_number }",
        ''
      ].reverse.each_with_index do |mention, index|
        y = 10.mm + index * 10.mm
        stroke_line [-55.mm, y], [-10.mm, y]
        draw_text mention, at: [-55.mm, y-6.mm], size: 8
      end
      svg IO.read("assets/logo-noesya.svg"), at: [-55.mm, 5.mm], width: 22.mm
    end
  end
  puts
end
