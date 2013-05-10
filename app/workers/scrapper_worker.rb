class ScrapperWorker
  include Sidekiq::Worker

  def perform(url_with_channel, count)
    url, channel = url_with_channel
    images = Scrapper.new(url).images
    begin
      Pusher.trigger(channel, 'images', {:images => images})
    rescue Pusher::Error => e
      # (Pusher::AuthenticationError, Pusher::HTTPError, or Pusher::Error)
      Pusher.trigger(channel, 'error', {:error => e.message})
    end
  end
end