def valid_dropbox_request?(message)
    digest = OpenSSL::Digest::SHA256.new
    signature = OpenSSL::HMAC.hexdigest(digest, APP_SECRET, message)
    request.headers['X-Dropbox-Signature'] == signature
end