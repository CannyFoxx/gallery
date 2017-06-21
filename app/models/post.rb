class Post < ApplicationRecord
  has_attached_file :media, styles: { original: {convert_options: '-auto-orient'}, thumb: "160x160#", medium: "640x640#", high: "1024x1024#" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :media, content_type: /\Aimage\/.*\z/

  after_validation :extract_media_data, :reverse_geocode, on: :create
  reverse_geocoded_by :latitude, :longitude

  def next
    Post.order(date: :asc).where("date > ?", date).first
  end

  def prev
    Post.order(date: :asc).where("date < ?", date).last
  end

  private

  def extract_media_data
    begin
      @exif_file = EXIFR::JPEG.new(media.queued_for_write[:original].path)

      if @exif_file.gps
        self.gps = true
        self.latitude = @exif_file.gps.latitude
        self.longitude = @exif_file.gps.longitude
      end

      unless @exif_file.date_time.blank?
        self.date = @exif_file.date_time
      else
        self.date = Time.now
      end

    rescue EXIFR::MalformedJPEG
      self.date = Time.now
      return nil
    end
  end
end
