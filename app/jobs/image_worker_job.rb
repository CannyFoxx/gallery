class ImageWorkerJob < ApplicationJob
  queue_as :default

  def perform(mn)
  	@post = Post.new(media: File.open(mn))
    @post.save
    File.delete(mn)
  end
end
