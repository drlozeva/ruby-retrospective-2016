class CommandParser
  class Argument
    attr_accessor :name, :block
    def initialize(name, block)
      @name = name
      @block = block
    end
  end
  class Option
    attr_accessor :short, :long, :description, :block
    def initialize(short, long, description, block)
      @short = '-' + short
      @long = '--' + long
      @description = description
      @block = block
    end

    def can_handle?(element)
      element.include?(short) || element.include?(long)
    end

    def get_value(el)
      return true unless el.include?("=") || ( el[1] != '-' && el.size > 2 )
      el.include?("=") ? el.slice!(long + "=") : el.slice!(short)
      el
    end

    def help
      "#{@short}, #{@long} #{@description}"
    end
  end
  class OptionWithParameter < Option
    attr_accessor :parameter
    def initialize(short, long, description, parameter, block)
      super(short, long, description, block)
      @parameter = parameter
    end

    def help
      "#{short}, #{long} #{@parameter} #{@description}"
    end
  end

  def initialize(command_name)
    @command_name = command_name
    @arguments = []
    @current_argument = 0
    @options = []
  end

  def option?(element)
    element[0] == '-'
  end

  def argument?(element)
    element[0] != '-'
  end

  def parse(command_runner, argv)
    argv.each do |element|
      if option?(element)
        i = @options.index { |x| x.can_handle?(element) }
        @options[i].block.call(command_runner, @options[i].get_value(element))
      else
        @arguments[@current_argument].block.call(command_runner, element)
        @current_argument += 1
      end
    end
  end

  def argument(name, &block)
    @arguments.push(Argument.new(name, block))
  end

  def option(short, long, description, &block)
    @options.push(Option.new(short, long, description, block))
  end

  def option_with_parameter(short, long, help, desc, &block)
    @options.push(OptionWithParameter.new(short, long, help, desc, block))
  end

  def help
    message = "Usage: #{@command_name}"
    @arguments.each { |arg| message = message + ' [' + arg.name + ']' }
    @options.each do |opt|
      message = message + "\n    " + opt.short + ', ' + opt.long
      message = message + "=" + opt.parameter if opt.is_a?(OptionWithParameter)
      message = message + ' ' + opt.description
    end
    message
  end
end
