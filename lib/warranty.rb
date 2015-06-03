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
  end

  def extract_warranty_date
  end

end
