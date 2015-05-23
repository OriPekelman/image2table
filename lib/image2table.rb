# encoding: utf-8
$: .unshift(File.dirname(__FILE__))

require 'rmagick'
require "image2table/version"

class Image2table

  def initialize(image)
    @image = Magick::Image.read(image).first
    @rows = @image.rows
    @cols = @image.columns
    @colors = []
  end

  def to_table
    extract_colors
    generate_table
  end

  def to_html(output='image.html')
    extract_colors
    html = "<style>*{border:0;margin:0;padding:0;}td{width:1;height:1;}</style>"
    html << generate_table
    File.open(output, 'w') do |f|
      f.puts html
    end
  end


  private

  def extract_colors
    for y in (0...@rows)
      @colors[y] = []
      for x in (0...@cols)
        color = @image.pixel_color(x, y)
        hexa = sprintf('%02x%02x%02x', color.red&0xff, color.green&0xff, color.blue&0xff)
        if hexa[0] == hexa[1] && hexa[2] == hexa[3] && hexa[4] == hexa[5]
          hexa = "#{hexa[0]}#{hexa[2]}#{hexa[4]}"
        end
        @colors[y][x] = "##{hexa}"
      end
    end
  end

  def generate_table
    bgcolor = most_common_color
    html = "<table height='#{@rows}' width='#{@cols}' bgcolor='#{bgcolor}' style='border-collapse:collapse;border-spacing:0'>"
    for y in (0...@rows)
      html << "<tr>"
      cells = calulate_colspan(@colors[y])
      cells.each do |cell|
        html << "<td"
        html << " bgcolor='#{cell[:color]}'" if cell[:color] != bgcolor
        html << " colspan='#{cell[:repeat]}'" if cell[:repeat] > 1
        html << "/>"
      end
      html << "</tr>"
    end
    html << "</table>"
  end

  def most_common_color
    colors = @colors.flatten
    colors.group_by(&:itself).values.max_by(&:size).first
  end

  def calulate_colspan(colors)
    cells = []
    colors.each_with_index do |color, index|
      previous_cell = cells.last
      if index > 0 && color == previous_cell[:color]
        previous_cell[:repeat] += 1
      else
        cells << {color: color, repeat: 1}
      end
    end
    cells
  end
end