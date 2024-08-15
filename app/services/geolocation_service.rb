require 'net/http'
require 'json'

class GeolocationService
  BASE_URL = "http://ipinfo.io/"
  ACCESS_KEY = ENV['IPSTACK_API_KEY'] || "5e775eb501a9cb"

  class << self
    def get_geolocation(geolocation_params)
      identifier = extract_identifier(geolocation_params)
      uri = build_uri(identifier)
      response = fetch_data(uri)
      parse_geolocation_data(response, geolocation_params)
    end

    private

    def extract_identifier(geolocation_params)
      geolocation_params["ip_address"] || geolocation_params["url"]
    end

    def build_uri(identifier)
      URI("#{BASE_URL}#{identifier}?access_key=#{ACCESS_KEY}")
    end

    def fetch_data(uri)
      Net::HTTP.get(uri)
    end

    def parse_geolocation_data(response, geolocation_params)
      geolocation_data = JSON.parse(response)
      latitude, longitude = extract_lat_long(geolocation_data['loc'])

      Geolocation.new(
        ip_address: geolocation_params["ip_address"],
        url: geolocation_params["url"],
        latitude: latitude,
        longitude: longitude,
        country: geolocation_data['country'],
        region: geolocation_data['region'],
        org: geolocation_data['org'],
        postal: geolocation_data['postal'],
        timezone: geolocation_data['timezone'],
        hostname: geolocation_data['hostname'],
        city: geolocation_data['city']
      )
    end

    def extract_lat_long(loc)
      loc.split(",")
    end
  end
end
