class AddAdditionalFieldsToGeoLocation < ActiveRecord::Migration[7.1]
  def change
    add_column :geolocations, :region, :string
    add_column :geolocations, :org, :string
    add_column :geolocations, :hostname, :string
    add_column :geolocations, :postal, :integer
    add_column :geolocations, :timezone, :string
  end
end
