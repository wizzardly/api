# frozen_string_literal: true

# Cloudflare masks the true IP
# This middleware ensures the Rails stack obtains the correct IP when using request.remote_ip
# See https://support.cloudflare.com/hc/en-us/articles/200170786

class CloudflareMiddleware
  def initialize(app)
    @app = app
  end

  def call(req)
    if req['HTTP_CF_CONNECTING_IP']
      req['HTTP_REMOTE_ADDR_BEFORE_CF'] = req['REMOTE_ADDR']
      req['HTTP_X_FORWARDED_FOR_BEFORE_CF'] = req['HTTP_X_FORWARDED_FOR']
      req['REMOTE_ADDR'] = req['HTTP_CF_CONNECTING_IP']
      req['HTTP_X_FORWARDED_FOR'] = req['HTTP_CF_CONNECTING_IP']
    end
    @app.call(req)
  end
end

Rails.application.config.middleware.insert_before(0, CloudflareMiddleware)
