class GeolocationsController < ApplicationController
  before_action :find_geolocation, only: [:show, :destroy]

  def create
    @geolocation = GeolocationService.get_geolocation(geolocation_params)
   
    if @geolocation.save
      render json: @geolocation, status: :created
    else
      render json: @geolocation.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @geolocation
  end

  def destroy
    if @geolocation
      @geolocation.destroy
      head :no_content
    else
      head :not_found
    end
  end      

  private

  def find_geolocation
    @geolocation = Geolocation.find_by(ip_address: params[:id]) || Geolocation.find_by(url: params[:id])
    render json: { error: 'Geolocation not found' }, status: :not_found unless @geolocation
  end

  def geolocation_params
    params.require(:geolocation).permit(:ip_address, :url)
  end
end
