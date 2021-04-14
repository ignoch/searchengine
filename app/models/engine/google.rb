module Engine
  class Google

    def url
      "https://www.googleapis.com/customsearch/v1?key=#{api_key}&cx=#{cx_code}:omuauf_lfve"
    end

    private

    def api_key
      ENV['GOOGLE_API_KEY'].to_s
    end

    def cx_code
      ENV['GOOGLE_CX_CODE'].to_s
    end
  end
end
