class HolidaySearch
  # def holiday_information
  #   response = HTTParty.get('https://date.nager.at/api/v3/NextPublicHolidays/US')
  #   parsed_holidays = JSON.parse(response.body, symbolize_names: true)
  #   until parsed_holidays.count == 3 do
  #     parsed_holidays.pop
  #   end
  # end
  def initialize
  end

  def holidays
    service.holidays.map do |data|
      Holiday.new(data)
    end
  end

  def service
    NagerDateService.new
  end

  def next_3
    holidays[0..2]
  end


    # until parsed_holidays.count == 3 do
    #   parsed_holidays.pop
    # end
end
