class Student < ApplicationRecord
    #attr_accessor :image, :remote_image_url
    belongs_to :user
    belongs_to :course # course id in school table

    #for image validation
    #mount_uploader :image, ImageUploader
    #validates_processing_of :image
    #validate :image_size_validation

    #form field validation
    validates :name, presence: true, length: {maximum: 255}, format: { :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/, message: "may only contain letters and numbers." }
    validates :code,  presence: true

    #simple search form
    def self.search(search)
        if search.present? 
            where('user_id = ?', search)
        else
            all   
        end
    end

    def self.to_csv(options = {})
        CSV.generate(options) do |csv|
          csv << column_names
          all.each do |student|
            csv << student.attributes.values_at(*column_names)
          end
        end
      end

    #private
    #def image_size_validation
     #   errors[:image] << "should be less than 500KB" if image.size > 0.5.megabytes
    #end
end
