class I18n
  include DaFunk::Helper

  DEFAULT_LOCALE      = "pt-br"
  DEFAULT_APPLICATION = "main"

  class << self
    attr_accessor :locale, :hash, :block_parse, :klasses
  end

  self.block_parse = Proc.new do |hash_,values_|
    if values_[1].is_a?(Hash)
      hash_[values_[0]] = values_[1].inject({}, &block_parse)
    else
      hash_[values_[0].to_sym] = values_[1]
    end
    hash_
  end

  def self.filepath(klass)
    "./#{klass}/i18n.json"
  end

  def self.configure(klass = DEFAULT_APPLICATION, locale = DEFAULT_LOCALE)
    @locale = locale
    unless self.configured?
      raise I18nError.new("File not found") if (! File.exists?(filepath(klass)))
      self.parse(klass)
      raise I18nError.new("Locale not found") unless language
    end
  end

  def self.configured?
    @hash && language
  end

  def self.parse(klass)
    @klasses ||= []
    if @hash
      self.merge(JSON.parse(File.read(filepath(klass))).inject({}, &block_parse))
    else
      @hash = JSON.parse(File.read(filepath(klass))).inject({}, &block_parse)
    end
    @klasses << klass
  end

  def self.merge(hash2)
    @hash ||= {}
    hash2.keys.each do |key|
      @hash[key] ||= {}
      @hash[key].merge!(hash2[key] || {})
    end
  end

  def self.language
    configure unless @hash
    @hash[@locale]
  end

  def self.t(symbol, options = {})
    if ! options[:time].nil?
      parse_time(get(symbol), options[:time])
    elsif options[:args]
      get(symbol) % options[:args]
    else
      get(symbol)
    end
  end

  def self.get(symbol)
    (language[symbol] || "No Translation").dup
  end

  def self.pt(symbol, options = {})
    puts(t(symbol, options), options[:line], options[:column])
  end

  def self.parse_time(value, time)
    value.sub("yy", time.year.to_s).
      sub("y", time.year.to_s[2..3]).
      sub("M", rjust(time.month.to_s, 2, "0")).
      sub("d", rjust(time.day.to_s, 2, "0")).
      sub("h", rjust(time.hour.to_s, 2, "0")).
      sub("m", rjust(time.min.to_s, 2, "0")).
      sub("s", rjust(time.sec.to_s, 2, "0"))
  end
end

