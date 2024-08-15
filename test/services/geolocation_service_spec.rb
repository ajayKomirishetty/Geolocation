require 'minitest/autorun'
require 'webmock/minitest'
require_relative 'geolocation_service'

class GeolocationServiceTest < Minitest::Test
  def setup
    @ip_address = '8.8.8.8'
    @url = 'example.com'
    @geolocation_params_ip = { 'ip_address' => @ip_address }
    @geolocation_params_url = { 'url' => @url }
    @response_body = {
      'ip' => @ip_address,
      'loc' => '37.386,-122.0838',
      'country' => 'US',
      'region' => 'California',
      'org' => 'Google LLC',
      'postal' => '94035',
      'timezone' => 'America/Los_Angeles',
      'hostname' => 'dns.google',
      'city' => 'Mountain View'
    }.to_json

    # Stubbing HTTP request to ipinfo.io
    WebMock.stub_request(:get, "#{GeolocationService::BASE_URL}#{@ip_address}?access_key=#{GeolocationService::ACCESS_KEY}")
           .to_return(status: 200, body: @response_body)

    WebMock.stub_request(:get, "#{GeolocationService::BASE_URL}#{@url}?access_key=#{GeolocationService::ACCESS_KEY}")
           .to_return(status: 200, body: @response_body)
  end

  def test_get_geolocation_with_ip_address
    geolocation = GeolocationService.get_geolocation(@geolocation_params_ip)

    assert_equal @ip_address, geolocation.ip_address
    assert_equal '37.386', geolocation.latitude
    assert_equal '-122.0838', geolocation.longitude
    assert_equal 'US', geolocation.country
    assert_equal 'California', geolocation.region
    assert_equal 'Google LLC', geolocation.org
    assert_equal '94035', geolocation.postal
    assert_equal 'America/Los_Angeles', geolocation.timezone
    assert_equal 'dns.google', geolocation.hostname
    assert_equal 'Mountain View', geolocation.city
  end

  def test_get_geolocation_with_url
    geolocation = GeolocationService.get_geolocation(@geolocation_params_url)

    assert_equal @url, geolocation.url
    assert_equal '37.386', geolocation.latitude
    assert_equal '-122.0838', geolocation.longitude
    assert_equal 'US', geolocation.country
    assert_equal 'California', geolocation.region
    assert_equal 'Google LLC', geolocation.org
    assert_equal '94035', geolocation.postal
    assert_equal 'America/Los_Angeles', geolocation.timezone
    assert_equal 'dns.google', geolocation.hostname
    assert_equal 'Mountain View', geolocation.city
  end

  def test_api_returns_error
    WebMock.stub_request(:get, "#{GeolocationService::BASE_URL}#{@ip_address}?access_key=#{GeolocationService::ACCESS_KEY}")
           .to_return(status: 500)

    assert_raises(JSON::ParserError) do
      GeolocationService.get_geolocation(@geolocation_params_ip)
    end
  end
end
