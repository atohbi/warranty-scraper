require 'open-uri'

class ParsingError < StandardError; end
class LookupError < StandardError; end

# Class for scraping Apple's self solve site.
# Currently only getting warranty expiration date is implemented:
#
#   Warranty.new('013977000323877').expiration_date
#
class Warranty

  def initialize(imei)
    @imei = imei
  end

  # Returns expiration date or nil if warranty has expired.
  def expiration_date
    @expiration_date ||= extract_warranty_date
  end

  private

  def details
    @details ||= scrape_page
  end

  def scrape_page
    uri = URI('https://selfsolve.apple.com/wcResults.do')
    uri.query = URI.encode_www_form({sn: @imei, num: 0}.to_a)
    uri.read
  end

  def extract_warranty_date
    case details
    when /warrantyPage\.warrantycheck\.displayHWSupportInfo\s*\(\s*true(.*)\)\;/
      if matches = $1.match(/Expiration Date\:\s*(.*\D\d{4})\D/)
        Date.parse(matches[0])
      else
        raise(ParsingError, 'Error parsing page content')
      end
    when /warrantyPage\.warrantycheck\.displayHWSupportInfo\s*\(\s*false/
      nil
    when /warrantyPage\.warrantycheck\.showErrors/
      raise(LookupError)
    else
      raise(ParsingError, 'Error parsing page content')
    end
  end

end
