require 'rails_helper'

RSpec.describe GeolocationsController, type: :controller do
  let(:valid_ip_params) { { geolocation: { ip_address: '8.8.8.8' } } }
  let(:valid_url_params) { { geolocation: { url: 'example.com' } } }

  let(:geolocation) do
    Geolocation.create!(
      ip_address: '8.8.8.8',
      url: nil,
      latitude: '37.386',
      longitude: '-122.0838',
      country: 'US',
      region: 'California',
      org: 'Google LLC',
      postal: '94035',
      timezone: 'America/Los_Angeles',
      hostname: 'dns.google',
      city: 'Mountain View'
    )
  end

  before do
    allow(GeolocationService).to receive(:get_geolocation).and_return(geolocation)
  end

  describe 'POST #create' do
    context 'with valid IP address' do
      it 'creates a new geolocation and returns a created status' do
        expect {
          post :create, params: valid_ip_params
        }.to change(Geolocation, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['ip_address']).to eq('8.8.8.8')
      end
    end

    context 'with valid URL' do
      it 'creates a new geolocation and returns a created status' do
        expect {
          post :create, params: valid_url_params
        }.to change(Geolocation, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['url']).to eq('example.com')
      end
    end
  end

  describe 'GET #show' do
    context 'when geolocation exists' do
      it 'returns the geolocation data' do
        get :show, params: { id: geolocation.id }

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['ip_address']).to eq('8.8.8.8')
      end
    end

    context 'when geolocation does not exist' do
      it 'returns a not found status' do
        get :show, params: { id: 'nonexistent' }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Geolocation not found')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when geolocation exists' do
      it 'deletes the geolocation and returns a no content status' do
        geolocation # Ensure the geolocation is created

        expect {
          delete :destroy, params: { id: geolocation.id }
        }.to change(Geolocation, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when geolocation does not exist' do
      it 'returns a not found status' do
        expect {
          delete :destroy, params: { id: 'nonexistent' }
        }.not_to change(Geolocation, :count)

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Geolocation not found')
      end
    end
  end
end
