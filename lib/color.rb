require 'color/reqs'
require 'color/rgb'
require 'color/rgb/colors'
require 'color/rgb/metallic'
require 'color/cmyk'
require 'color/grayscale'
require 'color/hsl'
require 'color/yiq'
require 'color/css'

class << Color
  def const_missing(name) #:nodoc:
    case name
    when "VERSION", :VERSION, "COLOR_TOOLS_VERSION", :COLOR_TOOLS_VERSION
      warn "Color::#{name} has been deprecated. Use Color::COLOR_VERSION instead."
      Color::COLOR_VERSION
    else
      if Color::RGB.const_defined?(name)
        warn "Color::#{name} has been deprecated. Use Color::RGB::#{name} instead."
        Color::RGB.const_get(name)
      else
        super
      end
    end
  end

  # Provides a thin veneer over the Color module to make it seem like this
  # is Color 0.1.0 (a class) and not Color 1.4 (a module). This
  # "constructor" will be removed in the future.
  #
  # mode = :hsl::   +values+ must be an array of [ hue deg, sat %, lum % ].
  #                 A Color::HSL object will be created.
  # mode = :rgb::   +values+ will either be an HTML-style colour string or
  #                 an array of [ red, green, blue ] (range 0 .. 255). A
  #                 Color::RGB object will be created.
  # mode = :cmyk::  +values+ must be an array of [ cyan %, magenta %, yellow
  #                 %, black % ]. A Color::CMYK object will be created.
  def new(values, mode = :rgb)
    warn "Color.new has been deprecated. Use Color::#{mode.to_s.upcase}.new instead."
    color = case mode
            when :hsl
              Color::HSL.new(*values)
            when :rgb
              values = [ values ].flatten
              if values.size == 1
                Color::RGB.from_html(*values)
              else
                Color::RGB.new(*values)
              end
            when :cmyk
              Color::CMYK.new(*values)
            end
    color.to_hsl
  end
end
