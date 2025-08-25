require 'prawn'
require 'prawn-svg'
require 'prawn/measurement_extensions'
require 'front_matter_parser'

serif = 'fonts/signifier-regular.otf'
sans = 'fonts/soehne-buch.otf'

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
                            top_margin: 15.mm,
                            right_margin: 15.mm,
                            bottom_margin: 15.mm,
                            left_margin: 65.mm) do
    level1 = 0
    level2 = 0
    level3 = 0
    data.content.lines.each_with_index do |line, index|
      if line.start_with?('# ')
        level1 += 1
        level2 = 0
        level3 = 0
        h1 = "#{level1}. #{line.delete_prefix('# ')}"
        puts h1
        move_down 8.mm unless index.zero?
        font sans
        font_size 14
        text h1
      elsif line.start_with?('## ')
        level2 += 1
        h2 = "#{level1}.#{level2}. #{line.delete_prefix('## ')}"
        puts h2
        move_down 4.mm
        font sans
        font_size 10
        text h2
      elsif line.start_with?('### ')
        level3 += 1
        h3 = "#{level1}.#{level2}.#{level3} #{line.delete_prefix('### ')}"
        puts h3
        move_down 3.mm
        font serif
        font_size 9
        text h3
      elsif line == "\n"
        # Nothing, ignore newlines
      else
        move_down 1.mm
        font serif
        font_size 9
        text line, leading: 1.5
      end
    end
    # On each page
    repeat(:all, dynamic: true) do
      font sans
      font_size 22
      text_box  title,
                at: [-55.mm, 268.mm],
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
        y = 15.mm + index * 10.mm
        stroke_line [-55.mm, y], [-10.mm, y]
        draw_text mention, at: [-55.mm, y-6.mm], size: 8
      end
      svg IO.read("assets/logo-noesya.svg"), at: [-55.mm, 12.mm], width: 22.mm
    end
  end
  puts
end
