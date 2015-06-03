require 'open-uri'

class ParsingError < StandardError; end
class InvalidImeiError < StandardError; end

class Warranty

  def initialize(imei)
    @imei = imei
  end

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
    when /warrantyPage.warrantycheck.displayHWSupportInfo\s*\(\s*true(.*)\)\;/
      if matches = $1.match(/Expiration Date\:\s*(.*\D\d{4})\D/)
        Date.parse(matches[0])
      else
        raise(ParsingError, 'Can\'t parse the page')
      end
    else
      raise(ParsingError, 'Can\'t parse the page')
    end
  end

end
