module Guide
  # Input Output Test
  def test_input_output
    # Behaviour similar as c ruby
    # Device::IO.puts same as Kerne.puts(string, row=nil, column=nil)
    # puts is like a print + "\n"
    Device::IO.puts "Display at row 0 column 0", 0, 0
    puts "Pressed any key: ", 1
    # Wait for some key
    key = Device::IO.getc
    # Print key pressed
    print "key Pressed #{key}"
  end
end