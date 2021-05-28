module Guide
  def test_read_magnect_card
    puts "Pass Card..."
    card =  Device::IO.read_card(5000)
    puts "Track1 #{card[:track1]} Track2:#{card[:track2]} Track3:#{card[:track2]}" 
  end
end

